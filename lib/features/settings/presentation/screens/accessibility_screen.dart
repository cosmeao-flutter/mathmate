import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/constants/app_strings.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.accessibility),
      ),
      body: BlocBuilder<AccessibilityCubit, AccessibilityState>(
        builder: (context, state) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text(AppStrings.reduceMotion),
                subtitle: const Text(AppStrings.reduceMotionDesc),
                value: state.reduceMotion,
                onChanged: (value) {
                  context
                      .read<AccessibilityCubit>()
                      .setReduceMotion(value: value);
                },
              ),
              SwitchListTile(
                title: const Text(AppStrings.hapticFeedback),
                subtitle: const Text(AppStrings.hapticFeedbackDesc),
                value: state.hapticFeedback,
                onChanged: (value) {
                  context
                      .read<AccessibilityCubit>()
                      .setHapticFeedback(value: value);
                },
              ),
              SwitchListTile(
                title: const Text(AppStrings.soundFeedback),
                subtitle: const Text(AppStrings.soundFeedbackDesc),
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
