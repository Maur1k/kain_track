import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kain_track/data/db/database.dart';
import 'package:kain_track/features/workouts/log_workout_screen.dart';

void main() {
  testWidgets('saves a workout session', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: LogWorkoutScreen()),
      ),
    );
    await tester.enterText(find.byType(TextField).first, 'Run');
    await tester.tap(find.text('Save workout'));
    await tester.pumpAndSettle();
    expect(await database.select(database.workoutSessions).get(), hasLength(1));
  });
}
