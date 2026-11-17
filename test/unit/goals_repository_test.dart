import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kain_track/data/repositories/goals_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loads default goals on first run', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      await container.read(nutritionGoalsProvider.future),
      NutritionGoals.defaults,
    );
  });

  test('saved goals persist across provider reloads', () async {
    final first = ProviderContainer();
    addTearDown(first.dispose);
    const goals = NutritionGoals(
      calories: 2200,
      protein: 160,
      carbs: 240,
      fat: 70,
    );

    await first.read(nutritionGoalsProvider.future);
    await first.read(nutritionGoalsProvider.notifier).save(goals);
    expect(await first.read(nutritionGoalsProvider.future), goals);

    final second = ProviderContainer();
    addTearDown(second.dispose);
    expect(await second.read(nutritionGoalsProvider.future), goals);
  });

  test('rejects calories and macros outside supported bounds', () {
    expect(
      () => const NutritionGoals(
        calories: 799,
        protein: 135,
        carbs: 180,
        fat: 60,
      ).validate(),
      throwsArgumentError,
    );
    expect(
      () => const NutritionGoals(
        calories: 1800,
        protein: 1001,
        carbs: 180,
        fat: 60,
      ).validate(),
      throwsArgumentError,
    );
  });
}
