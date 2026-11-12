import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kain_track/data/db/database.dart';
import 'package:kain_track/data/repositories/workout_repository.dart';

void main() {
  late AppDatabase database;
  late WorkoutRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = WorkoutRepository(database);
  });

  tearDown(() => database.close());

  test('saves a workout and its sets', () async {
    await repository.saveWorkout(
      date: DateTime(2026, 11, 12),
      notes: 'Leg day',
      sets: const [
        WorkoutSetInput(exerciseName: 'Squat', reps: 5, weightKg: 80),
        WorkoutSetInput(exerciseName: 'Squat', reps: 5, weightKg: 80),
      ],
    );

    final workouts = await repository.getTodayWorkouts(DateTime(2026, 11, 12));
    expect(workouts, hasLength(1));
    expect(workouts.single.workout.notes, 'Leg day');
    expect(workouts.single.sets, hasLength(2));
  });

  test('reuses an exercise by name', () async {
    const set =
        WorkoutSetInput(exerciseName: 'Bench press', reps: 8, weightKg: 50);
    await repository.saveWorkout(date: DateTime(2026, 11, 12), sets: [set]);
    await repository.saveWorkout(date: DateTime(2026, 11, 12), sets: [set]);

    expect(await database.select(database.exercises).get(), hasLength(1));
  });

  test('validates set values', () async {
    expect(
      () => repository.saveWorkout(
        date: DateTime(2026, 11, 12),
        sets: const [
          WorkoutSetInput(exerciseName: '', reps: 1, weightKg: 0),
        ],
      ),
      throwsArgumentError,
    );
    expect(
      () => repository.saveWorkout(
        date: DateTime(2026, 11, 12),
        sets: const [
          WorkoutSetInput(exerciseName: 'Squat', reps: 0, weightKg: 0),
        ],
      ),
      throwsArgumentError,
    );
    expect(
      () => repository.saveWorkout(
        date: DateTime(2026, 11, 12),
        sets: const [
          WorkoutSetInput(exerciseName: 'Squat', reps: 1, weightKg: -1),
        ],
      ),
      throwsArgumentError,
    );
  });

  test('returns only workouts for today', () async {
    await repository.saveWorkout(
      date: DateTime(2026, 11, 12),
      sets: const [
        WorkoutSetInput(exerciseName: 'Squat', reps: 5, weightKg: 80)
      ],
    );
    await repository.saveWorkout(
      date: DateTime(2026, 11, 11),
      sets: const [WorkoutSetInput(exerciseName: 'Run', reps: 5, weightKg: 0)],
    );

    expect(
      await repository.getTodayWorkouts(DateTime(2026, 11, 12)),
      hasLength(1),
    );
  });
}
