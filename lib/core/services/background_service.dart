// import 'dart:io';

// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:expense_tracker/core/services/notification_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';

// class BackgroundService {
//   static const String notificationTask = 'expenseReminderTask';
  
//   static Future<void> initialize() async {
//     if (Platform.isAndroid) {
//       await AndroidAlarmManager.initialize();
//     }
    
//     await Workmanager().initialize(
//       callbackDispatcher,
//       isInDebugMode: true
//     );
//   }

//   static Future<void> schedulePeriodicTask() async {
//     if (Platform.isAndroid) {
//       // Schedule Android background task
//       await Workmanager().registerPeriodicTask(
//         'expenseReminder',
//         notificationTask,
//         frequency: const Duration(hours: 24),
//         constraints: Constraints(
//           networkType: NetworkType.not_required,
//           requiresBatteryNotLow: true,
//         ),
//       );
//     } else if (Platform.isIOS) {
//       // For iOS, register background fetch
//       // Note: iOS has limitations on background execution frequency
//       await Workmanager().registerPeriodicTask(
//         'expenseReminder',
//         notificationTask,
//         frequency: const Duration(hours: 24),
//       );
//     }
//   }
// }

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     switch (task) {
//       case BackgroundService.notificationTask:
//         final notificationService = NotificationService();
//         await notificationService.init();
        
//         // Check if reminders are enabled
//         final prefs = await SharedPreferences.getInstance();
//         final enabled = prefs.getBool('reminders_enabled') ?? false;
        
//         if (enabled) {
//           final hour = prefs.getInt('reminder_hour') ?? 20;
//           final minute = prefs.getInt('reminder_minute') ?? 0;
          
//           await notificationService.scheduleDailyReminder(
//             reminderTime: TimeOfDay(hour: hour, minute: minute),
//             enableReminder: true,
//           );
//         }
//         break;
//     }
//     return Future.value(true);
//   });
// }