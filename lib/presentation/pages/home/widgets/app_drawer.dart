import 'package:expense_tracker/presentation/pages/reminder_screen.dart';
import 'package:flutter/material.dart';

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
             Navigator.push(context, MaterialPageRoute(builder: (context) => DailyReminderScreen(),));
                  },
                ),
                // Daily Reminder
                

                // Dark Mode
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Toggle dark theme'),
                  value: _isDarkModeEnabled,
                  onChanged: (bool value) {
                    // setState(() {
                    //   _isDarkModeEnabled = value;
                    // });
                  },
                ),

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
                    // Navigate to account settings
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.currency_exchange),
                  title: const Text('Currency Settings'),
                  onTap: () {
                    // Navigate to currency settings
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  onTap: () {
                    // Navigate to help section
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  onTap: () {
                    // Navigate to about section
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
                          onPressed: () async {
                           
                          },
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
