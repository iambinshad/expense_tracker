// lib/data/repositories/expense_repository_impl.dart
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/local/expense_local_datasource.dart';
import '../../core/errors/failures.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDatasource localDatasource;

  ExpenseRepositoryImpl(this.localDatasource);

  @override
  Future<List<Expense>> getAllExpenses() async {
    try {
      return await localDatasource.getAllExpenses();
    } catch (e) {
      throw Failure('Failed to get expenses');
    }
  }

  @override
  Future<Expense?> getExpenseById(String id) async {
    try {
      return await localDatasource.getExpenseById(id);
    } catch (e) {
      throw Failure('Failed to get expense');
    }
  }

  @override
  Future<void> addExpense(Expense expense) async {
    try {
      await localDatasource.addExpense(expense);
    } catch (e) {
      throw Failure('Failed to add expense');
    }
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    try {
      await localDatasource.updateExpense(expense);
    } catch (e) {
      throw Failure('Failed to update expense');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await localDatasource.deleteExpense(id);
    } catch (e) {
      throw Failure('Failed to delete expense');
    }
  }

  @override
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    try {
      return await localDatasource.getExpensesByDateRange(start, end);
    } catch (e) {
      throw Failure('Failed to get expenses by date range');
    }
  }
  
  @override
  Future<void> resetDataBase() async{
    try {
      await localDatasource.resetData();
    } catch (e) {
      throw Failure('Failed to reset database');
    }
  }
}