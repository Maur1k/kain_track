import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kain_track/data/db/database.dart';
import 'package:kain_track/data/repositories/meal_repository.dart';

void main() {
  late AppDatabase database;
  late MealRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = MealRepository(database);
  });

  tearDown(() => database.close());

  test('calculates nutrition from grams', () async {
    final egg = (await database.select(database.foods).get()).firstWhere(
      (food) => food.name == 'Boiled egg (whole)',
    );
    final result = nutritionFor(egg, 150);
    expect(result.calories, 232.5);
    expect(result.protein, closeTo(18.9, 0.0001));
    expect(result.carbs, closeTo(1.65, 0.0001));
    expect(result.fat, closeTo(15.9, 0.0001));
  });

  test('daily totals are derived from entries and exclude other dates',
      () async {
    final egg = (await database.select(database.foods).get()).first;
    await repository.addEntry(
      foodId: egg.id,
      grams: 150,
      mealSlot: 'breakfast',
      loggedAt: DateTime(2026, 11, 12, 8),
    );
    await repository.addEntry(
      foodId: egg.id,
      grams: 100,
      mealSlot: 'snack',
      loggedAt: DateTime(2026, 11, 11, 8),
    );
    final totals = await repository.getDailyTotals(DateTime(2026, 11, 12));
    expect(totals.calories, 232.5);
    expect(totals.protein, closeTo(18.9, 0.0001));
  });

  test('editing grams updates totals', () async {
    final egg = (await database.select(database.foods).get()).first;
    await repository.addEntry(
      foodId: egg.id,
      grams: 100,
      mealSlot: 'breakfast',
      loggedAt: DateTime(2026, 11, 12),
    );
    final entry = await database.select(database.mealEntries).getSingle();
    await repository.updateGrams(entry.id, 150);
    expect(
      (await repository.getDailyTotals(DateTime(2026, 11, 12))).calories,
      232.5,
    );
  });
}
