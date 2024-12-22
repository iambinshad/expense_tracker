import 'package:expense_tracker/core/constants/expense_categories.dart';
import 'package:expense_tracker/domain/entities/expense.dart';
import 'package:expense_tracker/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseFormWidget extends StatefulWidget {
  final Expense? expense;
  const ExpenseFormWidget({Key? key, this.expense}) : super(key: key);

  @override
  State<ExpenseFormWidget> createState() => _ExpenseFormWidgetState();
}

class _ExpenseFormWidgetState extends State<ExpenseFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  CategoryModel _selectedCategory = CategoryModel(
    categoryName: ExpenseCategories.categories[7].categoryName,
    categoryIcon: ExpenseCategories.categories[7].categoryIcon,
  );
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.expense?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.expense?.description ?? '',
    );
    _selectedCategory = widget.expense?.category ?? CategoryModel(
      categoryName: ExpenseCategories.categories[7].categoryName,
      categoryIcon: ExpenseCategories.categories[7].categoryIcon,
    );
    _selectedDate = widget.expense?.date ?? DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
     
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Amount Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        prefixText: '\$',
                        prefixStyle: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      ),
                      keyboardType: TextInputType.number,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Description and Category Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<CategoryModel>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      ),
                      items: ExpenseCategories.categories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image.asset(category.categoryIcon, 
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(category.categoryName),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Date Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            DateFormat('MMMM dd, yyyy').format(_selectedDate),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
           
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: _saveChanges,
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

  _saveChanges(){
     if (_formKey.currentState!.validate()) {
                          final expense = Expense(
                            id: widget.expense?.id ??
                                DateTime.now().millisecondsSinceEpoch.toString(),
                            amount: double.parse(_amountController.text),
                            description: _descriptionController.text,
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