// lib/presentation/providers/expense_provider.dart
import 'dart:developer';

import 'package:expense_tracker/core/constants/expense_categories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseProvider with ChangeNotifier {

CategoryModel selectedCategoryE = CategoryModel(
    categoryName: ExpenseCategories.categories[7].categoryName,
    categoryIcon: ExpenseCategories.categories[7].categoryIcon,
  );
  late DateTime selectedDateE;

setDateE(value){
    selectedDateE = value;
    notifyListeners();
  }
   setCategoryE(value){
    selectedCategoryE = value;
    notifyListeners();
  }



  //////////////

bool isCurrencyDollar = true;

changeCurrency(){isCurrencyDollar=!isCurrencyDollar;notifyListeners();}

  final ExpenseRepository _repository;
  ExpenseProvider(this._repository) {
    loadExpenses();
  }
  setDate(value){
    selectedDateTwo = value;
    notifyListeners();
  }
   setCategory(value){
    selectedCategory = value;
    notifyListeners();
  }
  
     DateTime selectedDateTwo = DateTime.now();
  CategoryModel selectedCategory = CategoryModel(
    categoryName: ExpenseCategories.categories[7].categoryName,
    categoryIcon: ExpenseCategories.categories[7].categoryIcon,
  );

  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();

  
  // Getters
  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;

  // Load all expenses
  Future<void> loadExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await _repository.getAllExpenses();
      _expenses.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      log(e.toString());
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new expense
  Future<void> addExpense(Expense expense) async {
    try {
      await _repository.addExpense(expense);
      await loadExpenses();
    } catch (e) {
            log(e.toString());

      _error = e.toString();
      notifyListeners();
    }
  }

  // Update expense
  Future<void> updateExpense(Expense expense) async {
    try {
      await _repository.updateExpense(expense);
      await loadExpenses();
    } catch (e) {
            log(e.toString());

      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    try {
      await _repository.deleteExpense(id);
      await loadExpenses();
    } catch (e) {
            log(e.toString());

      _error = e.toString();
      notifyListeners();
    }
  }

   Future<void> clearDatabase() async {
    try {
      await _repository.resetDataBase();
      await loadExpenses();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  

  // Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Get total expenses
  double get totalExpenses {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get expenses by category
Map<String, double> get expensesByCategory {
  final map = <String, double>{};
  for (var expense in _expenses) {
    final categoryName = expense.category.categoryName;
    map[categoryName] = (map[categoryName] ?? 0) + expense.amount;
  }
  return map;
}

  // Get expenses for current month
  List<Expense> get currentMonthExpenses {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return _expenses.where((expense) => 
      expense.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
      expense.date.isBefore(endOfMonth.add(const Duration(days: 1)))
    ).toList();
  }

   List<Expense> get currentWeekExpenses {
    final now = DateTime.now();
    // Find the most recent Monday (or today if it is Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final endDate = startDate.add(const Duration(days: 7));
    
    return _expenses.where((expense) => 
      expense.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
      expense.date.isBefore(endDate)
    ).toList();
  }

  // Add these helper methods for the insights widget
 List<CategoryData> getCategoryDistribution() {
  final total = totalExpenses; // Ensure totalExpenses sums up all expenses correctly

  final categoryAmounts = expensesByCategory; // Map of category totals

  // Define colors for categories
  final categoryColors = {
    'Food & Dining': Colors.blue,
    'Travel': Colors.green,
    'Shopping': Colors.orange,
    'Entertainment': Colors.purple,
    'Bills & Utilities': Colors.red,
    'Others': Colors.grey,
    'Health & Medical': Colors.pink,
    'Education': Colors.teal,
  };

  // Convert to CategoryData and ensure data is sorted
  return categoryAmounts.entries.map((entry) {
    return CategoryData(
      category: entry.key,
      amount: entry.value,
      percentage: total > 0 ? entry.value / total : 0,
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
    final date = DateTime(now.year, now.month - i, 1);
    monthlyTotals[monthFormat.format(date)] = 0;
  }

  // Filter expenses within the last 6 months
  final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);
  final filteredExpenses = _expenses.where((expense) => expense.date.isAfter(sixMonthsAgo)).toList();

  // Calculate totals for each month
  for (var expense in filteredExpenses) {
    final month = monthFormat.format(expense.date);
    if (monthlyTotals.containsKey(month)) {
      monthlyTotals[month] = (monthlyTotals[month] ?? 0) + expense.amount;
    }
  }

  return monthlyTotals.entries.map((entry) {
    return MonthlyData(
      month: entry.key,
      amount: entry.value,
    );
  }).toList();
}


  List<Expense> getTopExpenses(int limit) {
    return List.from(_expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount))
      ..take(limit)
      .toList();
  }
}

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

class MonthlyData {
  final String month;
  final double amount;

  MonthlyData({
    required this.month,
    required this.amount,
  });
}