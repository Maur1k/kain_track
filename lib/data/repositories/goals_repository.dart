import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NutritionGoals {
  const NutritionGoals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  static const defaults = NutritionGoals(
    calories: 1800,
    protein: 135,
    carbs: 180,
    fat: 60,
  );

  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  void validate() {
    if (calories < 800 || calories > 6000) {
      throw ArgumentError.value(
        calories,
        'calories',
        'Calories must be between 800 and 6000.',
      );
    }
    for (final entry in {
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    }.entries) {
      if (entry.value < 1 || entry.value > 1000) {
        throw ArgumentError.value(
          entry.value,
          entry.key,
          '${entry.key} must be between 1 and 1000 grams.',
        );
      }
    }
  }

  @override
  bool operator ==(Object other) =>
      other is NutritionGoals &&
      other.calories == calories &&
      other.protein == protein &&
      other.carbs == carbs &&
      other.fat == fat;

  @override
  int get hashCode => Object.hash(calories, protein, carbs, fat);
}

class GoalsRepository {
  GoalsRepository(this._preferences);

  static const _caloriesKey = 'goal_calories';
  static const _proteinKey = 'goal_protein';
  static const _carbsKey = 'goal_carbs';
  static const _fatKey = 'goal_fat';

  final SharedPreferences _preferences;

  NutritionGoals load() {
    final goals = NutritionGoals(
      calories:
          _preferences.getInt(_caloriesKey) ?? NutritionGoals.defaults.calories,
      protein:
          _preferences.getInt(_proteinKey) ?? NutritionGoals.defaults.protein,
      carbs: _preferences.getInt(_carbsKey) ?? NutritionGoals.defaults.carbs,
      fat: _preferences.getInt(_fatKey) ?? NutritionGoals.defaults.fat,
    );
    goals.validate();
    return goals;
  }

  Future<void> save(NutritionGoals goals) async {
    goals.validate();
    await _preferences.setInt(_caloriesKey, goals.calories);
    await _preferences.setInt(_proteinKey, goals.protein);
    await _preferences.setInt(_carbsKey, goals.carbs);
    await _preferences.setInt(_fatKey, goals.fat);
  }
}

final goalsRepositoryProvider = FutureProvider<GoalsRepository>((ref) async {
  return GoalsRepository(await SharedPreferences.getInstance());
});

final nutritionGoalsProvider =
    AsyncNotifierProvider<NutritionGoalsController, NutritionGoals>(
  NutritionGoalsController.new,
);

class NutritionGoalsController extends AsyncNotifier<NutritionGoals> {
  @override
  Future<NutritionGoals> build() async {
    final repository = await ref.watch(goalsRepositoryProvider.future);
    return repository.load();
  }

  Future<void> save(NutritionGoals goals) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(goalsRepositoryProvider.future);
      await repository.save(goals);
      return goals;
    });
  }
}
