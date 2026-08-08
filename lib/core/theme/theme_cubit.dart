import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(_initialState());

  static ThemeState _initialState() {
    final settingsBox = Hive.box('app_settings');
    final isDark = settingsBox.get('isDarkMode', defaultValue: false) as bool;
    return ThemeState(isDarkMode: isDark);
  }

  Future<void> toggleTheme() async {
    final newIsDark = !state.isDarkMode;
    await setTheme(newIsDark);
  }

  Future<void> setTheme(bool isDark) async {
    final settingsBox = Hive.box('app_settings');
    await settingsBox.put('isDarkMode', isDark);
    emit(ThemeState(isDarkMode: isDark));
  }
}
