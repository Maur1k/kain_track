import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kain_track/data/db/database.dart';
import 'package:kain_track/data/repositories/workout_repository.dart';

void main() {
  test('saves and lists sessions newest first', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = WorkoutRepository(database);
    await repository.addSession(
      name: 'Run',
      durationMinutes: 30,
      notes: 'Easy pace',
      performedAt: DateTime(2026, 11, 12, 8),
    );
    await repository.addSession(
      name: 'Lift',
      durationMinutes: 45,
      performedAt: DateTime(2026, 11, 12, 18),
    );
    final sessions = await repository.listByDate(DateTime(2026, 11, 12));
    expect(sessions.map((session) => session.name), ['Lift', 'Run']);
  });
}
