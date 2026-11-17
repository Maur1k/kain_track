// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FoodsTable extends Foods with TableInfo<$FoodsTable, Food> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _caloriesPer100gMeta =
      const VerificationMeta('caloriesPer100g');
  @override
  late final GeneratedColumn<double> caloriesPer100g = GeneratedColumn<double>(
      'calories_per100g', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _proteinPer100gMeta =
      const VerificationMeta('proteinPer100g');
  @override
  late final GeneratedColumn<double> proteinPer100g = GeneratedColumn<double>(
      'protein_per100g', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _carbsPer100gMeta =
      const VerificationMeta('carbsPer100g');
  @override
  late final GeneratedColumn<double> carbsPer100g = GeneratedColumn<double>(
      'carbs_per100g', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fatPer100gMeta =
      const VerificationMeta('fatPer100g');
  @override
  late final GeneratedColumn<double> fatPer100g = GeneratedColumn<double>(
      'fat_per100g', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Protein'));
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        caloriesPer100g,
        proteinPer100g,
        carbsPer100g,
        fatPer100g,
        category,
        isCustom
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(Insertable<Food> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('calories_per100g')) {
      context.handle(
          _caloriesPer100gMeta,
          caloriesPer100g.isAcceptableOrUnknown(
              data['calories_per100g']!, _caloriesPer100gMeta));
    } else if (isInserting) {
      context.missing(_caloriesPer100gMeta);
    }
    if (data.containsKey('protein_per100g')) {
      context.handle(
          _proteinPer100gMeta,
          proteinPer100g.isAcceptableOrUnknown(
              data['protein_per100g']!, _proteinPer100gMeta));
    } else if (isInserting) {
      context.missing(_proteinPer100gMeta);
    }
    if (data.containsKey('carbs_per100g')) {
      context.handle(
          _carbsPer100gMeta,
          carbsPer100g.isAcceptableOrUnknown(
              data['carbs_per100g']!, _carbsPer100gMeta));
    } else if (isInserting) {
      context.missing(_carbsPer100gMeta);
    }
    if (data.containsKey('fat_per100g')) {
      context.handle(
          _fatPer100gMeta,
          fatPer100g.isAcceptableOrUnknown(
              data['fat_per100g']!, _fatPer100gMeta));
    } else if (isInserting) {
      context.missing(_fatPer100gMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Food map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Food(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      caloriesPer100g: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}calories_per100g'])!,
      proteinPer100g: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}protein_per100g'])!,
      carbsPer100g: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbs_per100g'])!,
      fatPer100g: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat_per100g'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }
}

class Food extends DataClass implements Insertable<Food> {
  final int id;
  final String name;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final String category;
  final bool isCustom;
  const Food(
      {required this.id,
      required this.name,
      required this.caloriesPer100g,
      required this.proteinPer100g,
      required this.carbsPer100g,
      required this.fatPer100g,
      required this.category,
      required this.isCustom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['calories_per100g'] = Variable<double>(caloriesPer100g);
    map['protein_per100g'] = Variable<double>(proteinPer100g);
    map['carbs_per100g'] = Variable<double>(carbsPer100g);
    map['fat_per100g'] = Variable<double>(fatPer100g);
    map['category'] = Variable<String>(category);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      id: Value(id),
      name: Value(name),
      caloriesPer100g: Value(caloriesPer100g),
      proteinPer100g: Value(proteinPer100g),
      carbsPer100g: Value(carbsPer100g),
      fatPer100g: Value(fatPer100g),
      category: Value(category),
      isCustom: Value(isCustom),
    );
  }

  factory Food.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Food(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      caloriesPer100g: serializer.fromJson<double>(json['caloriesPer100g']),
      proteinPer100g: serializer.fromJson<double>(json['proteinPer100g']),
      carbsPer100g: serializer.fromJson<double>(json['carbsPer100g']),
      fatPer100g: serializer.fromJson<double>(json['fatPer100g']),
      category: serializer.fromJson<String>(json['category']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'caloriesPer100g': serializer.toJson<double>(caloriesPer100g),
      'proteinPer100g': serializer.toJson<double>(proteinPer100g),
      'carbsPer100g': serializer.toJson<double>(carbsPer100g),
      'fatPer100g': serializer.toJson<double>(fatPer100g),
      'category': serializer.toJson<String>(category),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Food copyWith(
          {int? id,
          String? name,
          double? caloriesPer100g,
          double? proteinPer100g,
          double? carbsPer100g,
          double? fatPer100g,
          String? category,
          bool? isCustom}) =>
      Food(
        id: id ?? this.id,
        name: name ?? this.name,
        caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
        proteinPer100g: proteinPer100g ?? this.proteinPer100g,
        carbsPer100g: carbsPer100g ?? this.carbsPer100g,
        fatPer100g: fatPer100g ?? this.fatPer100g,
        category: category ?? this.category,
        isCustom: isCustom ?? this.isCustom,
      );
  Food copyWithCompanion(FoodsCompanion data) {
    return Food(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      caloriesPer100g: data.caloriesPer100g.present
          ? data.caloriesPer100g.value
          : this.caloriesPer100g,
      proteinPer100g: data.proteinPer100g.present
          ? data.proteinPer100g.value
          : this.proteinPer100g,
      carbsPer100g: data.carbsPer100g.present
          ? data.carbsPer100g.value
          : this.carbsPer100g,
      fatPer100g:
          data.fatPer100g.present ? data.fatPer100g.value : this.fatPer100g,
      category: data.category.present ? data.category.value : this.category,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Food(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fatPer100g: $fatPer100g, ')
          ..write('category: $category, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, caloriesPer100g, proteinPer100g,
      carbsPer100g, fatPer100g, category, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Food &&
          other.id == this.id &&
          other.name == this.name &&
          other.caloriesPer100g == this.caloriesPer100g &&
          other.proteinPer100g == this.proteinPer100g &&
          other.carbsPer100g == this.carbsPer100g &&
          other.fatPer100g == this.fatPer100g &&
          other.category == this.category &&
          other.isCustom == this.isCustom);
}

class FoodsCompanion extends UpdateCompanion<Food> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> caloriesPer100g;
  final Value<double> proteinPer100g;
  final Value<double> carbsPer100g;
  final Value<double> fatPer100g;
  final Value<String> category;
  final Value<bool> isCustom;
  const FoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.caloriesPer100g = const Value.absent(),
    this.proteinPer100g = const Value.absent(),
    this.carbsPer100g = const Value.absent(),
    this.fatPer100g = const Value.absent(),
    this.category = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  FoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double caloriesPer100g,
    required double proteinPer100g,
    required double carbsPer100g,
    required double fatPer100g,
    this.category = const Value.absent(),
    this.isCustom = const Value.absent(),
  })  : name = Value(name),
        caloriesPer100g = Value(caloriesPer100g),
        proteinPer100g = Value(proteinPer100g),
        carbsPer100g = Value(carbsPer100g),
        fatPer100g = Value(fatPer100g);
  static Insertable<Food> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? caloriesPer100g,
    Expression<double>? proteinPer100g,
    Expression<double>? carbsPer100g,
    Expression<double>? fatPer100g,
    Expression<String>? category,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (caloriesPer100g != null) 'calories_per100g': caloriesPer100g,
      if (proteinPer100g != null) 'protein_per100g': proteinPer100g,
      if (carbsPer100g != null) 'carbs_per100g': carbsPer100g,
      if (fatPer100g != null) 'fat_per100g': fatPer100g,
      if (category != null) 'category': category,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  FoodsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? caloriesPer100g,
      Value<double>? proteinPer100g,
      Value<double>? carbsPer100g,
      Value<double>? fatPer100g,
      Value<String>? category,
      Value<bool>? isCustom}) {
    return FoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      proteinPer100g: proteinPer100g ?? this.proteinPer100g,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      fatPer100g: fatPer100g ?? this.fatPer100g,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (caloriesPer100g.present) {
      map['calories_per100g'] = Variable<double>(caloriesPer100g.value);
    }
    if (proteinPer100g.present) {
      map['protein_per100g'] = Variable<double>(proteinPer100g.value);
    }
    if (carbsPer100g.present) {
      map['carbs_per100g'] = Variable<double>(carbsPer100g.value);
    }
    if (fatPer100g.present) {
      map['fat_per100g'] = Variable<double>(fatPer100g.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fatPer100g: $fatPer100g, ')
          ..write('category: $category, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $MealEntriesTable extends MealEntries
    with TableInfo<$MealEntriesTable, MealEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
      'food_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES foods (id)'));
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
      'grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _mealSlotMeta =
      const VerificationMeta('mealSlot');
  @override
  late final GeneratedColumn<String> mealSlot = GeneratedColumn<String>(
      'meal_slot', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _loggedAtMeta =
      const VerificationMeta('loggedAt');
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
      'logged_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, foodId, grams, mealSlot, loggedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_entries';
  @override
  VerificationContext validateIntegrity(Insertable<MealEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('food_id')) {
      context.handle(_foodIdMeta,
          foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta));
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('grams')) {
      context.handle(
          _gramsMeta, grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta));
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('meal_slot')) {
      context.handle(_mealSlotMeta,
          mealSlot.isAcceptableOrUnknown(data['meal_slot']!, _mealSlotMeta));
    } else if (isInserting) {
      context.missing(_mealSlotMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(_loggedAtMeta,
          loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta));
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      foodId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}food_id'])!,
      grams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}grams'])!,
      mealSlot: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_slot'])!,
      loggedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}logged_at'])!,
    );
  }

  @override
  $MealEntriesTable createAlias(String alias) {
    return $MealEntriesTable(attachedDatabase, alias);
  }
}

class MealEntry extends DataClass implements Insertable<MealEntry> {
  final int id;
  final int foodId;
  final double grams;
  final String mealSlot;
  final DateTime loggedAt;
  const MealEntry(
      {required this.id,
      required this.foodId,
      required this.grams,
      required this.mealSlot,
      required this.loggedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['food_id'] = Variable<int>(foodId);
    map['grams'] = Variable<double>(grams);
    map['meal_slot'] = Variable<String>(mealSlot);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    return map;
  }

  MealEntriesCompanion toCompanion(bool nullToAbsent) {
    return MealEntriesCompanion(
      id: Value(id),
      foodId: Value(foodId),
      grams: Value(grams),
      mealSlot: Value(mealSlot),
      loggedAt: Value(loggedAt),
    );
  }

  factory MealEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealEntry(
      id: serializer.fromJson<int>(json['id']),
      foodId: serializer.fromJson<int>(json['foodId']),
      grams: serializer.fromJson<double>(json['grams']),
      mealSlot: serializer.fromJson<String>(json['mealSlot']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'foodId': serializer.toJson<int>(foodId),
      'grams': serializer.toJson<double>(grams),
      'mealSlot': serializer.toJson<String>(mealSlot),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
    };
  }

  MealEntry copyWith(
          {int? id,
          int? foodId,
          double? grams,
          String? mealSlot,
          DateTime? loggedAt}) =>
      MealEntry(
        id: id ?? this.id,
        foodId: foodId ?? this.foodId,
        grams: grams ?? this.grams,
        mealSlot: mealSlot ?? this.mealSlot,
        loggedAt: loggedAt ?? this.loggedAt,
      );
  MealEntry copyWithCompanion(MealEntriesCompanion data) {
    return MealEntry(
      id: data.id.present ? data.id.value : this.id,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      grams: data.grams.present ? data.grams.value : this.grams,
      mealSlot: data.mealSlot.present ? data.mealSlot.value : this.mealSlot,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealEntry(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('grams: $grams, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, foodId, grams, mealSlot, loggedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealEntry &&
          other.id == this.id &&
          other.foodId == this.foodId &&
          other.grams == this.grams &&
          other.mealSlot == this.mealSlot &&
          other.loggedAt == this.loggedAt);
}

class MealEntriesCompanion extends UpdateCompanion<MealEntry> {
  final Value<int> id;
  final Value<int> foodId;
  final Value<double> grams;
  final Value<String> mealSlot;
  final Value<DateTime> loggedAt;
  const MealEntriesCompanion({
    this.id = const Value.absent(),
    this.foodId = const Value.absent(),
    this.grams = const Value.absent(),
    this.mealSlot = const Value.absent(),
    this.loggedAt = const Value.absent(),
  });
  MealEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int foodId,
    required double grams,
    required String mealSlot,
    required DateTime loggedAt,
  })  : foodId = Value(foodId),
        grams = Value(grams),
        mealSlot = Value(mealSlot),
        loggedAt = Value(loggedAt);
  static Insertable<MealEntry> custom({
    Expression<int>? id,
    Expression<int>? foodId,
    Expression<double>? grams,
    Expression<String>? mealSlot,
    Expression<DateTime>? loggedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodId != null) 'food_id': foodId,
      if (grams != null) 'grams': grams,
      if (mealSlot != null) 'meal_slot': mealSlot,
      if (loggedAt != null) 'logged_at': loggedAt,
    });
  }

  MealEntriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? foodId,
      Value<double>? grams,
      Value<String>? mealSlot,
      Value<DateTime>? loggedAt}) {
    return MealEntriesCompanion(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      grams: grams ?? this.grams,
      mealSlot: mealSlot ?? this.mealSlot,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (mealSlot.present) {
      map['meal_slot'] = Variable<String>(mealSlot.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealEntriesCompanion(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('grams: $grams, ')
          ..write('mealSlot: $mealSlot, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _performedAtMeta =
      const VerificationMeta('performedAt');
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
      'performed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, durationMinutes, notes, performedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('performed_at')) {
      context.handle(
          _performedAtMeta,
          performedAt.isAcceptableOrUnknown(
              data['performed_at']!, _performedAtMeta));
    } else if (isInserting) {
      context.missing(_performedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      performedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}performed_at'])!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final int id;
  final String name;
  final int? durationMinutes;
  final String? notes;
  final DateTime performedAt;
  const WorkoutSession(
      {required this.id,
      required this.name,
      this.durationMinutes,
      this.notes,
      required this.performedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['performed_at'] = Variable<DateTime>(performedAt);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      name: Value(name),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      performedAt: Value(performedAt),
    );
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
      notes: serializer.fromJson<String?>(json['notes']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
      'notes': serializer.toJson<String?>(notes),
      'performedAt': serializer.toJson<DateTime>(performedAt),
    };
  }

  WorkoutSession copyWith(
          {int? id,
          String? name,
          Value<int?> durationMinutes = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? performedAt}) =>
      WorkoutSession(
        id: id ?? this.id,
        name: name ?? this.name,
        durationMinutes: durationMinutes.present
            ? durationMinutes.value
            : this.durationMinutes,
        notes: notes.present ? notes.value : this.notes,
        performedAt: performedAt ?? this.performedAt,
      );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      notes: data.notes.present ? data.notes.value : this.notes,
      performedAt:
          data.performedAt.present ? data.performedAt.value : this.performedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes, ')
          ..write('performedAt: $performedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, durationMinutes, notes, performedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.name == this.name &&
          other.durationMinutes == this.durationMinutes &&
          other.notes == this.notes &&
          other.performedAt == this.performedAt);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> durationMinutes;
  final Value<String?> notes;
  final Value<DateTime> performedAt;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    this.performedAt = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.durationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime performedAt,
  })  : name = Value(name),
        performedAt = Value(performedAt);
  static Insertable<WorkoutSession> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? durationMinutes,
    Expression<String>? notes,
    Expression<DateTime>? performedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (notes != null) 'notes': notes,
      if (performedAt != null) 'performed_at': performedAt,
    });
  }

  WorkoutSessionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int?>? durationMinutes,
      Value<String?>? notes,
      Value<DateTime>? performedAt}) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      performedAt: performedAt ?? this.performedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes, ')
          ..write('performedAt: $performedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $MealEntriesTable mealEntries = $MealEntriesTable(this);
  late final $WorkoutSessionsTable workoutSessions =
      $WorkoutSessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [foods, mealEntries, workoutSessions];
}

