import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kain_track/data/db/database.dart';
import 'package:kain_track/data/io/backup_service.dart';

void main() {
  late AppDatabase database;
  late BackupService service;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    service = BackupService(database);
  });

  tearDown(() => database.close());

  test('round trips every table and preserves foreign-key IDs', () async {
    await _insertSample(database);
    final before = await _readAll(database);
    final exported = await service.exportJson();

    await service.importJson(_emptyBackup());
    expect(await _readAll(database), isNot(equals(before)));

    await service.importJson(exported);
    expect(await _readAll(database), equals(before));
  });

  test('imports the sample backup fixture', () async {
    await service.importJson(
      await File('test/fixtures/sample_backup.json').readAsString(),
    );

    expect(
        (await database.select(database.foodItems).get()).single.name, 'Oats');
    expect(
      (await database.select(database.mealEntries).get()).single.foodItemId,
      1,
    );
    expect(
      (await database.select(database.workoutSets).get()).single.exerciseId,
      1,
    );
  });

  test('rejects an unknown schema version before changing data', () async {
    await _insertSample(database);
    final before = await _readAll(database);
    final document = jsonDecode(await service.exportJson())
        as Map<String, dynamic>
      ..['schema_version'] = 999;

    expect(
      () => service.importJson(jsonEncode(document)),
      throwsA(isA<FormatException>()),
    );
    expect(await _readAll(database), equals(before));
  });

  test('rejects a malformed row', () async {
    final document =
        jsonDecode(await service.exportJson()) as Map<String, dynamic>;
    document['food_items'] = [
      {'id': 'not an integer', 'name': 'Oats', 'caloriesPer100g': 380.0},
    ];

    expect(
      () => service.importJson(jsonEncode(document)),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('food_items row 1'),
        ),
      ),
    );
  });

  test('failed import leaves existing data unchanged', () async {
    await _insertSample(database);
    final before = await _readAll(database);
    final document =
        jsonDecode(await service.exportJson()) as Map<String, dynamic>;
    final entries = document['meal_entries'] as List<dynamic>;
    entries[0] = Map<String, dynamic>.from(entries.single as Map)
      ..['mealId'] = 999;

    expect(
      () => service.importJson(jsonEncode(document)),
      throwsA(isA<FormatException>()),
    );
    expect(await _readAll(database), equals(before));
  });
}

Future<void> _insertSample(AppDatabase database) async {
  await database.into(database.foodItems).insert(
        FoodItemsCompanion.insert(
          id: const Value(1),
          name: 'Oats',
          caloriesPer100g: 380,
        ),
      );
  await database.into(database.meals).insert(
        MealsCompanion.insert(
          id: const Value(1),
          loggedAt: DateTime.utc(2026, 11, 12, 8),
          mealType: const Value('breakfast'),
        ),
      );
  await database.into(database.mealEntries).insert(
        MealEntriesCompanion.insert(
          id: const Value(1),
          mealId: 1,
          foodItemId: const Value(1),
          grams: const Value(50),
          calories: 190,
        ),
      );
  await database.into(database.exercises).insert(
        ExercisesCompanion.insert(id: const Value(1), name: 'Squat'),
      );
  await database.into(database.workouts).insert(
        WorkoutsCompanion.insert(
          id: const Value(1),
          startedAt: DateTime.utc(2026, 11, 12, 17),
          notes: const Value('Leg day'),
        ),
      );
  await database.into(database.workoutSets).insert(
        WorkoutSetsCompanion.insert(
          id: const Value(1),
          workoutId: 1,
          exerciseId: 1,
          setNumber: 1,
          reps: 5,
          weightKg: 80,
        ),
      );
}

Future<Map<String, dynamic>> _readAll(AppDatabase database) async {
  return {
    'foodItems': await database.select(database.foodItems).get(),
    'meals': await database.select(database.meals).get(),
    'mealEntries': await database.select(database.mealEntries).get(),
    'exercises': await database.select(database.exercises).get(),
    'workouts': await database.select(database.workouts).get(),
    'workoutSets': await database.select(database.workoutSets).get(),
  };
}

String _emptyBackup() => jsonEncode({
      'schema_version': AppDatabase.currentSchemaVersion,
      'food_items': <dynamic>[],
      'meals': <dynamic>[],
      'meal_entries': <dynamic>[],
      'exercises': <dynamic>[],
      'workouts': <dynamic>[],
      'workout_sets': <dynamic>[],
    });
