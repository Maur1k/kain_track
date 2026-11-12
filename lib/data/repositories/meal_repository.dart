import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';

class MealRepository {
  MealRepository(this._database);

  final AppDatabase _database;

  Future<void> logMeal({
    required String foodName,
    required double caloriesPer100g,
    required double grams,
    required String mealType,
  }) async {
    final name = foodName.trim();
    if (name.isEmpty) {
      throw ArgumentError.value(foodName, 'foodName', 'Name is required.');
    }
    if (!caloriesPer100g.isFinite || caloriesPer100g <= 0) {
      throw ArgumentError.value(
        caloriesPer100g,
        'caloriesPer100g',
        'Calories must be a positive number.',
      );
    }
    if (!grams.isFinite || grams <= 0) {
      throw ArgumentError.value(
        grams,
        'grams',
        'Grams must be a positive number.',
      );
    }

    await _database.transaction(() async {
      final existingFood = await (_database.select(_database.foodItems)
            ..where((food) => food.name.equals(name)))
          .getSingleOrNull();
      final foodItemId = existingFood?.id ??
          await _database.into(_database.foodItems).insert(
                FoodItemsCompanion.insert(
                  name: name,
                  caloriesPer100g: caloriesPer100g,
                ),
              );
      final mealId = await _database.into(_database.meals).insert(
            MealsCompanion.insert(
              loggedAt: DateTime.now().toUtc(),
              mealType: Value(mealType),
            ),
          );
      await _database.into(_database.mealEntries).insert(
            MealEntriesCompanion.insert(
              mealId: mealId,
              foodItemId: Value(foodItemId),
              grams: Value(grams),
              calories: grams * caloriesPer100g / 100,
            ),
          );
    });
  }

  Future<double> getTodayTotalCalories([DateTime? now]) async {
    final localNow = now ?? DateTime.now();
    final startOfDay = DateTime(localNow.year, localNow.month, localNow.day);
    final startOfTomorrow = startOfDay.add(const Duration(days: 1));

    final caloriesSum = _database.mealEntries.calories.sum();
    final total = await (_database.selectOnly(_database.mealEntries)
          ..addColumns([caloriesSum])
          ..join([
            innerJoin(
              _database.meals,
              _database.meals.id.equalsExp(_database.mealEntries.mealId),
            ),
          ])
          ..where(
            _database.meals.loggedAt.isBiggerOrEqualValue(startOfDay.toUtc()) &
                _database.meals.loggedAt.isSmallerThanValue(
                  startOfTomorrow.toUtc(),
                ),
          ))
        .getSingle();

    return total.read(caloriesSum) ?? 0;
  }
}

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(ref.watch(databaseProvider));
});

final todayCaloriesProvider = FutureProvider<double>((ref) {
  return ref.watch(mealRepositoryProvider).getTodayTotalCalories();
});
