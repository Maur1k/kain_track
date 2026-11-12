import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get loggedAt => dateTime()();

  TextColumn get mealType => text().withDefault(const Constant('snack'))();
}

class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  RealColumn get caloriesPer100g => real()();
}

class MealEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get mealId => integer().references(Meals, #id)();

  IntColumn get foodItemId =>
      integer().references(FoodItems, #id).withDefault(const Constant(1))();

  RealColumn get grams => real().withDefault(const Constant(0.0))();

  RealColumn get calories => real()();
}

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get startedAt => dateTime()();

  TextColumn get notes => text().nullable()();
}

class WorkoutSets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutId => integer().references(Workouts, #id)();

  IntColumn get exerciseId => integer().references(Exercises, #id)();

  IntColumn get setNumber => integer()();

  IntColumn get reps => integer()();

  RealColumn get weightKg => real()();
}

@DriftDatabase(
  tables: [Meals, FoodItems, MealEntries, Exercises, Workouts, WorkoutSets],
)
class AppDatabase extends _$AppDatabase {
  static const currentSchemaVersion = 3;

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
        onCreate: (Migrator m) => m.createAll(),
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(foodItems);
            await into(foodItems).insert(
              FoodItemsCompanion.insert(
                name: 'Unknown',
                caloriesPer100g: 0,
              ),
            );
            await m.addColumn(meals, meals.mealType);
            await m.addColumn(mealEntries, mealEntries.foodItemId);
            await m.addColumn(mealEntries, mealEntries.grams);
          }
          if (from < 3) {
            await m.createTable(exercises);
            await m.createTable(workouts);
            await m.createTable(workoutSets);
          }
        },
      );
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
