import 'package:flutter/widgets.dart';
import 'package:math_mate/l10n/app_localizations.dart';

/// Extension for concise access to localized strings.
///
/// Usage: `context.l10n.settingsTitle`
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
