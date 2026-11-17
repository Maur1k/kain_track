import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';

class Nutrition {
  const Nutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  const Nutrition.zero()
      : calories = 0,
        protein = 0,
        carbs = 0,
        fat = 0;

  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  Nutrition operator +(Nutrition other) => Nutrition(
        calories: calories + other.calories,
        protein: protein + other.protein,
        carbs: carbs + other.carbs,
        fat: fat + other.fat,
      );
}

Nutrition nutritionFor(Food food, double grams) {
  final factor = grams / 100;
  return Nutrition(
    calories: factor * food.caloriesPer100g,
    protein: factor * food.proteinPer100g,
    carbs: factor * food.carbsPer100g,
    fat: factor * food.fatPer100g,
  );
}

class MealEntryWithFood {
  const MealEntryWithFood({required this.entry, required this.food});

  final MealEntry entry;
  final Food food;

  Nutrition get nutrition => nutritionFor(food, entry.grams);
}

class MealRepository {
  MealRepository(this._database);

  final AppDatabase _database;

  Future<void> addEntry({
    required int foodId,
    required double grams,
    required String mealSlot,
    required DateTime loggedAt,
  }) async {
    _validateGrams(grams);
    _validateMealSlot(mealSlot);
    await _database.into(_database.mealEntries).insert(
          MealEntriesCompanion.insert(
            foodId: foodId,
            grams: grams,
            mealSlot: mealSlot,
            loggedAt: loggedAt.toUtc(),
          ),
        );
  }

  Future<void> updateGrams(int entryId, double grams) async {
    _validateGrams(grams);
    await (_database.update(_database.mealEntries)
          ..where((entry) => entry.id.equals(entryId)))
        .write(MealEntriesCompanion(grams: Value(grams)));
  }

  Future<void> deleteEntry(int entryId) async {
    await (_database.delete(_database.mealEntries)
          ..where((entry) => entry.id.equals(entryId)))
        .go();
  }

  Future<Map<String, List<MealEntryWithFood>>> getEntriesForDate(
    DateTime date,
  ) async {
    final rows = await _entriesForDate(date);
    return _groupEntries(rows);
  }

  Stream<Map<String, List<MealEntryWithFood>>> watchEntriesForDate(
    DateTime date,
  ) {
    return _entriesQuery(date).watch().map(_mapRows).map(_groupEntries);
  }

  Future<Nutrition> getDailyTotals(DateTime date) async {
    final rows = await _entriesForDate(date);
    return rows.fold<Nutrition>(
      const Nutrition.zero(),
      (total, row) => total + row.nutrition,
    );
  }

  Stream<Nutrition> watchDailyTotals(DateTime date) {
    return _entriesQuery(date).watch().map(_mapRows).map(
          (rows) => rows.fold<Nutrition>(
            const Nutrition.zero(),
            (total, row) => total + row.nutrition,
          ),
        );
  }

  Future<void> deleteEntriesForDate(DateTime date) async {
    final start = _startOfDateUtc(date);
    final end = start.add(const Duration(days: 1));
    await (_database.delete(_database.mealEntries)
          ..where(
            (entry) =>
                entry.loggedAt.isBiggerOrEqualValue(start) &
                entry.loggedAt.isSmallerThanValue(end),
          ))
        .go();
  }

  Future<List<MealEntryWithFood>> _entriesForDate(DateTime date) {
    return _entriesQuery(date).get().then(_mapRows);
  }

  JoinedSelectStatement _entriesQuery(DateTime date) {
    final start = _startOfDateUtc(date);
    final end = start.add(const Duration(days: 1));
    return (_database.select(_database.mealEntries).join([
      innerJoin(
        _database.foods,
        _database.foods.id.equalsExp(_database.mealEntries.foodId),
      ),
    ])
      ..where(
        _database.mealEntries.loggedAt.isBiggerOrEqualValue(start) &
            _database.mealEntries.loggedAt.isSmallerThanValue(end),
      )
      ..orderBy([
        OrderingTerm.asc(_database.mealEntries.loggedAt),
        OrderingTerm.asc(_database.mealEntries.id),
      ]));
  }

  static Map<String, List<MealEntryWithFood>> _groupEntries(
    List<MealEntryWithFood> rows,
  ) {
    final grouped = <String, List<MealEntryWithFood>>{};
    for (final row in rows) {
      grouped.putIfAbsent(row.entry.mealSlot, () => []).add(row);
    }
    return grouped;
  }

  List<MealEntryWithFood> _mapRows(
    List<TypedResult> rows,
  ) =>
      rows
          .map(
            (row) => MealEntryWithFood(
              entry: row.readTable(_database.mealEntries),
              food: row.readTable(_database.foods),
            ),
          )
          .toList();

  static DateTime _startOfDateUtc(DateTime date) =>
      DateTime(date.year, date.month, date.day).toUtc();

  static void _validateGrams(double grams) {
    if (!grams.isFinite || grams <= 0) {
      throw ArgumentError.value(grams, 'grams', 'Grams must be positive.');
    }
  }

  static void _validateMealSlot(String mealSlot) {
    if (!{'breakfast', 'lunch', 'dinner', 'snack'}.contains(mealSlot)) {
      throw ArgumentError.value(mealSlot, 'mealSlot', 'Invalid meal slot.');
    }
  }
}

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(ref.watch(databaseProvider));
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final selectedDateNutritionProvider = StreamProvider<Nutrition>((ref) {
  final date = ref.watch(selectedDateProvider);
  return ref.watch(mealRepositoryProvider).watchDailyTotals(date);
});

final selectedDateEntriesProvider =
    StreamProvider<Map<String, List<MealEntryWithFood>>>((ref) {
  final date = ref.watch(selectedDateProvider);
  return ref.watch(mealRepositoryProvider).watchEntriesForDate(date);
});

final todayNutritionProvider = selectedDateNutritionProvider;
final todayEntriesProvider = selectedDateEntriesProvider;
