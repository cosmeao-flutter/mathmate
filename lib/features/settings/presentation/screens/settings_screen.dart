import 'package:flutter/material.dart';
import 'package:math_mate/core/constants/app_strings.dart';
import 'package:math_mate/features/settings/presentation/screens/accessibility_screen.dart';
import 'package:math_mate/features/settings/presentation/screens/appearance_screen.dart';

/// Main settings screen with navigation menu.
///
/// Provides navigation to:
/// - Appearance settings (theme mode, accent color)
/// - Accessibility settings (reduce motion, haptic feedback, sound feedback)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text(AppStrings.appearance),
            subtitle: const Text(AppStrings.appearanceSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppearanceScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.accessibility_new_outlined),
            title: const Text(AppStrings.accessibility),
            subtitle: const Text(AppStrings.accessibilitySubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccessibilityScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
