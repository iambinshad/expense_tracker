import 'package:expense_tracker/core/constants/expense_categories.dart';
import 'package:expense_tracker/domain/entities/expense.dart';
import 'package:expense_tracker/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddExpenseSheet extends StatefulWidget {
  final Expense? expense;

  const AddExpenseSheet({super.key, this.expense});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  CategoryModel _selectedCategory = CategoryModel(
    categoryName: ExpenseCategories.categories[7].categoryName,
    categoryIcon: ExpenseCategories.categories[7].categoryIcon,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _descriptionController = TextEditingController(
        text: widget.expense?.description ?? '',
      );
      _amountController = TextEditingController(
        text: widget.expense?.amount.toString() ?? '',
      );
      _selectedCategory = widget.expense?.category ??
          CategoryModel(
            categoryName: ExpenseCategories.categories[7].categoryName,
            categoryIcon: ExpenseCategories.categories[7].categoryIcon,
          );
      _selectedDate = widget.expense?.date ?? DateTime.now();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(
          widget.expense == null ? 'Add Expense' : 'Edit Expense',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.6,
                child: TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: const Icon(Icons.attach_money_rounded),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ExpenseCategories.categories.map((category) {
                  return ChoiceChip(
                    avatar: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        category.categoryIcon,
                        height: 24,
                        width: 24,
                      ),
                    ),
                    selected:
                        _selectedCategory.categoryName == category.categoryName,
                    label: Text(category.categoryName),
                    labelStyle: TextStyle(
                      color: _selectedCategory.categoryName ==
                              category.categoryName
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_rounded),
                title: Text(
                  'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: _saveExpense,
          style: ElevatedButton.styleFrom(
            elevation: 5,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            widget.expense == null ? 'Add Expense' : 'Save Changes',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _saveExpense() {
    if (_formKey.currentState?.validate() ?? false) {
      final expense = Expense(
        id: widget.expense?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
      );

      if (widget.expense == null) {
        context.read<ExpenseProvider>().addExpense(expense);
      } else {
        context.read<ExpenseProvider>().updateExpense(expense);
      }

      Navigator.pop(context);
    }
  }
}
