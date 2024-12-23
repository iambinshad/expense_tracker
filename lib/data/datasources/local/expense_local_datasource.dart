// lib/data/datasources/local/expense_local_datasource.dart
import 'dart:developer';

import 'package:hive/hive.dart';
import '../../../domain/entities/expense.dart';
import '../../../core/errors/exceptions.dart';

class ExpenseLocalDatasource {
  final Box<Expense> expenseBox;

  ExpenseLocalDatasource(this.expenseBox);

  Future<void> addExpense(Expense expense) async {
    try {
      await expenseBox.put(expense.id, expense);
    } catch (e) {
      log(e.toString());
      throw CacheException('Failed to add expense');
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await expenseBox.put(expense.id, expense);
    } catch (e) {
      throw CacheException('Failed to update expense');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await expenseBox.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete expense');
    }
  }

  Future<Expense?> getExpenseById(String id) async {
    try {
      return expenseBox.get(id);
    } catch (e) {
      throw CacheException('Failed to get expense');
    }
  }

  Future<List<Expense>> getAllExpenses() async {
    try {
      log(expenseBox.values.toList().toString());
      return expenseBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get expenses');
    }
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    try {
      return expenseBox.values
          .where((expense) =>
              expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
              expense.date.isBefore(end.add(const Duration(days: 1))))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get expenses by date range');
    }
  }

  Future<void>resetData() async {
    try {
      await expenseBox.clear();
    } catch (e) {
      throw CacheException('Failed to reset database');
    }
  }
}