import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';

class BackupService {
  BackupService(this._database);

  final AppDatabase _database;

  Future<String> exportJson() async {
    final foodItems = await (_database.select(_database.foodItems)
          ..orderBy([(item) => OrderingTerm.asc(item.id)]))
        .get();
    final meals = await (_database.select(_database.meals)
          ..orderBy([(meal) => OrderingTerm.asc(meal.id)]))
        .get();
    final mealEntries = await (_database.select(_database.mealEntries)
          ..orderBy([(entry) => OrderingTerm.asc(entry.id)]))
        .get();
    final exercises = await (_database.select(_database.exercises)
          ..orderBy([(exercise) => OrderingTerm.asc(exercise.id)]))
        .get();
    final workouts = await (_database.select(_database.workouts)
          ..orderBy([(workout) => OrderingTerm.asc(workout.id)]))
        .get();
    final workoutSets = await (_database.select(_database.workoutSets)
          ..orderBy([(set) => OrderingTerm.asc(set.id)]))
        .get();

    return const JsonEncoder.withIndent('  ').convert({
      'schema_version': _database.schemaVersion,
      'food_items': foodItems.map(_foodItemToJson).toList(),
      'meals': meals.map(_mealToJson).toList(),
      'meal_entries': mealEntries.map(_mealEntryToJson).toList(),
      'exercises': exercises.map(_exerciseToJson).toList(),
      'workouts': workouts.map(_workoutToJson).toList(),
      'workout_sets': workoutSets.map(_workoutSetToJson).toList(),
    });
  }

  Future<void> importJson(String contents) async {
    final document = _parseDocument(contents);
    final tables = _validateDocument(document, _database.schemaVersion);

    await _database.transaction(() async {
      await _database.delete(_database.workoutSets).go();
      await _database.delete(_database.mealEntries).go();
      await _database.delete(_database.workouts).go();
      await _database.delete(_database.exercises).go();
      await _database.delete(_database.meals).go();
      await _database.delete(_database.foodItems).go();

      await _database.batch((batch) {
        batch.insertAll(
          _database.foodItems,
          tables.foodItems
              .map((row) => FoodItemsCompanion.insert(
                    id: Value(row['id'] as int),
                    name: row['name'] as String,
                    caloriesPer100g: row['caloriesPer100g'] as double,
                  ))
              .toList(),
        );
        batch.insertAll(
          _database.meals,
          tables.meals
              .map((row) => MealsCompanion.insert(
                    id: Value(row['id'] as int),
                    loggedAt: row['loggedAt'] as DateTime,
                    mealType: Value(row['mealType'] as String),
                  ))
              .toList(),
        );
        batch.insertAll(
          _database.mealEntries,
          tables.mealEntries
              .map((row) => MealEntriesCompanion.insert(
                    id: Value(row['id'] as int),
                    mealId: row['mealId'] as int,
                    foodItemId: Value(row['foodItemId'] as int),
                    grams: Value(row['grams'] as double),
                    calories: row['calories'] as double,
                  ))
              .toList(),
        );
        batch.insertAll(
          _database.exercises,
          tables.exercises
              .map((row) => ExercisesCompanion.insert(
                    id: Value(row['id'] as int),
                    name: row['name'] as String,
                  ))
              .toList(),
        );
        batch.insertAll(
          _database.workouts,
          tables.workouts
              .map((row) => WorkoutsCompanion.insert(
                    id: Value(row['id'] as int),
                    startedAt: row['startedAt'] as DateTime,
                    notes: Value(row['notes'] as String?),
                  ))
              .toList(),
        );
        batch.insertAll(
          _database.workoutSets,
          tables.workoutSets
              .map((row) => WorkoutSetsCompanion.insert(
                    id: Value(row['id'] as int),
                    workoutId: row['workoutId'] as int,
                    exerciseId: row['exerciseId'] as int,
                    setNumber: row['setNumber'] as int,
                    reps: row['reps'] as int,
                    weightKg: row['weightKg'] as double,
                  ))
              .toList(),
        );
      });
    });
  }

