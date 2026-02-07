import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';

/// Accessibility settings screen with toggle switches.
///
/// Allows users to configure:
/// - Reduce motion (disable animations)
/// - Haptic feedback (vibration on button press)
/// - Sound feedback (click sound on button press)
class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accessibility),
      ),
      body: BlocBuilder<AccessibilityCubit, AccessibilityState>(
        builder: (context, state) {
          return ListView(
            children: [
              SwitchListTile(
                title: Text(l10n.reduceMotion),
                subtitle: Text(l10n.reduceMotionDesc),
                value: state.reduceMotion,
                onChanged: (value) {
                  context
                      .read<AccessibilityCubit>()
                      .setReduceMotion(value: value);
                },
              ),
              SwitchListTile(
                title: Text(l10n.hapticFeedback),
                subtitle: Text(l10n.hapticFeedbackDesc),
                value: state.hapticFeedback,
                onChanged: (value) {
                  context
                      .read<AccessibilityCubit>()
                      .setHapticFeedback(value: value);
                },
              ),
              SwitchListTile(
                title: Text(l10n.soundFeedback),
                subtitle: Text(l10n.soundFeedbackDesc),
                value: state.soundFeedback,
                onChanged: (value) {
                  context
                      .read<AccessibilityCubit>()
                      .setSoundFeedback(value: value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
