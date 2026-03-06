import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage keys constants
class StorageKeys {
  StorageKeys._();

  static const String userData = 'user_data';
  static const String authToken = 'auth_token';
  static const String isLoggedIn = 'is_logged_in';
  static const String loginApiResponse = 'login_api_response';
  static const String themeMode = 'theme_mode'; // 'light' | 'dark' | 'system'
}

/// Storage Service
/// Wrapper around SharedPreferences for type-safe storage operations
class StorageService {
  StorageService._();

  static final StorageService _instance = StorageService._();
  factory StorageService() => _instance;

  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
        'StorageService not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  /// Check if storage is initialized
  bool get isInitialized => _prefs != null;

  // ============================================================================
  // User Data
  // ============================================================================

  /// Save user data as JSON
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      return await prefs.setString(
        StorageKeys.userData,
        jsonEncode(userData),
      );
    } catch (e) {
      return false;
    }
  }

  /// Get user data from storage
  Map<String, dynamic>? getUserData() {
    try {
      print('📖 StorageService.getUserData() called');
      final userDataString = prefs.getString(StorageKeys.userData);
      print('   - Raw string from SharedPreferences: ${userDataString != null ? "${userDataString.substring(0, userDataString.length > 200 ? 200 : userDataString.length)}..." : "null"}');
      if (userDataString == null) {
        print('   - No user data string found in SharedPreferences');
        return null;
      }
      final decoded = jsonDecode(userDataString) as Map<String, dynamic>;
      print('   - Decoded JSON keys: ${decoded.keys.toList()}');
      print('   - Decoded JSON: $decoded');
      return decoded;
    } catch (e) {
      print('   - ❌ Error decoding user data: $e');
      return null;
    }
  }

  /// Remove user data
  Future<bool> removeUserData() async {
    return await prefs.remove(StorageKeys.userData);
  }

  // ============================================================================
  // Authentication Token
  // ============================================================================

  /// Save authentication token
  Future<bool> saveToken(String token) async {
    return await prefs.setString(StorageKeys.authToken, token);
  }

  /// Get authentication token
  String? getToken() {
    print('📖 StorageService.getToken() called');
    final token = prefs.getString(StorageKeys.authToken);
    print('   - Token: ${token != null ? "${token.substring(0, token.length > 30 ? 30 : token.length)}..." : "null"}');
    return token;
  }

  /// Remove authentication token
  Future<bool> removeToken() async {
    return await prefs.remove(StorageKeys.authToken);
  }

  // ============================================================================
  // Login Status
  // ============================================================================

  /// Save login status
  Future<bool> saveLoginStatus(bool isLoggedIn) async {
    return await prefs.setBool(StorageKeys.isLoggedIn, isLoggedIn);
  }

  /// Get login status
  bool getLoginStatus() {
    print('📖 StorageService.getLoginStatus() called');
    final status = prefs.getBool(StorageKeys.isLoggedIn) ?? false;
    print('   - Login Status: $status');
    return status;
  }

  /// Remove login status
  Future<bool> removeLoginStatus() async {
    return await prefs.remove(StorageKeys.isLoggedIn);
  }

  // ============================================================================
  // Login API Response
  // ============================================================================

  /// Save full login API response
  Future<bool> saveLoginApiResponse(Map<String, dynamic> response) async {
    try {
      return await prefs.setString(
        StorageKeys.loginApiResponse,
        jsonEncode(response),
      );
    } catch (e) {
      return false;
    }
  }

  /// Get full login API response
  Map<String, dynamic>? getLoginApiResponse() {
    try {
      print('📖 StorageService.getLoginApiResponse() called');
      final responseString = prefs.getString(StorageKeys.loginApiResponse);
      print('   - Raw string from SharedPreferences: ${responseString != null ? "${responseString.substring(0, responseString.length > 200 ? 200 : responseString.length)}..." : "null"}');
      if (responseString == null) {
        print('   - No login API response found in SharedPreferences');
        return null;
      }
      final decoded = jsonDecode(responseString) as Map<String, dynamic>;
      print('   - Decoded JSON keys: ${decoded.keys.toList()}');
      print('   - Decoded JSON: $decoded');
      return decoded;
    } catch (e) {
      print('   - ❌ Error decoding login API response: $e');
      return null;
    }
  }

  /// Remove login API response
  Future<bool> removeLoginApiResponse() async {
    return await prefs.remove(StorageKeys.loginApiResponse);
  }

  // ============================================================================
  // Theme Mode
  // ============================================================================

  /// Save theme mode: 'light', 'dark', or 'system'
  Future<bool> saveThemeMode(String mode) async {
    return await prefs.setString(StorageKeys.themeMode, mode);
  }

  /// Get theme mode, default 'system'
  String getThemeMode() {
    return prefs.getString(StorageKeys.themeMode) ?? 'system';
  }

  // ============================================================================
  // Clear All Data
  // ============================================================================

  /// Clear all stored data (logout)
  Future<bool> clearAll() async {
    try {
      await removeUserData();
      await removeToken();
      await removeLoginStatus();
      await removeLoginApiResponse();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ============================================================================
  // Generic Methods
  // ============================================================================

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  /// Get string value
  String? getString(String key) {
    return prefs.getString(key);
  }

  /// Save boolean value
  Future<bool> saveBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  /// Get boolean value
  bool getBool(String key, {bool defaultValue = false}) {
    return prefs.getBool(key) ?? defaultValue;
  }

  /// Save integer value
  Future<bool> saveInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  /// Get integer value
  int? getInt(String key) {
    return prefs.getInt(key);
  }

  /// Remove a key
  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  /// Check if a key exists
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  /// Get all keys
  Set<String> getKeys() {
    return prefs.getKeys();
  }

  /// Clear all preferences
  Future<bool> clear() async {
    return await prefs.clear();
  }
}
