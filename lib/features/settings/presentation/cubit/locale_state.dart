part of 'locale_cubit.dart';

/// State representing the user's language preference.
///
/// A null [languageCode] means "follow system default".
class LocaleState extends Equatable {
  const LocaleState({this.languageCode});

  /// The selected language code (e.g., 'en', 'es'), or null for system default.
  final String? languageCode;

  /// Returns a [Locale] if a language code is set, or null for system default.
  Locale? get locale =>
      languageCode != null ? Locale(languageCode!) : null;

  /// Creates a copy with optionally updated values.
  LocaleState copyWith({String? languageCode}) {
    return LocaleState(languageCode: languageCode ?? this.languageCode);
  }

  @override
  List<Object?> get props => [languageCode];
}
