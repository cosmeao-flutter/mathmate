import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/reminder/presentation/cubit/reminder_cubit.dart';

/// Reminder settings screen with enable toggle and time picker.
///
/// Allows users to:
/// - Enable/disable daily homework reminder
/// - Set the reminder time via showTimePicker
class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reminder),
      ),
      body: BlocBuilder<ReminderCubit, ReminderState>(
        builder: (context, state) {
          return ListView(
            children: [
              SwitchListTile(
                title: Text(l10n.reminderEnabled),
                subtitle: Text(l10n.reminderEnabledDesc),
                value: state.isEnabled,
                onChanged: (value) {
                  context
                      .read<ReminderCubit>()
                      .setReminderEnabled(value: value);
                },
              ),
              ListTile(
                title: Text(l10n.reminderTime),
                subtitle: Text(state.timeOfDay.format(context)),
                trailing: const Icon(Icons.access_time),
                enabled: state.isEnabled,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: state.timeOfDay,
                  );
                  if (picked != null && context.mounted) {
                    unawaited(
                      context
                          .read<ReminderCubit>()
                          .setReminderTime(picked),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
