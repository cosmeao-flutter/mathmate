import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/settings/presentation/cubit/locale_cubit.dart';

/// Language settings screen for selecting app display language.
///
/// Allows users to choose between:
/// - System default (follows device language)
/// - English (US)
/// - Español (MX)
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
      ),
      body: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return RadioGroup<String?>(
            groupValue: state.languageCode,
            onChanged: (value) {
              context.read<LocaleCubit>().setLocale(value);
            },
            child: ListView(
              children: [
                RadioListTile<String?>(
                  title: Text(l10n.languageSystem),
                  subtitle: Text(l10n.languageSystemDesc),
                  value: null,
                ),
                RadioListTile<String?>(
                  title: Text(l10n.languageEnglish),
                  value: 'en',
                ),
                RadioListTile<String?>(
                  title: Text(l10n.languageSpanish),
                  value: 'es',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