  static Map<String, dynamic> _parseDocument(String contents) {
    try {
      final decoded = jsonDecode(contents);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Backup must be a JSON object.');
      }
      return decoded;
    } on FormatException {
      rethrow;
    } on Object {
      throw const FormatException('Backup is not valid JSON.');
    }
  }

  static _BackupTables _validateDocument(
    Map<String, dynamic> document,
    int schemaVersion,
  ) {
    const tableKeys = {
      'food_items',
      'meals',
      'meal_entries',
      'exercises',
      'workouts',
      'workout_sets',
    };
    if (document['schema_version'] != schemaVersion) {
      throw FormatException(
        'Unsupported backup schema_version: ${document['schema_version']}.',
      );
    }
    if (!document.keys.toSet().containsAll({'schema_version', ...tableKeys})) {
      throw const FormatException('Backup is missing one or more tables.');
    }
    final missingOrInvalid = document.entries
        .where((entry) =>
            entry.key != 'schema_version' && !tableKeys.contains(entry.key))
        .map((entry) => entry.key)
        .toList();
    if (missingOrInvalid.isNotEmpty) {
      throw FormatException(
          'Backup contains unknown table: ${missingOrInvalid.first}.');
    }

    final foodItems = _rows(
      document['food_items'],
      'food_items',
      {'id', 'name', 'caloriesPer100g'},
      (row) => {
        'id': _positiveInt(row, 'id', 'food_items'),
        'name': _string(row, 'name', 'food_items'),
        'caloriesPer100g': _finiteDouble(row, 'caloriesPer100g', 'food_items'),
      },
    );
    final meals = _rows(
      document['meals'],
      'meals',
      {'id', 'loggedAt', 'mealType'},
      (row) => {
        'id': _positiveInt(row, 'id', 'meals'),
        'loggedAt': _dateTime(row, 'loggedAt', 'meals'),
        'mealType': _string(row, 'mealType', 'meals'),
      },
    );
    final mealEntries = _rows(
      document['meal_entries'],
      'meal_entries',
      {'id', 'mealId', 'foodItemId', 'grams', 'calories'},
      (row) => {
        'id': _positiveInt(row, 'id', 'meal_entries'),
        'mealId': _positiveInt(row, 'mealId', 'meal_entries'),
        'foodItemId': _positiveInt(row, 'foodItemId', 'meal_entries'),
        'grams': _finiteDouble(row, 'grams', 'meal_entries'),
        'calories': _finiteDouble(row, 'calories', 'meal_entries'),
      },
    );
    final exercises = _rows(
      document['exercises'],
      'exercises',
      {'id', 'name'},
      (row) => {
        'id': _positiveInt(row, 'id', 'exercises'),
        'name': _string(row, 'name', 'exercises'),
      },
    );
    final workouts = _rows(
      document['workouts'],
      'workouts',
      {'id', 'startedAt', 'notes'},
      (row) => {
        'id': _positiveInt(row, 'id', 'workouts'),
        'startedAt': _dateTime(row, 'startedAt', 'workouts'),
        'notes': _nullableString(row, 'notes', 'workouts'),
      },
    );
    final workoutSets = _rows(
      document['workout_sets'],
      'workout_sets',
      {'id', 'workoutId', 'exerciseId', 'setNumber', 'reps', 'weightKg'},
      (row) => {
        'id': _positiveInt(row, 'id', 'workout_sets'),
        'workoutId': _positiveInt(row, 'workoutId', 'workout_sets'),
        'exerciseId': _positiveInt(row, 'exerciseId', 'workout_sets'),
        'setNumber': _positiveInt(row, 'setNumber', 'workout_sets'),
        'reps': _positiveInt(row, 'reps', 'workout_sets'),
        'weightKg': _finiteDouble(row, 'weightKg', 'workout_sets'),
      },
    );

    _ensureUniqueIds(foodItems, 'food_items');
    _ensureUniqueIds(meals, 'meals');
    _ensureUniqueIds(mealEntries, 'meal_entries');
    _ensureUniqueIds(exercises, 'exercises');
    _ensureUniqueIds(workouts, 'workouts');
    _ensureUniqueIds(workoutSets, 'workout_sets');
    _ensureReferences(mealEntries, 'mealId', meals, 'meals', 'meal_entries');
    _ensureReferences(
      mealEntries,
      'foodItemId',
      foodItems,
      'food_items',
      'meal_entries',
    );
    _ensureReferences(
        workoutSets, 'workoutId', workouts, 'workouts', 'workout_sets');
    _ensureReferences(
      workoutSets,
      'exerciseId',
      exercises,
      'exercises',
      'workout_sets',
    );

    return _BackupTables(
      foodItems: foodItems,
      meals: meals,
      mealEntries: mealEntries,
      exercises: exercises,
      workouts: workouts,
      workoutSets: workoutSets,
    );
  }

  static List<Map<String, dynamic>> _rows(
    dynamic value,
    String table,
    Set<String> fields,
    Map<String, dynamic> Function(Map<String, dynamic>) parse,
  ) {
    if (value is! List) {
      throw FormatException('Table "$table" must be an array.');
    }
    return value.asMap().entries.map((entry) {
      final rowNumber = entry.key + 1;
      final row = entry.value;
      if (row is! Map<String, dynamic>) {
        throw FormatException('$table row $rowNumber must be an object.');
      }
      if (!row.keys.toSet().containsAll(fields)) {
        throw FormatException('$table row $rowNumber is missing a field.');
      }
      final unknown = row.keys.where((key) => !fields.contains(key));
      if (unknown.isNotEmpty) {
        throw FormatException('$table row $rowNumber has an unknown field.');
      }
      try {
        return parse(row);
      } on FormatException catch (error) {
        throw FormatException('$table row $rowNumber: ${error.message}');
      }
    }).toList();
  }

  static int _positiveInt(
      Map<String, dynamic> row, String field, String table) {
    final value = row[field];
    if (value is! int || value <= 0) {
      throw FormatException('$table.$field must be a positive integer.');
    }
    return value;
  }

  static String _string(Map<String, dynamic> row, String field, String table) {
    final value = row[field];
    if (value is! String) {
      throw FormatException('$table.$field must be a string.');
    }
    return value;
  }

  static String? _nullableString(
    Map<String, dynamic> row,
    String field,
    String table,
  ) {
    final value = row[field];
    if (value != null && value is! String) {
      throw FormatException('$table.$field must be a string or null.');
    }
    return value as String?;
  }

  static double _finiteDouble(
    Map<String, dynamic> row,
    String field,
    String table,
  ) {
    final value = row[field];
    if (value is! num || value is bool || !value.toDouble().isFinite) {
      throw FormatException('$table.$field must be a finite number.');
    }
    return value.toDouble();
  }

  static DateTime _dateTime(
    Map<String, dynamic> row,
    String field,
    String table,
  ) {
    final value = row[field];
    if (value is! String) {
      throw FormatException('$table.$field must be an ISO-8601 string.');
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw FormatException('$table.$field must be an ISO-8601 string.');
    }
    return parsed;
  }

  static void _ensureUniqueIds(List<Map<String, dynamic>> rows, String table) {
    final ids = <int>{};
    for (final row in rows) {
      if (!ids.add(row['id'] as int)) {
        throw FormatException('$table contains duplicate ids.');
      }
    }
  }

  static void _ensureReferences(
    List<Map<String, dynamic>> rows,
    String field,
    List<Map<String, dynamic>> referencedRows,
    String referencedTable,
    String table,
  ) {
    final ids = referencedRows.map((row) => row['id'] as int).toSet();
    for (final row in rows) {
      if (!ids.contains(row[field])) {
        throw FormatException(
          '$table.$field references a missing $referencedTable row.',
        );
      }
    }
  }

  static Map<String, dynamic> _foodItemToJson(FoodItem item) => {
        'id': item.id,
        'name': item.name,
        'caloriesPer100g': item.caloriesPer100g,
      };

  static Map<String, dynamic> _mealToJson(Meal meal) => {
        'id': meal.id,
        'loggedAt': meal.loggedAt.toIso8601String(),
        'mealType': meal.mealType,
      };

  static Map<String, dynamic> _mealEntryToJson(MealEntry entry) => {
        'id': entry.id,
        'mealId': entry.mealId,
        'foodItemId': entry.foodItemId,
        'grams': entry.grams,
        'calories': entry.calories,
      };

  static Map<String, dynamic> _exerciseToJson(Exercise exercise) => {
        'id': exercise.id,
        'name': exercise.name,
      };

  static Map<String, dynamic> _workoutToJson(Workout workout) => {
        'id': workout.id,
        'startedAt': workout.startedAt.toIso8601String(),
        'notes': workout.notes,
      };

  static Map<String, dynamic> _workoutSetToJson(WorkoutSet set) => {
        'id': set.id,
        'workoutId': set.workoutId,
        'exerciseId': set.exerciseId,
        'setNumber': set.setNumber,
        'reps': set.reps,
        'weightKg': set.weightKg,
      };
}

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});

class _BackupTables {
  const _BackupTables({
    required this.foodItems,
    required this.meals,
    required this.mealEntries,
    required this.exercises,
    required this.workouts,
    required this.workoutSets,
  });

  final List<Map<String, dynamic>> foodItems;
  final List<Map<String, dynamic>> meals;
  final List<Map<String, dynamic>> mealEntries;
  final List<Map<String, dynamic>> exercises;
  final List<Map<String, dynamic>> workouts;
  final List<Map<String, dynamic>> workoutSets;
}
