import 'package:expense_tracker/presentation/providers/reminder_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyReminderScreen extends StatelessWidget {
  const DailyReminderScreen({Key? key}) : super(key: key);

  Future<void> _pickTime(BuildContext context, DailyReminderProvider provider) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: provider.selectedTime,
    );
    if (pickedTime != null) {
      await provider.updateReminderTime(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DailyReminderProvider>(context);

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
              value: provider.isDailyReminderEnabled,
              onChanged: (value) => provider.toggleDailyReminder(value),
            ),
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Reminder Time'),
              subtitle: Text(provider.selectedTime.format(context)),
              onTap: () => _pickTime(context, provider),
            ),
          ],
        ),
      ),
    );
  }
}
