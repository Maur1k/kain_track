import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kain_track/data/db/database.dart';
import 'package:kain_track/data/repositories/meal_repository.dart';
import 'package:kain_track/features/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('home shows the empty state and log meal action', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          selectedDateNutritionProvider.overrideWith(
            (ref) => Stream.value(const Nutrition.zero()),
          ),
          selectedDateEntriesProvider.overrideWith(
            (ref) => Stream.value({}),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('0 kcal'), findsOneWidget);
    expect(find.text('No meals logged yet'), findsOneWidget);
    expect(find.text('Log meal'), findsOneWidget);
    expect(find.text('Deficit Target: 1800 kcal'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('date pill advances from Today to Tomorrow', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await _pumpHome(tester, database);

    expect(find.text('Today'), findsWidgets);
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pump();
    expect(find.text('Tomorrow'), findsOneWidget);
  });

  testWidgets('active day shows an over-goal badge', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final food = (await database.select(database.foods).get()).first;
    await database.into(database.mealEntries).insert(
          MealEntriesCompanion.insert(
            foodId: food.id,
            grams: 100,
            mealSlot: 'breakfast',
            loggedAt: DateTime.now(),
          ),
        );
    final entries = await MealRepository(database).getEntriesForDate(
      DateTime.now(),
    );
    await _pumpHome(
      tester,
      database,
      entries: entries,
      totals: const Nutrition(
        calories: 2000,
        protein: 150,
        carbs: 200,
        fat: 70,
      ),
    );

    expect(find.text('200 kcal over'), findsOneWidget);
    expect(find.text('Logged Foods'), findsOneWidget);
  });

  testWidgets('reset deletes only meals on the selected date', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final food = (await database.select(database.foods).get()).first;
    final today = DateTime.now();
    await database.batch((batch) {
      batch.insertAll(database.mealEntries, [
        MealEntriesCompanion.insert(
          foodId: food.id,
          grams: 100,
          mealSlot: 'breakfast',
          loggedAt: today,
        ),
        MealEntriesCompanion.insert(
          foodId: food.id,
          grams: 100,
          mealSlot: 'lunch',
          loggedAt: today.add(const Duration(days: 1)),
        ),
      ]);
      batch.insert(
        database.workoutSessions,
        WorkoutSessionsCompanion.insert(
          name: 'Run',
          performedAt: today,
        ),
      );
    });
    await _pumpHome(tester, database);

    await tester.tap(find.text('KAIN TRACK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Reset Today's Log"));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    final remaining = await database.select(database.mealEntries).get();
    expect(remaining, hasLength(1));
    expect(remaining.single.mealSlot, 'lunch');
    final workouts = await database.select(database.workoutSessions).get();
    expect(workouts, hasLength(1));
    expect(workouts.single.name, 'Run');
    expect(find.text("Today's log reset."), findsOneWidget);
  });
}

Future<void> _pumpHome(
  WidgetTester tester,
  AppDatabase database, {
  Map<String, List<MealEntryWithFood>> entries = const {},
  Nutrition totals = const Nutrition.zero(),
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        selectedDateNutritionProvider.overrideWith(
          (ref) => Stream.value(totals),
        ),
        selectedDateEntriesProvider.overrideWith(
          (ref) => Stream.value(entries),
        ),
      ],
      child: const MaterialApp(home: HomeScreen()),
    ),
  );
  await tester.pumpAndSettle();
}
