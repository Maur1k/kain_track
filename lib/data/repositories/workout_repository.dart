import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';

class WorkoutRepository {
  WorkoutRepository(this._database);

  final AppDatabase _database;

  Future<void> addSession({
    required String name,
    int? durationMinutes,
    String? notes,
    required DateTime performedAt,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError.value(name, 'name', 'Workout name is required.');
    }
    if (durationMinutes != null && durationMinutes <= 0) {
      throw ArgumentError.value(
        durationMinutes,
        'durationMinutes',
        'Duration must be positive.',
      );
    }
    await _database.into(_database.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            name: name.trim(),
            durationMinutes: Value(durationMinutes),
            notes: Value(notes?.trim().isEmpty == true ? null : notes?.trim()),
            performedAt: performedAt.toUtc(),
          ),
        );
  }

  Future<List<WorkoutSession>> listByDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day).toUtc();
    final end = start.add(const Duration(days: 1));
    return (_database.select(_database.workoutSessions)
          ..where(
            (session) =>
                session.performedAt.isBiggerOrEqualValue(start) &
                session.performedAt.isSmallerThanValue(end),
          )
          ..orderBy([(session) => OrderingTerm.desc(session.performedAt)]))
        .get();
  }

  Future<void> deleteSession(int id) async {
    await (_database.delete(_database.workoutSessions)
          ..where((session) => session.id.equals(id)))
        .go();
  }
}

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository(ref.watch(databaseProvider));
});

final todayWorkoutsProvider = FutureProvider<List<WorkoutSession>>((ref) {
  return ref.watch(workoutRepositoryProvider).listByDate(DateTime.now());
});
