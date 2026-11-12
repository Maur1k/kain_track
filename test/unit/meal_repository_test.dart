import 'package:drift/drift.dart';
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

  test('no entries gives zero calories', () async {
    expect(await repository.getTodayTotalCalories(), 0);
  });

  test('sums today entries and excludes yesterday', () async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 9);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayMeal = await database.into(database.meals).insert(
          MealsCompanion.insert(loggedAt: today.toUtc()),
        );
    final secondTodayMeal = await database.into(database.meals).insert(
          MealsCompanion.insert(
            loggedAt: today.add(const Duration(hours: 2)).toUtc(),
          ),
        );
    final yesterdayMeal = await database.into(database.meals).insert(
          MealsCompanion.insert(loggedAt: yesterday.toUtc()),
        );

    await database.batch((batch) {
      batch.insertAll(database.mealEntries, [
        MealEntriesCompanion.insert(
          mealId: todayMeal,
          foodItemId: const Value(1),
          grams: const Value(100),
          calories: 400.0,
        ),
        MealEntriesCompanion.insert(
          mealId: secondTodayMeal,
          foodItemId: const Value(1),
          grams: const Value(100),
          calories: 650.0,
        ),
        MealEntriesCompanion.insert(
          mealId: yesterdayMeal,
          foodItemId: const Value(1),
          grams: const Value(100),
          calories: 999.0,
        ),
      ]);
    });

    expect(await repository.getTodayTotalCalories(now), 1050);
  });

  test('saves calories using grams and calories per 100g', () async {
    await repository.logMeal(
      foodName: 'Oats',
      caloriesPer100g: 380,
      grams: 50,
      mealType: 'breakfast',
    );

    final entry = await database.select(database.mealEntries).getSingle();
    expect(entry.calories, 190);
    expect(entry.grams, 50);
  });

  test('rejects empty names and non-positive numbers', () async {
    expect(
      () => repository.logMeal(
        foodName: '',
        caloriesPer100g: 100,
        grams: 50,
        mealType: 'snack',
      ),
      throwsArgumentError,
    );
    expect(
      () => repository.logMeal(
        foodName: 'Apple',
        caloriesPer100g: 0,
        grams: 50,
        mealType: 'snack',
      ),
      throwsArgumentError,
    );
    expect(
      () => repository.logMeal(
        foodName: 'Apple',
        caloriesPer100g: 100,
        grams: -1,
        mealType: 'snack',
      ),
      throwsArgumentError,
    );
  });

  test('reuses an existing food item by name', () async {
    await repository.logMeal(
      foodName: 'Apple',
      caloriesPer100g: 52,
      grams: 100,
      mealType: 'snack',
    );
    await repository.logMeal(
      foodName: 'Apple',
      caloriesPer100g: 52,
      grams: 150,
      mealType: 'snack',
    );

    expect(await database.select(database.foodItems).get(), hasLength(1));
    expect(await database.select(database.mealEntries).get(), hasLength(2));
  });
}
