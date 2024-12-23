import 'package:expense_tracker/domain/entities/expense.dart';
import 'package:expense_tracker/presentation/providers/expense_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Import the generated mock
import '../mock_expense_repository.mocks.dart';

void main() {
  late ExpenseProvider provider;
  late MockExpenseRepositoryImpl mockRepository; 
  late MockExpenseLocalDatasource mockLocalDatasource; 
  late MockBox<Expense> mockExpenseBox; 

  setUp(() {
    mockExpenseBox = MockBox<Expense>();
    mockLocalDatasource = MockExpenseLocalDatasource();

    mockRepository = MockExpenseRepositoryImpl();

    provider = ExpenseProvider(mockRepository);
  });

  test('should add expense and update state', () async {

    // Arrange
    final expense = Expense(
      id: '1',
      description: 'Lunch',
      amount: 15.0,
      category: CategoryModel(categoryName: 'Food', categoryIcon: 'assets/icons/food.svg'),
      date: DateTime.now(),
    );

    when(mockRepository.addExpense(expense)).thenAnswer((_) async {});
    when(mockLocalDatasource.addExpense(expense)).thenAnswer((_) async {});

    // Act
    await provider.addExpense(expense);

    // Assert
    verify(mockRepository.addExpense(expense)).called(1); 
  });

  
}
