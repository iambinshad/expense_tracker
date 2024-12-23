import 'package:expense_tracker/presentation/pages/reminder_screen.dart';
import 'package:expense_tracker/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isDailyReminderEnabled = false;
  bool _isDarkModeEnabled = false;
  bool _isNotificationsEnabled = false;
  bool _isBiometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          // Profile Section
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              image: const DecorationImage(
                image: AssetImage('assets/Icons/unnamed.png'),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            currentAccountPicture: CircleAvatar(
                backgroundColor: theme.colorScheme.surface,
                child:
                    const Image(image: AssetImage("assets/Icons/unnamed.png"))),
            accountName: const Text(
              "John Doe",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: const Text(
              "johndoe@example.com",
              style: TextStyle(fontSize: 14),
            ),
          ),

          // Settings Section
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.more_time_sharp),
                  title: const Text('Daily Reminder'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DailyReminderScreen(),
                        ));
                  },
                ),
                // Daily Reminder

                const Divider(),

                // Additional Settings
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    "More Options",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.restart_alt_rounded),
                  title: const Text('Reset Datas'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Reset'),
                          content: const Text(
                              'Are you sure you want to reset all data? This action cannot be undone.'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              onPressed: () async {
                                await context
                                    .read<ExpenseProvider>()
                                    .clearDatabase();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.currency_exchange),
                  title: const Text('Currency Settings'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Choose Currency'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: const Text('USD'),
                                onTap: () {
                                  context
                                      .read<ExpenseProvider>()
                                      .changeCurrency();
                                  Navigator.of(context).pop(); // Close dialog
                                },
                              ),
                              ListTile(
                                title: const Text('EUR'),
                                onTap: () {
                                  context
                                      .read<ExpenseProvider>()
                                      .changeCurrency();
                                  Navigator.of(context).pop(); // Close dialog
                                },
                              ),
                              // Add more currency options here as needed
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  onTap: () async {
                    // Fetch app version

                    // Show version in a dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('About the App'),
                          content: Text('App Version: 1.0.0'),
                          actions: [
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Logout Section
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: theme.colorScheme.error,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: theme.colorScheme.error,
                ),
              ),
              onTap: () async {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          onPressed: () async {},
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
