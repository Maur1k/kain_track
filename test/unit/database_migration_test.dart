import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kain_track/data/db/database.dart';

void main() {
  test('new database creates foods, meal entries, and workout sessions',
      () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final foods = await database.select(database.foods).get();
    expect(foods, hasLength(26));
    expect(foods.map((food) => food.name).toSet(), hasLength(26));
    expect(
      foods.every(
        (food) =>
            {'Protein', 'Carbs', 'Filipino', 'Snacks'}.contains(food.category),
      ),
      isTrue,
    );
    expect(await database.select(database.mealEntries).get(), isEmpty);
    expect(await database.select(database.workoutSessions).get(), isEmpty);
  });

  test('seeding is only applied on creation and keeps a custom food', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database.into(database.foods).insert(
          FoodsCompanion.insert(
            name: 'My food',
            caloriesPer100g: 100,
            proteinPer100g: 10,
            carbsPer100g: 10,
            fatPer100g: 10,
            isCustom: const Value(true),
          ),
        );
    expect(await database.select(database.foods).get(), hasLength(27));
    expect(
      (await database.select(database.foods).get())
          .where((food) => food.name == 'My food'),
      hasLength(1),
    );
  });

  test('upgrading the legacy schema creates the new tables and seed data',
      () async {
    final database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (db) {
          db.execute(
              'CREATE TABLE meals (id INTEGER PRIMARY KEY, logged_at INTEGER NOT NULL)');
          db.execute(
              'CREATE TABLE food_items (id INTEGER PRIMARY KEY, name TEXT NOT NULL, calories_per100g REAL NOT NULL)');
          db.execute(
              'CREATE TABLE meal_entries (id INTEGER PRIMARY KEY, meal_id INTEGER NOT NULL, food_item_id INTEGER NOT NULL, grams REAL NOT NULL, calories REAL NOT NULL)');
          db.execute(
              'CREATE TABLE exercises (id INTEGER PRIMARY KEY, name TEXT NOT NULL)');
          db.execute(
              'CREATE TABLE workouts (id INTEGER PRIMARY KEY, started_at INTEGER NOT NULL, notes TEXT)');
          db.execute(
              'CREATE TABLE workout_sets (id INTEGER PRIMARY KEY, workout_id INTEGER NOT NULL, exercise_id INTEGER NOT NULL, set_number INTEGER NOT NULL, reps INTEGER NOT NULL, weight_kg REAL NOT NULL)');
          db.execute('PRAGMA user_version = 3');
        },
      ),
    );
    addTearDown(database.close);
    expect(await database.select(database.foods).get(), hasLength(26));
    expect(await database.select(database.mealEntries).get(), isEmpty);
    expect(await database.select(database.workoutSessions).get(), isEmpty);
  });

  test('upgrading schema v4 backfills the complete prototype food library',
      () async {
    final database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (db) {
          db.execute('''
            CREATE TABLE foods (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL UNIQUE,
              calories_per100g REAL NOT NULL,
              protein_per100g REAL NOT NULL,
              carbs_per100g REAL NOT NULL,
              fat_per100g REAL NOT NULL,
              is_custom INTEGER NOT NULL DEFAULT 0
            )
          ''');
          db.execute('''
            CREATE TABLE meal_entries (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              food_id INTEGER NOT NULL,
              grams REAL NOT NULL,
              meal_slot TEXT NOT NULL,
              logged_at INTEGER NOT NULL
            )
          ''');
          db.execute('''
            CREATE TABLE workout_sessions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              duration_minutes INTEGER,
              notes TEXT,
              performed_at INTEGER NOT NULL
            )
          ''');
          db.execute(
            "INSERT INTO foods (name, calories_per100g, protein_per100g, "
            "carbs_per100g, fat_per100g) VALUES "
            "('Cooked white rice', 999, 99, 88, 77), "
            "('My custom food', 100, 10, 20, 30)",
          );
          db.execute('PRAGMA user_version = 4');
        },
      ),
    );
    addTearDown(database.close);

    final foods = await database.select(database.foods).get();
    expect(foods, hasLength(27));
    expect(foods.map((food) => food.name).toSet(), hasLength(27));
    expect(
      foods.where((food) => food.name != 'My custom food'),
      hasLength(26),
    );
    expect(
      foods.where((food) => food.name == 'Cooked white rice'),
      hasLength(1),
    );
    expect(
      foods.where((food) => food.name == 'My custom food'),
      hasLength(1),
    );

    final rice = foods.singleWhere((food) => food.name == 'Cooked white rice');
    expect(rice.category, 'Carbs');
    expect(rice.caloriesPer100g, 999);
    expect(rice.proteinPer100g, 99);
    expect(rice.carbsPer100g, 88);
    expect(rice.fatPer100g, 77);

    expect(
      foods.every(
        (food) =>
            {'Protein', 'Carbs', 'Filipino', 'Snacks'}.contains(food.category),
      ),
      isTrue,
    );
  });
}
