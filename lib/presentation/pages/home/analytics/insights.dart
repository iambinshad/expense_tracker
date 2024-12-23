import 'package:expense_tracker/presentation/pages/home/analytics/sub_widget/category_chart.dart';
import 'package:expense_tracker/presentation/pages/home/analytics/sub_widget/monthly_chart.dart';
import 'package:expense_tracker/presentation/pages/home/analytics/sub_widget/top_expenses.dart';
import 'package:flutter/material.dart';

class ExpenseInsightsWidget extends StatelessWidget {
  const ExpenseInsightsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _InsightsHeader(),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            SizedBox(height: 24),
            CategoryDistributionChart(),
            SizedBox(height: 24),
            MonthlyTrendChart(),
            SizedBox(height: 24),
            TopExpenses(),
          ],
        ),
      ),
    );
  }
}

class _InsightsHeader extends StatelessWidget {
  const _InsightsHeader();

  @override
  build(BuildContext context) {
    return Text(
      'Expense Insights',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}





