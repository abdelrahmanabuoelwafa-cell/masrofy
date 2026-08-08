import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit([String? initialLanguage])
      : super(_initialState(initialLanguage));

  static LocaleState _initialState(String? initialLanguage) {
    final userBox = Hive.box('user_box');
    final languageCode = initialLanguage ??
        userBox.get('language', defaultValue: 'ar') as String;
    final isArabic = languageCode == 'ar';
    return LocaleState(
      languageCode: languageCode,
      isArabic: isArabic,
      locale: Locale(languageCode),
    );
  }

  Future<void> switchLanguage() async {
    final newLanguageCode = state.languageCode == 'ar' ? 'en' : 'ar';
    await setLanguage(newLanguageCode);
  }

  Future<void> setLanguage(String code) async {
    final userBox = Hive.box('user_box');
    await userBox.put('language', code);

    final isArabic = code == 'ar';
    emit(LocaleState(
      languageCode: code,
      isArabic: isArabic,
      locale: Locale(code),
    ));
  }
}
