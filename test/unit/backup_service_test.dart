import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kain_track/data/db/database.dart';
import 'package:kain_track/data/io/backup_service.dart';

void main() {
  test('round trips the current tables', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final service = BackupService(database);
    final food = (await database.select(database.foods).get()).first;
    await database.into(database.mealEntries).insert(
          MealEntriesCompanion.insert(
            foodId: food.id,
            grams: 150,
            mealSlot: 'breakfast',
            loggedAt: DateTime.utc(2026, 11, 12),
          ),
        );
    await database.into(database.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            name: 'Run',
            performedAt: DateTime.utc(2026, 11, 12),
          ),
        );
    final foodsBefore = await database.select(database.foods).get();
    final mealsBefore = await database.select(database.mealEntries).get();
    final workoutsBefore =
        await database.select(database.workoutSessions).get();
    final exported = await service.exportJson();
    await service.importJson(exported);
    expect(await database.select(database.foods).get(), foodsBefore);
    expect(await database.select(database.mealEntries).get(), mealsBefore);
    expect(
      await database.select(database.workoutSessions).get(),
      workoutsBefore,
    );
    expect(jsonDecode(exported)['foods'].first['category'], 'Protein');
  });

  test('imports older food rows without category as Protein', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final service = BackupService(database);
    final document =
        jsonDecode(await service.exportJson()) as Map<String, dynamic>;
    for (final food in document['foods'] as List<dynamic>) {
      (food as Map<String, dynamic>).remove('category');
    }

    await service.importJson(jsonEncode(document));

    final foods = await database.select(database.foods).get();
    expect(foods, isNotEmpty);
    expect(foods.every((food) => food.category == 'Protein'), isTrue);
  });

  test('rejects an old or malformed backup clearly', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final service = BackupService(database);
    expect(
      () => service.importJson(jsonEncode({'schema_version': 3})),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => service.importJson('not json'),
      throwsA(isA<FormatException>()),
    );
  });
}
