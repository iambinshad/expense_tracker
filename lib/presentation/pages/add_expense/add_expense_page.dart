import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/expense.dart';
import 'widgets/expense_form_widget.dart';

class AddExpensePage extends StatelessWidget {
  final Expense? expense;

  const AddExpensePage({Key? key, this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(expense == null ? AppStrings.addExpense : AppStrings.editExpense),
      ),
      body: ExpenseFormWidget(expense: expense),
    );
  }
}