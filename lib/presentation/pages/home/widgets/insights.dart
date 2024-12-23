import 'dart:developer';

import 'package:expense_tracker/core/services/notification_service.dart';
import 'package:expense_tracker/domain/entities/expense.dart';
import 'package:expense_tracker/presentation/pages/reminder_screen.dart';
import 'package:expense_tracker/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

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
            _CategoryDistributionChart(),
            SizedBox(height: 24),
            _MonthlyTrendChart(),
            SizedBox(height: 24),
            _TopExpenses(),
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

class _CategoryDistributionChart extends StatelessWidget {
  const _CategoryDistributionChart();

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        final categoryData = provider.getCategoryDistribution();

        return SizedBox(
          height: 250,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Category Distribution',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  if (categoryData.isEmpty) ...{
                    Center(
                      child: Text(
                        'No data available',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  } else ...{
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: PieChart(
                              curve: Curves.easeInOut,
                              duration: const Duration(milliseconds: 500),
                              PieChartData(
                                sections: categoryData.map((item) {
                                  return PieChartSectionData(
                                    value: item.amount,
                                    title:
                                        '${(item.percentage * 100).toStringAsFixed(1)}%',
                                    color: item.color,
                                    radius: 40,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  );
                                }).toList(),
                                sectionsSpace: 2,
                                centerSpaceRadius: 30,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: categoryData.map((item) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: item.color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          item.category,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  }
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MonthlyTrendChart extends StatelessWidget {
  const _MonthlyTrendChart();

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        final monthlyData = provider.getMonthlyTrend();

        return SizedBox(
          height: 250,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Trend',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${provider.isCurrencyDollar?"\$":"\u{20AC}"}${value.toInt()}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1, // Ensure unique labels
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() < 0 ||
                                    value.toInt() >= monthlyData.length) {
                                  return const SizedBox(); // Avoid overflow
                                }
                                return Text(
                                  monthlyData[value.toInt()].month,
                                  style: Theme.of(context).textTheme.bodySmall,
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: monthlyData.asMap().entries.map((entry) {
                              return FlSpot(
                                entry.key.toDouble(), // Use index as x-value
                                entry.value.amount, // Use amount as y-value
                              );
                            }).toList(),
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TopExpenses extends StatelessWidget {
  const _TopExpenses();

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
                      '${provider.isCurrencyDollar?"\$":"\u{20AC}"}${expense.amount.toStringAsFixed(2)}',
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

// Helper class for category distribution data
class CategoryData {
  final String category;
  final double amount;
  final double percentage;
  final Color color;

  CategoryData({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

// Helper class for monthly trend data
class MonthlyData {
  final String month;
  final double amount;

  MonthlyData({
    required this.month,
    required this.amount,
  });
}

// Extension methods for ExpenseProvider to get insights data
extension ExpenseInsights on ExpenseProvider {
  List<CategoryData> getCategoryDistribution() {
    final Map<String, double> categoryTotals = {};
    double total = 0;

    // Calculate totals for each category
    for (var expense in expenses) {
      categoryTotals[expense.category.categoryName] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
      total += expense.amount;
    }

    // Create color map for categories
    final categoryColors = {
      'Food & Dining': Colors.blue,
      'Shopping': Colors.orange,
      'Entertainment': Colors.purple,
      'Bills & Utilities': Colors.red,
      'Others': Colors.grey,
      'Health & Medical': Colors.pink,
      'Travel': Colors.teal,
      'Education': Colors.indigo,
    };

    // Convert to list of CategoryData
    return categoryTotals.entries.map((entry) {
      return CategoryData(
        category: entry.key,
        amount: entry.value,
        percentage: entry.value / total,
        color: categoryColors[entry.key] ?? Colors.grey,
      );
    }).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  }

  List<MonthlyData> getMonthlyTrend() {
    final Map<String, double> monthlyTotals = {};
    final DateFormat monthFormat = DateFormat('MMM');

    // Get last 6 months
    final now = DateTime.now();
    for (var i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      monthlyTotals[monthFormat.format(date)] = 0;
    }

    // Calculate totals for each month
    for (var expense in expenses) {
      final month = monthFormat.format(expense.date);
      if (monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = (monthlyTotals[month] ?? 0) + expense.amount;
      }
    }

    // Convert to list of MonthlyData
    return monthlyTotals.entries.map((entry) {
      return MonthlyData(
        month: entry.key,
        amount: entry.value,
      );
    }).toList();
  }

  List<Expense> getTopExpenses(int limit) {
    return List.from(expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount))
      ..take(limit);
  }
}

// Helper function to get category icon
IconData getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'food':
      return Icons.restaurant_rounded;
    case 'transport':
      return Icons.directions_car_rounded;
    case 'shopping':
      return Icons.shopping_bag_rounded;
    case 'entertainment':
      return Icons.movie_rounded;
    case 'bills':
      return Icons.receipt_rounded;
    default:
      return Icons.attach_money_rounded;
  }
}
