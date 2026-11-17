import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kain_track/data/db/database.dart';
import 'package:kain_track/features/foods/foods_screen.dart';

void main() {
  testWidgets('adding a food refreshes the list', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: FoodsScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Test food');
    for (var index = 1; index < 5; index++) {
      await tester.enterText(find.byType(TextField).at(index), '10');
    }
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Test food'), findsOneWidget);
  });
}
