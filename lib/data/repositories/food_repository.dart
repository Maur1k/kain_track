import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';

class FoodRepository {
  FoodRepository(this._database);

  final AppDatabase _database;

  Future<List<Food>> listFoods({String query = ''}) async {
    final normalized = query.trim();
    final statement = _database.select(_database.foods)
      ..orderBy([(food) => OrderingTerm.asc(food.name)]);
    if (normalized.isNotEmpty) {
      statement.where((food) => food.name.like('%$normalized%'));
    }
    return statement.get();
  }

  Future<Food> addCustomFood({
    required String name,
    required double caloriesPer100g,
    required double proteinPer100g,
    required double carbsPer100g,
    required double fatPer100g,
  }) async {
    _validate(name, caloriesPer100g, proteinPer100g, carbsPer100g, fatPer100g);
    final id = await _database.into(_database.foods).insert(
          FoodsCompanion.insert(
            name: name.trim(),
            caloriesPer100g: caloriesPer100g,
            proteinPer100g: proteinPer100g,
            carbsPer100g: carbsPer100g,
            fatPer100g: fatPer100g,
            isCustom: const Value(true),
          ),
        );
    return (_database.select(_database.foods)
          ..where((food) => food.id.equals(id)))
        .getSingle();
  }

  Future<void> editCustomFood({
    required int id,
    required String name,
    required double caloriesPer100g,
    required double proteinPer100g,
    required double carbsPer100g,
    required double fatPer100g,
  }) async {
    _validate(name, caloriesPer100g, proteinPer100g, carbsPer100g, fatPer100g);
    final updated = await (_database.update(_database.foods)
          ..where((food) => food.id.equals(id) & food.isCustom.equals(true)))
        .write(
      FoodsCompanion(
        name: Value(name.trim()),
        caloriesPer100g: Value(caloriesPer100g),
        proteinPer100g: Value(proteinPer100g),
        carbsPer100g: Value(carbsPer100g),
        fatPer100g: Value(fatPer100g),
      ),
    );
    if (updated == 0) {
      throw StateError('Only custom foods can be edited.');
    }
  }

  Future<void> deleteCustomFood(int id) async {
    final references = await (_database.select(_database.mealEntries)
          ..where((entry) => entry.foodId.equals(id)))
        .get();
    if (references.isNotEmpty) {
      throw StateError(
          'This food cannot be deleted because it has meal entries.');
    }
    final deleted = await (_database.delete(_database.foods)
          ..where((food) => food.id.equals(id) & food.isCustom.equals(true)))
        .go();
    if (deleted == 0) {
      throw StateError('Only custom foods can be deleted.');
    }
  }

  static void _validate(
    String name,
    double calories,
    double protein,
    double carbs,
    double fat,
  ) {
    if (name.trim().isEmpty) throw ArgumentError('Food name is required.');
    for (final value in [calories, protein, carbs, fat]) {
      if (!value.isFinite || value < 0) {
        throw ArgumentError('Nutrition values must be zero or more.');
      }
    }
  }
}

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepository(ref.watch(databaseProvider));
});

final foodsProvider = FutureProvider<List<Food>>((ref) {
  return ref.watch(foodRepositoryProvider).listFoods();
});
