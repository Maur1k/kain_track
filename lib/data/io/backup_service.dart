import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';

class BackupService {
  BackupService(this._database);

  final AppDatabase _database;

  Future<String> exportJson() async {
    final foods = await (_database.select(_database.foods)
          ..orderBy([(food) => OrderingTerm.asc(food.id)]))
        .get();
    final mealEntries = await (_database.select(_database.mealEntries)
          ..orderBy([(entry) => OrderingTerm.asc(entry.id)]))
        .get();
    final workouts = await (_database.select(_database.workoutSessions)
          ..orderBy([(session) => OrderingTerm.asc(session.id)]))
        .get();
    return const JsonEncoder.withIndent('  ').convert({
      'schema_version': _database.schemaVersion,
      'foods': foods.map(_foodToJson).toList(),
      'meal_entries': mealEntries.map(_mealEntryToJson).toList(),
      'workout_sessions': workouts.map(_workoutToJson).toList(),
    });
  }

  Future<void> importJson(String contents) async {
    final tables = _validateDocument(_parseDocument(contents));
    await _database.transaction(() async {
      await _database.delete(_database.mealEntries).go();
      await _database.delete(_database.workoutSessions).go();
      await _database.delete(_database.foods).go();
      await _database.batch((batch) {
        batch.insertAll(
          _database.foods,
          tables.foods
              .map(
                (row) => FoodsCompanion.insert(
                  id: Value(row['id'] as int),
                  name: row['name'] as String,
                  caloriesPer100g: row['caloriesPer100g'] as double,
                  proteinPer100g: row['proteinPer100g'] as double,
                  carbsPer100g: row['carbsPer100g'] as double,
                  fatPer100g: row['fatPer100g'] as double,
                  category: Value(row['category'] as String),
                  isCustom: Value(row['isCustom'] as bool),
                ),
              )
              .toList(),
        );
        batch.insertAll(
          _database.mealEntries,
          tables.mealEntries
              .map(
                (row) => MealEntriesCompanion.insert(
                  id: Value(row['id'] as int),
                  foodId: row['foodId'] as int,
                  grams: row['grams'] as double,
                  mealSlot: row['mealSlot'] as String,
                  loggedAt: row['loggedAt'] as DateTime,
                ),
              )
              .toList(),
        );
        batch.insertAll(
          _database.workoutSessions,
          tables.workouts
              .map(
                (row) => WorkoutSessionsCompanion.insert(
                  id: Value(row['id'] as int),
                  name: row['name'] as String,
                  durationMinutes: Value(row['durationMinutes'] as int?),
                  notes: Value(row['notes'] as String?),
                  performedAt: row['performedAt'] as DateTime,
                ),
              )
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

  static _BackupTables _validateDocument(Map<String, dynamic> document) {
    const keys = {'foods', 'meal_entries', 'workout_sessions'};
    if (document['schema_version'] != AppDatabase.currentSchemaVersion) {
      throw FormatException(
        'Unsupported backup schema_version: ${document['schema_version']}.',
      );
    }
    if (!document.keys.toSet().containsAll({'schema_version', ...keys})) {
      throw const FormatException('Backup is missing one or more tables.');
    }
    final unknown = document.keys.where(
      (key) => key != 'schema_version' && !keys.contains(key),
    );
    if (unknown.isNotEmpty) {
      throw FormatException('Backup contains unknown table: ${unknown.first}.');
    }
    final foods = _rows(document['foods'], 'foods', {
      'id',
      'name',
      'caloriesPer100g',
      'proteinPer100g',
      'carbsPer100g',
      'fatPer100g',
      'category',
      'isCustom',
    }, (row) {
      return {
        'id': _positiveInt(row, 'id', 'foods'),
        'name': _string(row, 'name', 'foods'),
        'caloriesPer100g': _number(row, 'caloriesPer100g', 'foods'),
        'proteinPer100g': _number(row, 'proteinPer100g', 'foods'),
        'carbsPer100g': _number(row, 'carbsPer100g', 'foods'),
        'fatPer100g': _number(row, 'fatPer100g', 'foods'),
        'category': row.containsKey('category')
            ? _string(row, 'category', 'foods')
            : 'Protein',
        'isCustom': _bool(row, 'isCustom', 'foods'),
      };
    }, optionalFields: {'category'});
    final mealEntries = _rows(document['meal_entries'], 'meal_entries', {
      'id',
      'foodId',
      'grams',
      'mealSlot',
      'loggedAt',
    }, (row) {
      return {
        'id': _positiveInt(row, 'id', 'meal_entries'),
        'foodId': _positiveInt(row, 'foodId', 'meal_entries'),
        'grams': _positiveNumber(row, 'grams', 'meal_entries'),
        'mealSlot': _string(row, 'mealSlot', 'meal_entries'),
        'loggedAt': _dateTime(row, 'loggedAt', 'meal_entries'),
      };
    });
    final workouts = _rows(document['workout_sessions'], 'workout_sessions', {
      'id',
      'name',
      'durationMinutes',
      'notes',
      'performedAt',
    }, (row) {
      return {
        'id': _positiveInt(row, 'id', 'workout_sessions'),
        'name': _string(row, 'name', 'workout_sessions'),
        'durationMinutes':
            _nullableInt(row, 'durationMinutes', 'workout_sessions'),
        'notes': _nullableString(row, 'notes', 'workout_sessions'),
        'performedAt': _dateTime(row, 'performedAt', 'workout_sessions'),
      };
    });
    _ensureUniqueIds(foods, 'foods');
    _ensureUniqueIds(mealEntries, 'meal_entries');
    _ensureUniqueIds(workouts, 'workout_sessions');
    _ensureReferences(mealEntries, foods, 'foodId', 'foods', 'meal_entries');
    return _BackupTables(
      foods: foods,
      mealEntries: mealEntries,
      workouts: workouts,
    );
  }

  static List<Map<String, dynamic>> _rows(
      dynamic value,
      String table,
      Set<String> fields,
      Map<String, dynamic> Function(Map<String, dynamic>) parse,
      {Set<String> optionalFields = const {}}) {
    if (value is! List) {
      throw FormatException('Table "$table" must be an array.');
    }
    return value.asMap().entries.map((entry) {
      final rowNumber = entry.key + 1;
      final row = entry.value;
      if (row is! Map<String, dynamic>) {
        throw FormatException('$table row $rowNumber must be an object.');
      }
      if (!row.keys.toSet().containsAll(fields.difference(optionalFields))) {
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

  static int? _nullableInt(
    Map<String, dynamic> row,
    String field,
    String table,
  ) {
    final value = row[field];
    if (value != null && (value is! int || value <= 0)) {
      throw FormatException(
          '$table.$field must be a positive integer or null.');
    }
    return value as int?;
  }

  static bool _bool(Map<String, dynamic> row, String field, String table) {
    final value = row[field];
    if (value is! bool) {
      throw FormatException('$table.$field must be a boolean.');
    }
    return value;
  }

  static String _string(Map<String, dynamic> row, String field, String table) {
    final value = row[field];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('$table.$field must be a non-empty string.');
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

  static double _number(Map<String, dynamic> row, String field, String table) {
    final value = row[field];
    if (value is! num ||
        value is bool ||
        !value.toDouble().isFinite ||
        value < 0) {
      throw FormatException('$table.$field must be a finite number.');
    }
    return value.toDouble();
  }

  static double _positiveNumber(
    Map<String, dynamic> row,
    String field,
    String table,
  ) {
    final value = _number(row, field, table);
    if (value <= 0) throw FormatException('$table.$field must be positive.');
    return value;
  }

  static DateTime _dateTime(
    Map<String, dynamic> row,
    String field,
    String table,
  ) {
    final value = row[field];
    final parsed = value is String ? DateTime.tryParse(value) : null;
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
    List<Map<String, dynamic>> referenced,
    String field,
    String referencedTable,
    String table,
  ) {
    final ids = referenced.map((row) => row['id'] as int).toSet();
    for (final row in rows) {
      if (!ids.contains(row[field])) {
        throw FormatException(
          '$table.$field references a missing $referencedTable row.',
        );
      }
    }
  }

  static Map<String, dynamic> _foodToJson(Food food) => {
        'id': food.id,
        'name': food.name,
        'caloriesPer100g': food.caloriesPer100g,
        'proteinPer100g': food.proteinPer100g,
        'carbsPer100g': food.carbsPer100g,
        'fatPer100g': food.fatPer100g,
        'category': food.category,
        'isCustom': food.isCustom,
      };

  static Map<String, dynamic> _mealEntryToJson(MealEntry entry) => {
        'id': entry.id,
        'foodId': entry.foodId,
        'grams': entry.grams,
        'mealSlot': entry.mealSlot,
        'loggedAt': entry.loggedAt.toIso8601String(),
      };

  static Map<String, dynamic> _workoutToJson(WorkoutSession session) => {
        'id': session.id,
        'name': session.name,
        'durationMinutes': session.durationMinutes,
        'notes': session.notes,
        'performedAt': session.performedAt.toIso8601String(),
      };
}

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});

class _BackupTables {
  const _BackupTables({
    required this.foods,
    required this.mealEntries,
    required this.workouts,
  });

  final List<Map<String, dynamic>> foods;
  final List<Map<String, dynamic>> mealEntries;
  final List<Map<String, dynamic>> workouts;
}
