import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/features/reminder/data/notification_service.dart';
import 'package:math_mate/features/reminder/data/reminder_repository.dart';

part 'reminder_state.dart';

/// Cubit for managing homework reminder preferences.
///
/// Orchestrates both [ReminderRepository] (persistence) and
/// [NotificationService] (scheduling) to handle reminder state.
///
/// When enabling, requests notification permission first. If denied,
/// the reminder stays disabled (graceful degradation).
class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit({
    required this.repository,
    required this.notificationService,
  }) : super(
          ReminderState(
            isEnabled: repository.loadReminderEnabled(),
            hour: repository.loadReminderHour(),
            minute: repository.loadReminderMinute(),
          ),
        );

  /// Repository for persisting reminder preferences.
  final ReminderRepository repository;

  /// Service for scheduling OS notifications.
  final NotificationService notificationService;

  /// Enables or disables the daily reminder.
  ///
  /// When enabling, requests notification permission first.
  /// If permission is denied, the reminder stays disabled.
  /// When disabling, cancels any scheduled notification.
  Future<void> setReminderEnabled({required bool value}) async {
    if (state.isEnabled == value) return;

    if (value) {
      final granted = await notificationService.requestPermission();
      if (!granted) return;

      await repository.saveReminderEnabled(value: true);
      emit(state.copyWith(isEnabled: true));
      await notificationService.scheduleDailyReminder(
        hour: state.hour,
        minute: state.minute,
      );
    } else {
      await repository.saveReminderEnabled(value: false);
      emit(state.copyWith(isEnabled: false));
      await notificationService.cancelReminder();
    }
  }

  /// Sets the reminder time and reschedules if enabled.
  Future<void> setReminderTime(TimeOfDay time) async {
    if (state.hour == time.hour && state.minute == time.minute) return;

    await repository.saveReminderHour(value: time.hour);
    await repository.saveReminderMinute(value: time.minute);
    emit(state.copyWith(hour: time.hour, minute: time.minute));

    if (state.isEnabled) {
      await notificationService.scheduleDailyReminder(
        hour: state.hour,
        minute: state.minute,
      );
    }
  }
}
