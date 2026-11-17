import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Foods extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().unique()();

  RealColumn get caloriesPer100g => real()();

  RealColumn get proteinPer100g => real()();

  RealColumn get carbsPer100g => real()();

  RealColumn get fatPer100g => real()();

  TextColumn get category => text().withDefault(const Constant('Protein'))();

  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

class MealEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get foodId => integer().references(Foods, #id)();

  RealColumn get grams => real()();

  TextColumn get mealSlot => text()();

  DateTimeColumn get loggedAt => dateTime()();
}

class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get durationMinutes => integer().nullable()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get performedAt => dateTime()();
}

@DriftDatabase(tables: [Foods, MealEntries, WorkoutSessions])
class AppDatabase extends _$AppDatabase {
  static const currentSchemaVersion = 5;

  AppDatabase()
      : this._(
          LazyDatabase(() async {
            final directory = await getApplicationDocumentsDirectory();
            return NativeDatabase(
              File(p.join(directory.path, 'kain_track.sqlite')),
            );
          }),
        );

  AppDatabase.forTesting(QueryExecutor executor) : this._(executor);

  AppDatabase._(super.executor);

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await batch((batch) {
            batch.insertAll(
              foods,
              _seedFoods,
            );
          });
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 4) {
            await m.deleteTable('meal_entries');
            await m.deleteTable('meals');
            await m.deleteTable('food_items');
            await m.deleteTable('workout_sets');
            await m.deleteTable('exercises');
            await m.deleteTable('workouts');
            await m.createTable(foods);
            await m.createTable(mealEntries);
            await m.createTable(workoutSessions);
            await batch((batch) {
              batch.insertAll(
                foods,
                _seedFoods,
              );
            });
          }
          if (from >= 4 && from < 5) {
            await m.addColumn(foods, foods.category);
            for (final seed in _seedFoods) {
              final name = seed.name.value;
              final existing = await (select(foods)
                    ..where((food) => food.name.equals(name)))
                  .getSingleOrNull();
              if (existing == null) {
                await into(foods).insert(seed);
              } else {
                await (update(foods)
                      ..where((food) => food.id.equals(existing.id)))
                    .write(FoodsCompanion(category: seed.category));
              }
            }
          }
        },
      );
}

