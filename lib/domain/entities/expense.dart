import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final CategoryModel category;

  Expense({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
  });

  factory Expense.create({
    required double amount,
    required String description,
    required CategoryModel category,
    DateTime? date,
  }) {
    return Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      description: description,
      date: date ?? DateTime.now(),
      category: category,
    );
  }

  Expense copyWith({
    String? id,
    double? amount,
    String? description,
    DateTime? date,
    CategoryModel? category,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}


@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
 
  @HiveField(0)
  final String categoryName;
   @HiveField(1)
  final String categoryIcon;


  CategoryModel({
    required this.categoryName,
    required this.categoryIcon,
  });

  factory CategoryModel.create({
    required String categoryName,
    required String categoryIcon,

  }) {
    return CategoryModel(
      categoryName: categoryName,
      categoryIcon: categoryIcon,

    );
  }

  CategoryModel copyWith({
    String? categoryName,
    String? categoryIcon,

  }) {
    return CategoryModel(
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryName: categoryName ?? this.categoryName,
   
    );
  }

   // Override equality operators for proper comparison in Flutter
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.categoryName == categoryName &&
        other.categoryIcon == categoryIcon;
  }

  @override
  int get hashCode => categoryName.hashCode ^ categoryIcon.hashCode;
}