typedef $$FoodsTableCreateCompanionBuilder = FoodsCompanion Function({
  Value<int> id,
  required String name,
  required double caloriesPer100g,
  required double proteinPer100g,
  required double carbsPer100g,
  required double fatPer100g,
  Value<String> category,
  Value<bool> isCustom,
});
typedef $$FoodsTableUpdateCompanionBuilder = FoodsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> caloriesPer100g,
  Value<double> proteinPer100g,
  Value<double> carbsPer100g,
  Value<double> fatPer100g,
  Value<String> category,
  Value<bool> isCustom,
});

final class $$FoodsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodsTable, Food> {
  $$FoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealEntriesTable, List<MealEntry>>
      _mealEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.mealEntries,
          aliasName: $_aliasNameGenerator(db.foods.id, db.mealEntries.foodId));

  $$MealEntriesTableProcessedTableManager get mealEntriesRefs {
    final manager = $$MealEntriesTableTableManager($_db, $_db.mealEntries)
        .filter((f) => f.foodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$FoodsTableFilterComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get caloriesPer100g => $composableBuilder(
      column: $table.caloriesPer100g,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteinPer100g => $composableBuilder(
      column: $table.proteinPer100g,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbsPer100g => $composableBuilder(
      column: $table.carbsPer100g, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fatPer100g => $composableBuilder(
      column: $table.fatPer100g, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  Expression<bool> mealEntriesRefs(
      Expression<bool> Function($$MealEntriesTableFilterComposer f) f) {
    final $$MealEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealEntries,
        getReferencedColumn: (t) => t.foodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealEntriesTableFilterComposer(
              $db: $db,
              $table: $db.mealEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get caloriesPer100g => $composableBuilder(
      column: $table.caloriesPer100g,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteinPer100g => $composableBuilder(
      column: $table.proteinPer100g,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbsPer100g => $composableBuilder(
      column: $table.carbsPer100g,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fatPer100g => $composableBuilder(
      column: $table.fatPer100g, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get caloriesPer100g => $composableBuilder(
      column: $table.caloriesPer100g, builder: (column) => column);

  GeneratedColumn<double> get proteinPer100g => $composableBuilder(
      column: $table.proteinPer100g, builder: (column) => column);

  GeneratedColumn<double> get carbsPer100g => $composableBuilder(
      column: $table.carbsPer100g, builder: (column) => column);

  GeneratedColumn<double> get fatPer100g => $composableBuilder(
      column: $table.fatPer100g, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  Expression<T> mealEntriesRefs<T extends Object>(
      Expression<T> Function($$MealEntriesTableAnnotationComposer a) f) {
    final $$MealEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealEntries,
        getReferencedColumn: (t) => t.foodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.mealEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FoodsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FoodsTable,
    Food,
    $$FoodsTableFilterComposer,
    $$FoodsTableOrderingComposer,
    $$FoodsTableAnnotationComposer,
    $$FoodsTableCreateCompanionBuilder,
    $$FoodsTableUpdateCompanionBuilder,
    (Food, $$FoodsTableReferences),
    Food,
    PrefetchHooks Function({bool mealEntriesRefs})> {
  $$FoodsTableTableManager(_$AppDatabase db, $FoodsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> caloriesPer100g = const Value.absent(),
            Value<double> proteinPer100g = const Value.absent(),
            Value<double> carbsPer100g = const Value.absent(),
            Value<double> fatPer100g = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
          }) =>
              FoodsCompanion(
            id: id,
            name: name,
            caloriesPer100g: caloriesPer100g,
            proteinPer100g: proteinPer100g,
            carbsPer100g: carbsPer100g,
            fatPer100g: fatPer100g,
            category: category,
            isCustom: isCustom,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double caloriesPer100g,
            required double proteinPer100g,
            required double carbsPer100g,
            required double fatPer100g,
            Value<String> category = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
          }) =>
              FoodsCompanion.insert(
            id: id,
            name: name,
            caloriesPer100g: caloriesPer100g,
            proteinPer100g: proteinPer100g,
            carbsPer100g: carbsPer100g,
            fatPer100g: fatPer100g,
            category: category,
            isCustom: isCustom,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$FoodsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({mealEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mealEntriesRefs) db.mealEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealEntriesRefs)
                    await $_getPrefetchedData<Food, $FoodsTable, MealEntry>(
                        currentTable: table,
                        referencedTable:
                            $$FoodsTableReferences._mealEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FoodsTableReferences(db, table, p0)
                                .mealEntriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.foodId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$FoodsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FoodsTable,
    Food,
    $$FoodsTableFilterComposer,
    $$FoodsTableOrderingComposer,
    $$FoodsTableAnnotationComposer,
    $$FoodsTableCreateCompanionBuilder,
    $$FoodsTableUpdateCompanionBuilder,
    (Food, $$FoodsTableReferences),
    Food,
    PrefetchHooks Function({bool mealEntriesRefs})>;
typedef $$MealEntriesTableCreateCompanionBuilder = MealEntriesCompanion
    Function({
  Value<int> id,
  required int foodId,
  required double grams,
  required String mealSlot,
  required DateTime loggedAt,
});
typedef $$MealEntriesTableUpdateCompanionBuilder = MealEntriesCompanion
    Function({
  Value<int> id,
  Value<int> foodId,
  Value<double> grams,
  Value<String> mealSlot,
  Value<DateTime> loggedAt,
});

final class $$MealEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $MealEntriesTable, MealEntry> {
  $$MealEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoodsTable _foodIdTable(_$AppDatabase db) => db.foods
      .createAlias($_aliasNameGenerator(db.mealEntries.foodId, db.foods.id));

  $$FoodsTableProcessedTableManager get foodId {
    final $_column = $_itemColumn<int>('food_id')!;

    final manager = $$FoodsTableTableManager($_db, $_db.foods)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MealEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MealEntriesTable> {
  $$MealEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get grams => $composableBuilder(
      column: $table.grams, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealSlot => $composableBuilder(
      column: $table.mealSlot, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnFilters(column));

  $$FoodsTableFilterComposer get foodId {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.foodId,
        referencedTable: $db.foods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoodsTableFilterComposer(
              $db: $db,
              $table: $db.foods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MealEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealEntriesTable> {
  $$MealEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get grams => $composableBuilder(
      column: $table.grams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealSlot => $composableBuilder(
      column: $table.mealSlot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnOrderings(column));

  $$FoodsTableOrderingComposer get foodId {
    final $$FoodsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.foodId,
        referencedTable: $db.foods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoodsTableOrderingComposer(
              $db: $db,
              $table: $db.foods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MealEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealEntriesTable> {
  $$MealEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<String> get mealSlot =>
      $composableBuilder(column: $table.mealSlot, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  $$FoodsTableAnnotationComposer get foodId {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.foodId,
        referencedTable: $db.foods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoodsTableAnnotationComposer(
              $db: $db,
              $table: $db.foods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MealEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealEntriesTable,
    MealEntry,
    $$MealEntriesTableFilterComposer,
    $$MealEntriesTableOrderingComposer,
    $$MealEntriesTableAnnotationComposer,
    $$MealEntriesTableCreateCompanionBuilder,
    $$MealEntriesTableUpdateCompanionBuilder,
    (MealEntry, $$MealEntriesTableReferences),
    MealEntry,
    PrefetchHooks Function({bool foodId})> {
  $$MealEntriesTableTableManager(_$AppDatabase db, $MealEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> foodId = const Value.absent(),
            Value<double> grams = const Value.absent(),
            Value<String> mealSlot = const Value.absent(),
            Value<DateTime> loggedAt = const Value.absent(),
          }) =>
              MealEntriesCompanion(
            id: id,
            foodId: foodId,
            grams: grams,
            mealSlot: mealSlot,
            loggedAt: loggedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int foodId,
            required double grams,
            required String mealSlot,
            required DateTime loggedAt,
          }) =>
              MealEntriesCompanion.insert(
            id: id,
            foodId: foodId,
            grams: grams,
            mealSlot: mealSlot,
            loggedAt: loggedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MealEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({foodId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (foodId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.foodId,
                    referencedTable:
                        $$MealEntriesTableReferences._foodIdTable(db),
                    referencedColumn:
                        $$MealEntriesTableReferences._foodIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MealEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealEntriesTable,
    MealEntry,
    $$MealEntriesTableFilterComposer,
    $$MealEntriesTableOrderingComposer,
    $$MealEntriesTableAnnotationComposer,
    $$MealEntriesTableCreateCompanionBuilder,
    $$MealEntriesTableUpdateCompanionBuilder,
    (MealEntry, $$MealEntriesTableReferences),
    MealEntry,
    PrefetchHooks Function({bool foodId})>;
typedef $$WorkoutSessionsTableCreateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<int?> durationMinutes,
  Value<String?> notes,
  required DateTime performedAt,
});
typedef $$WorkoutSessionsTableUpdateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int?> durationMinutes,
  Value<String?> notes,
  Value<DateTime> performedAt,
});

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => ColumnFilters(column));
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => column);
}

class $$WorkoutSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSession,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (
      WorkoutSession,
      BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession>
    ),
    WorkoutSession,
    PrefetchHooks Function()> {
  $$WorkoutSessionsTableTableManager(
      _$AppDatabase db, $WorkoutSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> durationMinutes = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> performedAt = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion(
            id: id,
            name: name,
            durationMinutes: durationMinutes,
            notes: notes,
            performedAt: performedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int?> durationMinutes = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime performedAt,
          }) =>
              WorkoutSessionsCompanion.insert(
            id: id,
            name: name,
            durationMinutes: durationMinutes,
            notes: notes,
            performedAt: performedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkoutSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSession,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (
      WorkoutSession,
      BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession>
    ),
    WorkoutSession,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
  $$MealEntriesTableTableManager get mealEntries =>
      $$MealEntriesTableTableManager(_db, _db.mealEntries);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
}