const _seedFoods = [
  FoodsCompanion(
    name: Value('Boiled egg (whole)'),
    caloriesPer100g: Value(155),
    proteinPer100g: Value(12.6),
    carbsPer100g: Value(1.1),
    fatPer100g: Value(10.6),
    category: Value('Protein'),
  ),
  FoodsCompanion(
    name: Value('Cooked white rice'),
    caloriesPer100g: Value(130),
    proteinPer100g: Value(2.7),
    carbsPer100g: Value(28.2),
    fatPer100g: Value(0.3),
    category: Value('Carbs'),
  ),
  FoodsCompanion(
    name: Value('Cooked chicken breast'),
    caloriesPer100g: Value(165),
    proteinPer100g: Value(31.0),
    carbsPer100g: Value(0),
    fatPer100g: Value(3.6),
    category: Value('Protein'),
  ),
  FoodsCompanion(
    name: Value('Dry oats'),
    caloriesPer100g: Value(389),
    proteinPer100g: Value(16.9),
    carbsPer100g: Value(66.3),
    fatPer100g: Value(6.9),
    category: Value('Carbs'),
  ),
  FoodsCompanion(
    name: Value('Banana'),
    caloriesPer100g: Value(89),
    proteinPer100g: Value(1.1),
    carbsPer100g: Value(22.8),
    fatPer100g: Value(0.3),
    category: Value('Snacks'),
  ),
  FoodsCompanion(
    name: Value('Boiled potato'),
    caloriesPer100g: Value(87),
    proteinPer100g: Value(1.9),
    carbsPer100g: Value(20.1),
    fatPer100g: Value(0.1),
    category: Value('Carbs'),
  ),
  FoodsCompanion(
    name: Value('Whole milk'),
    caloriesPer100g: Value(61),
    proteinPer100g: Value(3.2),
    carbsPer100g: Value(4.8),
    fatPer100g: Value(3.3),
    category: Value('Protein'),
  ),
  FoodsCompanion(
    name: Value('Canned tuna in water'),
    caloriesPer100g: Value(116),
    proteinPer100g: Value(25.5),
    carbsPer100g: Value(0),
    fatPer100g: Value(0.8),
    category: Value('Protein'),
  ),
  FoodsCompanion(
    name: Value('Grilled Chicken Breast'),
    caloriesPer100g: Value(165),
    proteinPer100g: Value(31),
    carbsPer100g: Value(0),
    fatPer100g: Value(3.6),
    category: Value('Protein'),
  ),
  FoodsCompanion(
    name: Value('Steamed White Rice'),
    caloriesPer100g: Value(129.75),
    proteinPer100g: Value(2.72),
    carbsPer100g: Value(28.16),
    fatPer100g: Value(0.25),
    category: Value('Carbs'),
  ),
  FoodsCompanion(
    name: Value('Boiled Large Egg'),
    caloriesPer100g: Value(156),
    proteinPer100g: Value(12.6),
    carbsPer100g: Value(1.2),
    fatPer100g: Value(10.6),
    category: Value('Protein'),
  ),
  FoodsCompanion(
    name: Value('Chicken Adobo'),
    caloriesPer100g: Value(172.22),
    proteinPer100g: Value(15),
    carbsPer100g: Value(3.33),
    fatPer100g: Value(10.56),
    category: Value('Filipino'),
  ),
  FoodsCompanion(
    name: Value('Sinigang na Baboy'),
    caloriesPer100g: Value(98),
    proteinPer100g: Value(7.2),
    carbsPer100g: Value(4.4),
    fatPer100g: Value(5.6),
    category: Value('Filipino'),
  ),
  FoodsCompanion(
    name: Value('Grilled Bangus'),
    caloriesPer100g: Value(176.67),
    proteinPer100g: Value(20),
    carbsPer100g: Value(0),
    fatPer100g: Value(10),
    category: Value('Filipino'),
  ),
  FoodsCompanion(
    name: Value('Tuna Chunks in Water'),
    caloriesPer100g: Value(108.33),
    proteinPer100g: Value(23.33),
    carbsPer100g: Value(0),
    fatPer100g: Value(1),
    category: Value('Protein'),
  ),
  FoodsCompanion(
    name: Value('Rolled Oats, dry'),
    caloriesPer100g: Value(375),
    proteinPer100g: Value(12.5),
    carbsPer100g: Value(67.5),
    fatPer100g: Value(6.25),
    category: Value('Carbs'),
  ),
  FoodsCompanion(
    name: Value('Lakatan Banana'),
    caloriesPer100g: Value(95),
    proteinPer100g: Value(1.1),
    carbsPer100g: Value(24),
    fatPer100g: Value(0.3),
    category: Value('Snacks'),
  ),
  FoodsCompanion(
    name: Value('Whey Protein Shake'),
    caloriesPer100g: Value(375),
    proteinPer100g: Value(75),
    carbsPer100g: Value(9.38),
    fatPer100g: Value(4.69),
    category: Value('Protein'),
  ),
  FoodsCompanion(
    name: Value('Tortang Talong'),
    caloriesPer100g: Value(125),
    proteinPer100g: Value(6.79),
    carbsPer100g: Value(8.57),
    fatPer100g: Value(7.14),
    category: Value('Filipino'),
  ),
  FoodsCompanion(
    name: Value('Brown Rice cooked'),
    caloriesPer100g: Value(110.77),
    proteinPer100g: Value(2.56),
    carbsPer100g: Value(23.08),
    fatPer100g: Value(0.92),
    category: Value('Carbs'),
  ),
  FoodsCompanion(
    name: Value('Greek Yogurt plain non-fat'),
    caloriesPer100g: Value(58.82),
    proteinPer100g: Value(10),
    carbsPer100g: Value(3.53),
    fatPer100g: Value(0.24),
    category: Value('Protein'),
  ),
  FoodsCompanion(
    name: Value('Peanut Butter'),
    caloriesPer100g: Value(593.75),
    proteinPer100g: Value(25),
    carbsPer100g: Value(20),
    fatPer100g: Value(50),
    category: Value('Snacks'),
  ),
  FoodsCompanion(
    name: Value('Chicken Tinola'),
    caloriesPer100g: Value(80.77),
    proteinPer100g: Value(9.23),
    carbsPer100g: Value(3.46),
    fatPer100g: Value(3.27),
    category: Value('Filipino'),
  ),
  FoodsCompanion(
    name: Value('Sweet Potato boiled'),
    caloriesPer100g: Value(86.15),
    proteinPer100g: Value(1.54),
    carbsPer100g: Value(20),
    fatPer100g: Value(0.08),
    category: Value('Carbs'),
  ),
  FoodsCompanion(
    name: Value('Almonds raw'),
    caloriesPer100g: Value(577.78),
    proteinPer100g: Value(21.11),
    carbsPer100g: Value(21.11),
    fatPer100g: Value(50),
    category: Value('Snacks'),
  ),
  FoodsCompanion(
    name: Value('Beef Tapa'),
    caloriesPer100g: Value(235),
    proteinPer100g: Value(26),
    carbsPer100g: Value(4),
    fatPer100g: Value(12.5),
    category: Value('Filipino'),
  ),
];

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
