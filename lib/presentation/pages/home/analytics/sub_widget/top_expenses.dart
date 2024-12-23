import 'package:expense_tracker/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TopExpenses extends StatelessWidget {
  const TopExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        final topExpenses = provider.getTopExpenses(5);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Expenses',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ...topExpenses.map((expense) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            shape: BoxShape.circle),
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          expense.category.categoryIcon,
                        )),
                    title: Text(expense.description),
                    subtitle: Text(DateFormat.yMMMd().format(expense.date)),
                    trailing: Text(
                      '${provider.isCurrencyDollar ? "\$" : "\u{20AC}"}${expense.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}