import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/storage/storage_service.dart';

/// Global locale state; persists selected language (e.g. en, ar).
class LocaleState extends GetxController {
  static final LocaleState _instance = LocaleState._internal();
  factory LocaleState() => _instance;
  LocaleState._internal();

  final StorageService _storage = StorageService();

  final _locale = Rx<Locale?>(null);

  /// Current locale; null means use device locale.
  Locale? get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    _restoreLocale();
  }

  void _restoreLocale() {
    if (!_storage.isInitialized) return;
    final code = _storage.getLocale();
    if (code != null && code.isNotEmpty) {
      _locale.value = Locale(code);
    }
  }

  /// Set locale and persist. Use language code e.g. 'en', 'ar'.
  Future<void> setLocale(String languageCode) async {
    final newLocale = Locale(languageCode);
    if (_locale.value?.languageCode == newLocale.languageCode) return;
    _locale.value = newLocale;
    if (_storage.isInitialized) {
      await _storage.saveLocale(languageCode);
    }
  }

  /// Clear saved locale (use system default).
  Future<void> clearLocale() async {
    _locale.value = null;
    if (_storage.isInitialized) {
      await _storage.prefs.remove(StorageKeys.locale);
    }
  }
}
