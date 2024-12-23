import 'package:expense_tracker/domain/entities/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:expense_tracker/main.dart';
import 'package:mockito/mockito.dart';

class MockBox extends Mock implements Box<Expense> {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final mockExpenseBox = MockBox();

    await tester.pumpWidget(MyApp(expenseBox: mockExpenseBox));

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
  });
}
