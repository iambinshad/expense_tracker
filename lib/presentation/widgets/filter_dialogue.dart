// lib/presentation/widgets/filter_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/expense_categories.dart';
import '../providers/filter_sort_provider.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Remove fixed height to allow dynamic resizing
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust height based on content
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true, // Let ListView shrink to fit content
              padding: const EdgeInsets.all(16),
              children: const [
                _FilterHeader(),
                SizedBox(height: 24),
                _CategoryFilter(),
                SizedBox(height: 24),
                _DateRangeFilter(),
                SizedBox(height: 24),
                _SortOptionFilter(),
                                SizedBox(height: 24),

              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _FilterHeader extends StatelessWidget {
  const _FilterHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filters & Sort',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Consumer<FilterSortProvider>(
          builder: (context, provider, child) {
            if (!provider.hasActiveFilters) return const SizedBox.shrink();

            return TextButton.icon(
              onPressed: provider.clearFilters,
              icon: const Icon(Icons.clear_all_rounded),
              label: const Text('Clear All'),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter();

  @override
  Widget build(BuildContext context) {
    // final categories = [
    //   'Food',
    //   'Transport',
    //   'Shopping',
    //   'Entertainment',
    //   'Bills',
    //   'Others'
    // ];

    return Consumer<FilterSortProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ExpenseCategories.categories .map((category) {
                final isSelected = provider.selectedCategory?.categoryName == category.categoryName;
                return FilterChip(
                  avatar: SizedBox(
                        // decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 2),shape:BoxShape.circle),
                        height: 50,
                        width: 50,
                        child: Image.asset(
                          category.categoryIcon,
                        )) ,
                  selected: isSelected,
                  label: Text(category.categoryName),
                  onSelected: (selected) {
                    provider.setCategory(selected ? category : null);
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _DateRangeFilter extends StatelessWidget {
  const _DateRangeFilter();

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterSortProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date Range',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                provider.startDate != null
                    ? '${DateFormat.yMMMd().format(provider.startDate!)} - '
                        '${provider.endDate != null ? DateFormat.yMMMd().format(provider.endDate!) : 'Now'}'
                    : 'Select date range',
              ),
              trailing: const Icon(Icons.calendar_month_rounded),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              ),
              onTap: () async {
                final DateTimeRange? dateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange:
                      provider.startDate != null && provider.endDate != null
                          ? DateTimeRange(
                              start: provider.startDate!,
                              end: provider.endDate!)
                          : null,
                );

                if (dateRange != null) {
                  provider.setDateRange(dateRange.start, dateRange.end);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _SortOptionFilter extends StatelessWidget {
  const _SortOptionFilter();

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterSortProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SegmentedButton<SortOption>(
              selected: {provider.sortOption},
              onSelectionChanged: (Set<SortOption> selection) {
                if (selection.isNotEmpty) {
                  provider.setSortOption(selection.first);
                }
              },
              segments: const [
                ButtonSegment(
                  value: SortOption.dateNewest,
                  label: Text('Newest'),
                  icon: Icon(Icons.arrow_upward_rounded),
                ),
                ButtonSegment(
                  value: SortOption.dateOldest,
                  label: Text('Oldest'),
                  icon: Icon(Icons.arrow_downward_rounded),
                ),
                ButtonSegment(
                  value: SortOption.amountHighest,
                  label: Text('Highest'),
                  icon: Icon(Icons.attach_money_rounded),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
