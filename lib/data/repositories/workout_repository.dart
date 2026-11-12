import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';

class WorkoutSetInput {
  const WorkoutSetInput({
    required this.exerciseName,
    required this.reps,
    required this.weightKg,
  });

  final String exerciseName;
  final int reps;
  final double weightKg;
}

class WorkoutLog {
  const WorkoutLog({required this.workout, required this.sets});

  final Workout workout;
  final List<WorkoutSet> sets;
}

class WorkoutRepository {
  WorkoutRepository(this._database);

  final AppDatabase _database;

  Future<void> saveWorkout({
    required DateTime date,
    String? notes,
    required List<WorkoutSetInput> sets,
  }) async {
    if (sets.isEmpty) {
      throw ArgumentError.value(sets, 'sets', 'At least one set is required.');
    }
    for (final set in sets) {
      final name = set.exerciseName.trim();
      if (name.isEmpty) {
        throw ArgumentError.value(
          set.exerciseName,
          'exerciseName',
          'Exercise name is required.',
        );
      }
      if (set.reps <= 0) {
        throw ArgumentError.value(
          set.reps,
          'reps',
          'Reps must be a positive whole number.',
        );
      }
      if (!set.weightKg.isFinite || set.weightKg < 0) {
        throw ArgumentError.value(
          set.weightKg,
          'weightKg',
          'Weight must be zero or more.',
        );
      }
    }

    await _database.transaction(() async {
      final workoutId = await _database.into(_database.workouts).insert(
            WorkoutsCompanion.insert(
              startedAt: DateTime(date.year, date.month, date.day).toUtc(),
              notes:
                  Value(notes?.trim().isEmpty == true ? null : notes?.trim()),
            ),
          );
      for (var index = 0; index < sets.length; index++) {
        final set = sets[index];
        final name = set.exerciseName.trim();
        final existingExercise = await (_database.select(_database.exercises)
              ..where((exercise) => exercise.name.equals(name)))
            .getSingleOrNull();
        final exerciseId = existingExercise?.id ??
            await _database.into(_database.exercises).insert(
                  ExercisesCompanion.insert(name: name),
                );
        await _database.into(_database.workoutSets).insert(
              WorkoutSetsCompanion.insert(
                workoutId: workoutId,
                exerciseId: exerciseId,
                setNumber: index + 1,
                reps: set.reps,
                weightKg: set.weightKg,
              ),
            );
      }
    });
  }

  Future<List<WorkoutLog>> getTodayWorkouts([DateTime? now]) async {
    final localNow = now ?? DateTime.now();
    final startOfDay = DateTime(localNow.year, localNow.month, localNow.day);
    final startOfTomorrow = startOfDay.add(const Duration(days: 1));
    final workouts = await (_database.select(_database.workouts)
          ..where(
            (workout) =>
                workout.startedAt.isBiggerOrEqualValue(startOfDay.toUtc()) &
                workout.startedAt.isSmallerThanValue(startOfTomorrow.toUtc()),
          )
          ..orderBy([(workout) => OrderingTerm.desc(workout.startedAt)]))
        .get();
    final result = <WorkoutLog>[];
    for (final workout in workouts) {
      final sets = await (_database.select(_database.workoutSets)
            ..where((set) => set.workoutId.equals(workout.id))
            ..orderBy([(set) => OrderingTerm.asc(set.setNumber)]))
          .get();
      result.add(WorkoutLog(workout: workout, sets: sets));
    }
    return result;
  }
}

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository(ref.watch(databaseProvider));
});
