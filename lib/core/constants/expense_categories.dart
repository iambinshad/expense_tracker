import 'package:expense_tracker/domain/entities/expense.dart';

class ExpenseCategories {
  static  List<CategoryModel> categories = [
    CategoryModel(categoryName: 'Food & Dining', categoryIcon: 'assets/Icons/cutlery.png'),
    CategoryModel(categoryName: 'Shopping', categoryIcon: 'assets/Icons/online-shopping.png'),
    CategoryModel(categoryName: 'Entertainment', categoryIcon: 'assets/Icons/cinema.png'),
    CategoryModel(categoryName: 'Bills & Utilities', categoryIcon: 'assets/Icons/bill.png'),
    CategoryModel(categoryName: 'Health & Medical', categoryIcon: 'assets/Icons/health-insurance.png'),
    CategoryModel(categoryName: 'Travel', categoryIcon: 'assets/Icons/travel-luggage.png'),
    CategoryModel(categoryName: 'Education', categoryIcon: 'assets/Icons/education.png'),
    CategoryModel(categoryName: 'Others', categoryIcon: 'assets/Icons/application.png'),
  ];
 
}