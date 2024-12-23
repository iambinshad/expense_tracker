import 'package:expense_tracker/domain/entities/expense.dart';
import 'package:expense_tracker/presentation/pages/add_expense/add_expense_page.dart';
import 'package:expense_tracker/presentation/providers/expense_provider.dart';
import 'package:expense_tracker/presentation/providers/filter_sort_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final bool isDoller;

  const SummaryCard({super.key, 
    required this.title,
    required this.amount,
    required this.icon,
    required this.isDoller
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            '${!isDoller?"\u{20AC}":"\$"}${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ModernExpenseCard extends StatelessWidget {
  final Expense expense;
 final bool isDoller;

  const ModernExpenseCard({super.key, required this.expense,required this.isDoller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  expense.category.categoryIcon,
                )),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      "${expense.description}adfljasd",
                      style: textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isDoller?"\$":"\u{20AC}"}${expense.amount.toStringAsFixed(2)}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: expense.amount > 1000
                          ? colorScheme.error
                          : colorScheme.onSurface,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    '${expense.category.categoryName} • ${DateFormat.yMMMd().format(expense.date)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              borderRadius: BorderRadius.circular(25),
              onSelected: (value) {
                if (value == 'edit') {
                  _editExpense(context);
                } else if (value == 'delete') {
                  _deleteExpense(context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
              icon: const Icon(Icons.more_vert),
            )
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
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

  void _editExpense(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpensePage(expense: expense),
      ),
    );
  }

  void _deleteExpense(BuildContext context) {
    // Show confirmation dialog and delete if confirmed
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ExpenseProvider>().deleteExpense(expense.id);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100,),
          Icon(
            Icons.receipt_long_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 6),
          Text(
            'No expenses yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: const Color.fromARGB(255, 47, 47, 47)),
          ),
        ],
      ),
    );
  }
}

class ActiveFiltersChip extends StatelessWidget {
  final FilterSortProvider filterProvider;

  const ActiveFiltersChip({super.key, required this.filterProvider});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 8,
            children: [
              if (filterProvider.selectedCategory != null)
                Chip(
                  label: Text(filterProvider.selectedCategory!.categoryName),
                  onDeleted: () => filterProvider.clearCategoryFilter(),
                ),
              if (filterProvider.startDate != null)
                Chip(
                  label: Text(
                    '${DateFormat.yMMMd().format(filterProvider.startDate!)} - '
                    '${DateFormat.yMMMd().format(filterProvider.endDate ?? DateTime.now())}',
                  ),
                  onDeleted: () => filterProvider.clearDateFilter(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
