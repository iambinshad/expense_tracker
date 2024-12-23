import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/core/services/notification_service.dart';

class DailyReminderProvider with ChangeNotifier {
  bool _isDailyReminderEnabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

  bool get isDailyReminderEnabled => _isDailyReminderEnabled;
  TimeOfDay get selectedTime => _selectedTime;

  DailyReminderProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDailyReminderEnabled = prefs.getBool('dailyReminderEnabled') ?? false;
    final hour = prefs.getInt('dailyReminderHour') ?? 8;
    final minute = prefs.getInt('dailyReminderMinute') ?? 0;
    _selectedTime = TimeOfDay(hour: hour, minute: minute);
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyReminderEnabled', _isDailyReminderEnabled);
    await prefs.setInt('dailyReminderHour', _selectedTime.hour);
    await prefs.setInt('dailyReminderMinute', _selectedTime.minute);
  }

  Future<void> toggleDailyReminder(bool value) async {
    _isDailyReminderEnabled = value;
    notifyListeners();

    if (_isDailyReminderEnabled) {
      await NotificationService().scheduleDailyReminder(
        id: 1,
        title: 'Daily Reminder',
        body: 'Don\'t forget to record your expenses for today!',
        time: _selectedTime,
      );
    } else {
      await NotificationService().cancelNotification(1);
    }
    await _savePreferences();
  }

  Future<void> updateReminderTime(TimeOfDay newTime) async {
    _selectedTime = newTime;
    notifyListeners();

    if (_isDailyReminderEnabled) {
      await NotificationService().scheduleDailyReminder(
        id: 1,
        title: 'Daily Reminder',
        body: 'Don\'t forget to record your expenses for today!',
        time: _selectedTime,
      );
    }
    await _savePreferences();
  }
}
