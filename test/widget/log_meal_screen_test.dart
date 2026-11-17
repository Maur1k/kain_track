import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kain_track/data/db/database.dart';
import 'package:kain_track/features/meals/log_meal_screen.dart';

void main() {
  testWidgets('logs grams from the searchable categorized food sheet',
      (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: LogMealScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('High Protein'), findsOneWidget);
    expect(find.text('+ Custom Food'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('food-search')),
      'Boiled egg',
    );
    await tester.pump();
    await tester.tap(find.text('Boiled egg (whole)'));
    await tester.enterText(find.byKey(const Key('meal-grams')), '100');
    await tester.pump();
    expect(find.textContaining('Preview:'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final entries = await database.select(database.mealEntries).get();
    expect(entries, hasLength(1));
    expect(entries.single.grams, 100);
  });
}
