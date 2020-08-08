import 'package:app/data/model/theme_setting.dart';
import 'package:app/data/provier/theme_repository_provider.dart';
import 'package:app/data/repository/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appThemeNotifierProvider =
    ChangeNotifierProvider<AppTheme>((ref) => AppTheme(ref: ref));

ThemeData get lightTheme {
  return ThemeData.light().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

ThemeData get darkTheme {
  return ThemeData.dark().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class AppTheme extends ChangeNotifier {
  AppTheme({@required ProviderReference ref}) : _ref = ref;

  final ProviderReference _ref;

  ThemeRepository _repository;

  ThemeSetting setting;

  Future<ThemeData> get themeData async {
    if (setting == null) {
      _repository ??= await _ref.read(themeRepositoryProvider.future);
      setting = _repository.loadThemeSetting() ?? ThemeSetting.DARK;
    }
    return setting == ThemeSetting.LIGHT ? lightTheme : darkTheme;
  }

  Future<void> _loadLightTheme() async {
    _repository ??= await _ref.read(themeRepositoryProvider.future);
    setting = ThemeSetting.LIGHT;
    await _repository.saveThemeSetting(setting);
    notifyListeners();
  }

  Future<void> _loadDarkTheme() async {
    _repository ??= await _ref.read(themeRepositoryProvider.future);
    setting = ThemeSetting.DARK;
    await _repository.saveThemeSetting(setting);
    notifyListeners();
  }

  Future<void> toggle() async {
    setting == ThemeSetting.LIGHT
        ? await _loadDarkTheme()
        : await _loadLightTheme();
  }
}
