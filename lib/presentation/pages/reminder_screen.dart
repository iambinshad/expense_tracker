import 'package:expense_tracker/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyReminderScreen extends StatefulWidget {
  const DailyReminderScreen({super.key});

  @override
  _DailyReminderScreenState createState() => _DailyReminderScreenState();
}

class _DailyReminderScreenState extends State<DailyReminderScreen> {
  bool _isDailyReminderEnabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDailyReminderEnabled = prefs.getBool('dailyReminderEnabled') ?? false;
      final hour = prefs.getInt('dailyReminderHour') ?? 8;
      final minute = prefs.getInt('dailyReminderMinute') ?? 0;
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyReminderEnabled', _isDailyReminderEnabled);
    await prefs.setInt('dailyReminderHour', _selectedTime.hour);
    await prefs.setInt('dailyReminderMinute', _selectedTime.minute);
  }

  void _toggleDailyReminder(bool value) async {
    setState(() {
      _isDailyReminderEnabled = value;
    });
    if (_isDailyReminderEnabled) {
      // Schedule Notification
      await NotificationService().scheduleDailyReminder(
        id: 1,
        title: 'Daily Reminder',
        body: 'Don\'t forget to log your expenses!',
        time: _selectedTime,
      );
    } else {
      // Cancel Notification
      await NotificationService().cancelNotification(1);
    }
    _savePreferences();
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
      if (_isDailyReminderEnabled) {
        // Reschedule Notification
        await NotificationService().scheduleDailyReminder(
          id: 1,
          title: 'Daily Reminder',
          body: 'Don\'t forget to log your expenses!',
          time: _selectedTime,
        );
      }
      _savePreferences();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Reminder Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.access_time_outlined),
              title: const Text('Daily Reminder'),
              subtitle: const Text('Get reminded to log expenses'),
              value: _isDailyReminderEnabled,
              onChanged: _toggleDailyReminder,
            ),
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Reminder Time'),
              subtitle: Text('${_selectedTime.format(context)}'),
              onTap: _pickTime,
            ),
          ],
        ),
      ),
    );
  }
}
