import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:kain_track/data/db/database.dart';
import 'package:kain_track/features/home/home_screen.dart';

void main() {
  testWidgets('home screen shows empty calorie state', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0 kcal'), findsOneWidget);
    expect(find.text('No meals logged yet'), findsOneWidget);
    expect(find.text('Log meal'), findsOneWidget);
  });

  testWidgets('submits the log meal form and refreshes the total', (
    tester,
  ) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log meal'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Banana');
    await tester.enterText(find.byType(TextField).at(1), '89');
    await tester.enterText(find.byType(TextField).at(2), '120');
    await tester.tap(find.text('Save meal'));
    await tester.pumpAndSettle();

    expect(find.text('106.80 kcal'), findsOneWidget);
  });
}
