import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/storage/storage_service.dart';

/// Global theme mode state: light, dark, or system
class ThemeState extends GetxController {
  static final ThemeState _instance = ThemeState._internal();
  factory ThemeState() => _instance;
  ThemeState._internal();

  final StorageService _storage = StorageService();

  final _themeMode = Rx<ThemeMode>(ThemeMode.system);

  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _restoreThemeMode();
  }

  void _restoreThemeMode() {
    if (!_storage.isInitialized) return;
    final stored = _storage.getThemeMode();
    _themeMode.value = _themeModeFromString(stored);
  }

  static ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Set theme and persist
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode.value == mode) return;
    _themeMode.value = mode;
    if (_storage.isInitialized) {
      await _storage.saveThemeMode(_themeModeToString(mode));
    }
  }

  /// Set to light theme
  Future<void> setLight() => setThemeMode(ThemeMode.light);

  /// Set to dark theme
  Future<void> setDark() => setThemeMode(ThemeMode.dark);

  /// Set to follow system
  Future<void> setSystem() => setThemeMode(ThemeMode.system);
}
