import 'package:flutter/material.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/profile/presentation/screens/profile_screen.dart';
import 'package:math_mate/features/reminder/presentation/screens/reminder_screen.dart';
import 'package:math_mate/features/settings/presentation/screens/accessibility_screen.dart';
import 'package:math_mate/features/settings/presentation/screens/appearance_screen.dart';
import 'package:math_mate/features/settings/presentation/screens/language_screen.dart';

/// Main settings screen with navigation menu.
///
/// Provides navigation to:
/// - Appearance settings (theme mode, accent color)
/// - Accessibility settings (reduce motion, haptic feedback, sound feedback)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: Text(l10n.profile),
            subtitle: Text(l10n.profileSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.appearance),
            subtitle: Text(l10n.appearanceSubtitle),
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
            title: Text(l10n.accessibility),
            subtitle: Text(l10n.accessibilitySubtitle),
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
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(l10n.languageSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.reminder),
            subtitle: Text(l10n.reminderSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReminderScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
