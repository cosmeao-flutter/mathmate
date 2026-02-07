part of 'reminder_cubit.dart';

/// State representing the current homework reminder preferences.
///
/// Contains:
/// - [isEnabled]: Whether the daily reminder is active (default: false)
/// - [hour]: The reminder hour in 24h format (default: 16 = 4:00 PM)
/// - [minute]: The reminder minute (default: 0)
class ReminderState extends Equatable {
  const ReminderState({
    this.isEnabled = false,
    this.hour = 16,
    this.minute = 0,
  });

  /// Whether the daily reminder is enabled.
  final bool isEnabled;

  /// The reminder hour (0-23).
  final int hour;

  /// The reminder minute (0-59).
  final int minute;

  /// Convenience getter for UI time picker.
  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  /// Creates a copy with optionally updated values.
  ReminderState copyWith({
    bool? isEnabled,
    int? hour,
    int? minute,
  }) {
    return ReminderState(
      isEnabled: isEnabled ?? this.isEnabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  @override
  List<Object> get props => [isEnabled, hour, minute];
}
