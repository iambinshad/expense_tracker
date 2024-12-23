import 'package:animate_do/animate_do.dart';
import 'package:expense_tracker/core/errors/error_state_widget.dart';
import 'package:expense_tracker/presentation/pages/home/widgets/app_drawer.dart';
import 'package:expense_tracker/presentation/providers/bottom_nav_provider.dart';
import 'package:expense_tracker/presentation/providers/filter_sort_provider.dart';
import 'package:expense_tracker/presentation/widgets/filter_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import 'widgets/expense_summary_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
  
    return Scaffold(
        onDrawerChanged: (isOpened) {
          Provider.of<BottomNavProvider>(context, listen: false)
              .changeBottomNavState();
        },
        drawer: const AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Column(
            children: [
              Text(
                'Total Expense',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              Consumer<ExpenseProvider>(
                builder: (context, provider, child) => Text(
                  '${provider.isCurrencyDollar ? "\$" : "\u{20AC}"}${provider.totalExpenses.toStringAsFixed(2)}',
                  style: textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 150),
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, child) => Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SummaryCard(
                      isDoller: provider.isCurrencyDollar,
                      title: 'This Month',
                      amount: provider.currentMonthExpenses.fold<double>(
                        0,
                        (sum, expense) => sum + expense.amount,
                      ),
                      icon: Icons.calendar_today_rounded,
                    ),
                    SizedBox(
                        height: 100,
                        child: Hero(
                            tag: "logo",
                          child: Image.asset("assets/Icons/unnamed.png"))),
                    SummaryCard(
                      isDoller: provider.isCurrencyDollar,
                      title: 'This Week',
                      amount: provider.currentWeekExpenses.fold<double>(
                        0,
                        (sum, expense) => sum + expense.amount,
                      ),
                      icon: Icons.date_range_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Consumer2<ExpenseProvider, FilterSortProvider>(
            builder: (context, expenseProvider, filterProvider, child) {
          if (expenseProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (expenseProvider.error != null) {
            return ErrorStateWidget(error: expenseProvider.error!);
          }

          final filteredExpenses = filterProvider.applyFiltersAndSort(
            expenseProvider.expenses,
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 8, top: 8, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Expense List",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    IconButton(
                      icon: Badge(
                          isLabelVisible: filterProvider.hasActiveFilters,
                          label:
                              Text(findCountOfTurnedOnFilters(filterProvider)),
                          child: const Icon(Icons.filter_list_rounded)),
                      onPressed: () => _showFilterDialog(context),
                    ),
                    
                  ],
                ),
              ),
              if (filteredExpenses.isEmpty) ...{
                const EmptyStateWidget()
              } else ...{
                Expanded(
                    child: ListView.builder(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
                    return FadeInDown(
                      delay: const Duration(milliseconds: 100),
                      from: 5,
                      child: ModernExpenseCard(
                        expense: expense,
                        isDoller: expenseProvider.isCurrencyDollar,
                      ),
                    );
                  },
                ))
              }
            ],
          );
        }));
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true, 
      enableDrag: true,
      context: context,
      builder: (context) {
        return const FilterSheet();
      },
    );
  }

  String findCountOfTurnedOnFilters(FilterSortProvider filterProvider) {
    if (filterProvider.selectedCategory != null &&
        filterProvider.startDate != null) {
      return "2";
    } else {
      return "1";
    }
  }
}
