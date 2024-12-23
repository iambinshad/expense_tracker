import 'package:expense_tracker/presentation/pages/add_expense/add_expense_screen.dart';
import 'package:expense_tracker/presentation/pages/home/home_page.dart';
import 'package:expense_tracker/presentation/pages/home/analytics/insights.dart';
import 'package:expense_tracker/presentation/providers/bottom_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatelessWidget {
  BottomNav({super.key});

  List<Widget> screens = [
    const HomePage(),
    const ExpenseInsightsWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomNavProvider(),
      child: Consumer<BottomNavProvider>(
        builder: (context, value, child) => Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButton: !value.isBottomNavHide
              ? FloatingActionButton(
                  onPressed: () => _showAddExpenseSheet(context),
                  child: const Icon(Icons.add_rounded),
                )
              : const SizedBox(),
          bottomNavigationBar: !value.isBottomNavHide
              ? BottomNavigationBar(
                  onTap: (valuee) => value.changeScreen(valuee),
                  type: BottomNavigationBarType.fixed,
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  currentIndex: value.currentIndex,
                  items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.analytics_outlined),
                          label: "Analytics")
                    ])
              : const SizedBox(),
          body: screens[value.currentIndex],
        ),
      ),
    );
  }

  void _showAddExpenseSheet(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddExpenseSheet(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
