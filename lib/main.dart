// lib/main.dart
import 'package:expense_tracker/core/services/notification_service.dart';
import 'package:expense_tracker/presentation/pages/add_expense/add_expense_screen.dart';
import 'package:expense_tracker/presentation/pages/bottom_nav/bottom_nav.dart';
import 'package:expense_tracker/presentation/providers/bottom_nav_provider.dart';
import 'package:expense_tracker/presentation/providers/filter_sort_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'domain/entities/expense.dart';
import 'data/datasources/local/expense_local_datasource.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'presentation/providers/expense_provider.dart';
import 'core/constants/app_themes.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(CategoryModelAdapter()); 
// Open the expense box
  final expenseBox = await Hive.openBox<Expense>('expenses');
  
  tz.initializeTimeZones();
  final notificationService = NotificationService();
  await notificationService.init();
  
  runApp(MyApp(expenseBox: expenseBox));
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final Box<Expense> expenseBox;

  const MyApp({Key? key, required this.expenseBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ExpenseProvider(
            ExpenseRepositoryImpl(
              ExpenseLocalDatasource(expenseBox),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FilterSortProvider(),
        ),
      ],
      child: MaterialApp(
          onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/add-expense':
            return MaterialPageRoute(
              builder: (context) => const AddExpenseSheet(),
            );
        }
        return null;
      },
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: AppThemes.light,
        home:  BottomNav(),
      ),
    );
  }
}
