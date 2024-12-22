// lib/domain/repositories/expense_repository.dart
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getAllExpenses();
  Future<Expense?> getExpenseById(String id);
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end);
}