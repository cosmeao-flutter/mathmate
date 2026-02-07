import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/features/settings/data/locale_repository.dart';

part 'locale_state.dart';

/// Cubit for managing the user's language preference.
///
/// Loads the saved locale from [LocaleRepository] on creation and
/// persists changes automatically.
///
/// Usage:
/// ```dart
/// final repository = await LocaleRepository.create();
/// final cubit = LocaleCubit(repository: repository);
///
/// // Set Spanish
/// await cubit.setLocale('es');
///
/// // Set system default
/// await cubit.setLocale(null);
/// ```
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit({required this.repository})
      : super(LocaleState(languageCode: repository.loadLocale()));

  /// Repository for persisting locale preference.
  final LocaleRepository repository;

  /// Sets the language code and persists it.
  ///
  /// Pass `null` to revert to system default.
  Future<void> setLocale(String? languageCode) async {
    if (state.languageCode == languageCode) return;

    await repository.saveLocale(languageCode);
    emit(LocaleState(languageCode: languageCode));
  }
}
