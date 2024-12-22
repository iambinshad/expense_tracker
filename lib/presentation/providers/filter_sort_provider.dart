// lib/presentation/providers/filter_sort_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/expense.dart';

enum SortOption {
  dateNewest,
  dateOldest,
  amountHighest,
  amountLowest,
}

class FilterSortProvider with ChangeNotifier {
  CategoryModel? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  SortOption _sortOption = SortOption.dateNewest;

  CategoryModel? get selectedCategory => _selectedCategory;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  SortOption get sortOption => _sortOption;
  
  // Add this getter to check if any filters are active
  bool get hasActiveFilters => 
      _selectedCategory != null || _startDate != null || _endDate != null;

  void setCategory(CategoryModel? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  // Add these new methods
  void clearCategoryFilter() {
    _selectedCategory = null;
    notifyListeners();
  }

  void clearDateFilter() {
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  List<Expense> applyFiltersAndSort(List<Expense> expenses) {
    List<Expense> filteredExpenses = List.from(expenses);

    // Apply category filter
    if (_selectedCategory != null) {
      filteredExpenses = filteredExpenses
          .where((expense) => expense.category.categoryName == _selectedCategory?.categoryName)
          .toList();
    }

    // Apply date range filter
    if (_startDate != null && _endDate != null) {
      filteredExpenses = filteredExpenses.where((expense) =>
        expense.date.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
        expense.date.isBefore(_endDate!.add(const Duration(days: 1)))
      ).toList();
    }

    // Apply sorting
    switch (_sortOption) {
      case SortOption.dateNewest:
        filteredExpenses.sort((a, b) => b.date.compareTo(a.date));
      case SortOption.dateOldest:
        filteredExpenses.sort((a, b) => a.date.compareTo(b.date));
      case SortOption.amountHighest:
        filteredExpenses.sort((a, b) => b.amount.compareTo(a.amount));
      case SortOption.amountLowest:
        filteredExpenses.sort((a, b) => a.amount.compareTo(b.amount));
    }

    return filteredExpenses;
  }

  void clearFilters() {
    _selectedCategory = null;
    _startDate = null;
    _endDate = null;
    _sortOption = SortOption.dateNewest;
    notifyListeners();
  }
}