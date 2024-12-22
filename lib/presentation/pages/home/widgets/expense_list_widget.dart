import 'package:expense_tracker/core/constants/app_strings.dart';
import 'package:expense_tracker/domain/entities/expense.dart';
import 'package:expense_tracker/presentation/pages/add_expense/add_expense_page.dart';
import 'package:expense_tracker/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseListWidget extends StatelessWidget {
  const ExpenseListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        final expenses = provider.expenses;
        
        if (expenses.isEmpty) {
          return const Center(
            child: Text(AppStrings.noExpenses),
          );
        }

        return ListView.builder(
          itemCount: expenses.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return ExpenseCard(expense: expense);
          },
        );
      },
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(expense.description),
        subtitle: Text(expense.category.categoryName),
        trailing: Text(
          '\$${expense.amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpensePage(expense: expense),
            ),
          );
        },
      ),
    );
  }
}