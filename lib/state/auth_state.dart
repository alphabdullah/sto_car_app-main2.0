import 'dart:typed_data';

import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../services/auth_service.dart';
import '../core/storage/storage_service.dart';
import '../core/api/api_client.dart';
import '../core/api/api_client.dart' as api;

/// Global authentication state controller
/// Manages user authentication, role, and verification status
class AuthState extends GetxController {
  static final AuthState _instance = AuthState._internal();
  factory AuthState() => _instance;
  AuthState._internal();

  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final ApiClient _apiClient = ApiClient();

  // Observable state
  final _currentUser = Rxn<UserModel>();
  final _wallet = Rxn<WalletModel>();
  final _isLoading = false.obs;

  // Getters
  UserModel? get currentUser => _currentUser.value;
  WalletModel? get wallet => _wallet.value;
  bool get isAuthenticated => _currentUser.value != null;
  bool get isVerified => _currentUser.value?.isVerified ?? false;
  bool get isLoading => _isLoading.value;
  UserRole get currentRole => _currentUser.value?.role ?? UserRole.guest;

  @override
  void onInit() {
    super.onInit();
    // Synchronously restore user state from storage if available
    // This ensures state is available immediately when widgets are built
    _restoreStateFromStorage();
  }

  /// Synchronously restore user state from SharedPreferences
  /// This is called during initialization to ensure state is available immediately
  void _restoreStateFromStorage() {
    try {
      print('========================================');
      print('🔍 RESTORING STATE FROM SHARED PREFERENCES');
      print('========================================');

      if (!_storageService.isInitialized) {
        print('❌ Storage not initialized yet, will be restored in autoLogin');
        return;
      }
      print('✅ Storage is initialized');

      // Check if user is logged in
      final loginStatus = _storageService.getLoginStatus();
      print('📋 Login Status: $loginStatus');
      if (!loginStatus) {
        print('❌ User is not logged in');
        return;
      }

      // Get stored token
      final token = _storageService.getToken();
      print(
        '🔑 Token: ${token != null ? "${token.substring(0, 20)}..." : "null"}',
      );
      if (token == null || token.isEmpty) {
        print('❌ No token found');
        return;
      }

      // Get stored user data
      var userData = _storageService.getUserData();
      print('📦 User Data from getUserData():');
      if (userData != null) {
        print('   - Keys: ${userData.keys.toList()}');
        print('   - ID: ${userData['id']}');
        print('   - Email: ${userData['email']}');
        print('   - Name: ${userData['name']}');
        print('   - Role: ${userData['role']}');
        print('   - Is Verified: ${userData['is_verified']}');
        print('   - Phone: ${userData['phone']}');
        print('   - Profile Image: ${userData['profile_image']}');
        print('   - Address: ${userData['address']}');
        print('   - City: ${userData['city']}');
        print('   - Country: ${userData['country']}');
        print('   - Created At: ${userData['created_at']}');
        print('   - Wallet: ${userData['wallet']}');
        print('   - Full JSON: $userData');
      } else {
        print('   - null');
      }

      // If stored user data is empty or invalid, try to get it from saved API response
      if (userData == null ||
          (userData['id']?.toString().isEmpty ?? true) ||
          (userData['email']?.toString().isEmpty ?? true)) {
        print(
          '⚠️ Stored user data is empty or invalid, trying to restore from API response',
        );
        final apiResponse = _storageService.getLoginApiResponse();
        print('📦 Login API Response:');
        if (apiResponse != null) {
          print('   - Keys: ${apiResponse.keys.toList()}');
          print('   - Success: ${apiResponse['success']}');
          print('   - Message: ${apiResponse['message']}');
          if (apiResponse['data'] != null) {
            final data = apiResponse['data'] as Map<String, dynamic>;
            print('   - Data Keys: ${data.keys.toList()}');
            if (data['user'] != null) {
              userData = data['user'] as Map<String, dynamic>;
              print('   ✅ Restored user data from API response');
              print('   - User Data Keys: ${userData.keys.toList()}');
              print('   - User ID: ${userData['id']}');
              print('   - User Email: ${userData['email']}');
              print('   - User Name: ${userData['name']}');
              print('   - Full User Data: $userData');
            } else {
              print('   - No user data in API response');
            }
          } else {
            print('   - No data in API response');
          }
        } else {
          print('   - null');
        }
      }

      if (userData == null) {
        print('❌ No user data found in storage');
        return;
      }

      // Restore user from stored data immediately (synchronously)
      try {
        print('🔄 Parsing user data to UserModel...');
        final user = UserModel.fromJson(userData).copyWith(token: token);
        print('✅ UserModel created successfully:');
        print('   - ID: ${user.id}');
        print('   - Name: ${user.name}');
        print('   - Email: ${user.email}');
        print('   - Role: ${user.role}');
        print('   - Is Verified: ${user.isVerified}');
        print('   - Phone: ${user.phone}');
        print('   - Profile Image: ${user.profileImage}');
        print('   - Address: ${user.address}');
        print('   - City: ${user.city}');
        print('   - Country: ${user.country}');
        print('   - Created At: ${user.createdAt}');
        print('   - Wallet: ${user.wallet}');
        print(
          '   - Token: ${user.token != null ? "${user.token!.substring(0, 20)}..." : "null"}',
        );

        _currentUser.value = user;
        _apiClient.setToken(token);
        _initializeWallet(user.id, user.isVerified);
        print('✅ User state restored from storage and set in AuthState');
        print('✅ Token set in ApiClient');
        print('✅ Wallet initialized');
        // Note: Rxn automatically notifies observers when value changes
        // But we call update() to ensure all listeners are notified
        update();
        print('✅ Observers notified via update()');
        print('========================================');
      } catch (parseError) {
        print('❌ Error parsing stored user data: $parseError');
        print('   - UserData that failed: $userData');
        // Don't clear data here - let autoLogin handle it
        print('========================================');
      }
    } catch (e) {
      print('❌ Error restoring state from storage: $e');
      print('========================================');
      // Don't throw - just log the error
    }
  }

  /// Register a new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    Uint8List? registrationImageFront,
    Uint8List? registrationImageBack,
  }) async {
    _isLoading.value = true;
    update();

    try {
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        registrationImage1: registrationImageFront,
        registrationImage2: registrationImageBack,
      );

      final userData = response['user'] as Map<String, dynamic>;
      final token = response['token'] as String;

      // Create user model
      final user = UserModel.fromJson(userData).copyWith(token: token);

      // Save to storage
      await _saveUserData(user, token);

      // Set current user
      _currentUser.value = user;
      _apiClient.setToken(token);

      // Initialize wallet (will be fetched from API later if needed)
      _initializeWallet(user.id, user.isVerified);

      _isLoading.value = false;
      update();
    } on api.ApiException {
      _isLoading.value = false;
      update();
      rethrow;
    } catch (e) {
      _isLoading.value = false;
      update();
      throw api.ApiException('Registration failed: ${e.toString()}');
    }
  }

  /// Login user
  Future<void> login({required String email, required String password}) async {
    // Clear any leftover data from previous sessions before logging in.
    await _storageService.clearAll();
    _currentUser.value = null;
    _apiClient.setToken(null);

    _isLoading.value = true;
    update();

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      final userData = response['user'] as Map<String, dynamic>;
      final token = response['token'] as String;

      // Get full API response (if available)
      final fullResponse =
          response['fullResponse'] as Map<String, dynamic>? ?? response;

      // Debug: Log the user data from API
      print('Login: User data from API response: $userData');
      print('Login: User data type: ${userData.runtimeType}');
      print('Login: User data keys: ${userData.keys}');

      // Create user model
      final user = UserModel.fromJson(userData).copyWith(token: token);

      // Debug: Log the created user model
      print(
        'Login: Created user model - Name: "${user.name}", Email: "${user.email}", ID: "${user.id}", Role: ${user.role}',
      );

      // Debug: Log what will be saved
      final userJson = user.toJson();
      print('Login: User JSON to save: $userJson');

      // Save to storage
      await _saveUserData(user, token);

      // Save full API response
      await _storageService.saveLoginApiResponse(fullResponse);

      // Set current user
      _currentUser.value = user;
      _apiClient.setToken(token);

      // Initialize wallet (will be fetched from API later if needed)
      _initializeWallet(user.id, user.isVerified);

      _isLoading.value = false;
      update();
    } on api.ApiException {
      _isLoading.value = false;
      update();
      rethrow;
    } catch (e) {
      _isLoading.value = false;
      update();
      throw api.ApiException('Login failed: ${e.toString()}');
    }
  }

  /// Admin login
  Future<void> adminLogin({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    update();

    try {
      final response = await _authService.adminLogin(
        email: email,
        password: password,
      );

      final userData = response['user'] as Map<String, dynamic>;
      final token = response['token'] as String;

      // Get full API response (if available)
      final fullResponse =
          response['fullResponse'] as Map<String, dynamic>? ?? response;

      // Debug: Log the user data from API
      print('AdminLogin: User data from API response: $userData');
      print('AdminLogin: User data type: ${userData.runtimeType}');
      print('AdminLogin: User data keys: ${userData.keys}');
      print('AdminLogin: Role from API (raw): ${userData['role']}');
      print(
        'AdminLogin: Role from API (type): ${userData['role'].runtimeType}',
      );

      // Create user model
      final user = UserModel.fromJson(userData).copyWith(token: token);

      // Debug: Log the created user model
      print(
        'AdminLogin: Created user model - Name: "${user.name}", Email: "${user.email}", ID: "${user.id}", Role: ${user.role}',
      );

      // Use role from API response (no forcing - trust the API)
      // The role is already parsed from the API response in UserModel.fromJson
      final finalUser = user;

      // Debug: Log what will be saved
      final userJson = finalUser.toJson();
      print('AdminLogin: User JSON to save: $userJson');
      print('AdminLogin: Final user role for navigation: ${finalUser.role}');

      // Save to storage
      await _saveUserData(finalUser, token);

      // Save full API response
      await _storageService.saveLoginApiResponse(fullResponse);

      // Set current user
      _currentUser.value = finalUser;
      _apiClient.setToken(token);

      // Initialize wallet (will be fetched from API later if needed)
      _initializeWallet(finalUser.id, finalUser.isVerified);

      _isLoading.value = false;
      update();
    } on api.ApiException {
      _isLoading.value = false;
      update();
      rethrow;
    } catch (e) {
      _isLoading.value = false;
      update();
      throw api.ApiException('Admin login failed: ${e.toString()}');
    }
  }

  /// Auto-login from stored credentials
  /// This method validates the stored session and optionally refreshes user data from API
  /// State is already restored synchronously in onInit(), so this mainly validates/updates
  Future<bool> autoLogin() async {
    try {
      // Check if storage is initialized
      if (!_storageService.isInitialized) {
        await _storageService.init();
        // After initializing storage, try to restore state again
        _restoreStateFromStorage();
      }

      // Check if user is already restored from storage (from onInit)
      if (_currentUser.value != null) {
        print('========================================');
        print('🔄 AUTO-LOGIN: User already restored from storage');
        print(
          '   - Current User: ${_currentUser.value?.name} (${_currentUser.value?.email})',
        );
        print('   - Validating with API...');
        print('========================================');

        // Try to get fresh data from API to validate token and update user info
        try {
          print('🔄 Fetching fresh user data from API...');
          final currentUserData = await _authService.getCurrentUser();
          print('📦 Fresh user data from API (should be user object only):');
          print('   - Keys: ${currentUserData.keys.toList()}');
          print('   - Full Data: $currentUserData');

          final token =
              _storageService.getToken() ?? _currentUser.value?.token ?? '';
          // getCurrentUser() now returns ONLY the user object, not nested
          // UserModel.fromJson() will handle it correctly
          final user = UserModel.fromJson(
            currentUserData,
          ).copyWith(token: token);
          print('✅ Updated UserModel from API:');
          print('   - ID: "${user.id}"');
          print('   - Name: "${user.name}"');
          print('   - Email: "${user.email}"');
          print('   - Role: ${user.role}');
          print('   - Is Verified: ${user.isVerified}');
          print('   - Phone: ${user.phone}');
          print('   - Profile Image: ${user.profileImage}');
          print('   - Address: ${user.address}');
          print('   - City: ${user.city}');
          print('   - Country: ${user.country}');
          print('   - Created At: ${user.createdAt}');
          print('   - Wallet: ${user.wallet}');
          print(
            '   - Token: ${user.token != null ? "${user.token!.substring(0, 20)}..." : "null"}',
          );

          _currentUser.value = user;
          _apiClient.setToken(token);
          _initializeWallet(user.id, user.isVerified);
          update(); // Notify listeners that state has changed

          // Update stored user data with fresh data from API
          await _saveUserData(user, token);
          print('✅ User data validated and updated from API');
          print('✅ Stored user data updated in SharedPreferences');
          print('========================================');
          return true;
        } catch (e) {
          // If API call fails (network error, timeout, etc.), keep using stored data
          print('⚠️ API validation failed, using stored data: $e');
          print(
            '   - Keeping existing user: ${_currentUser.value?.name} (${_currentUser.value?.email})',
          );
          // Ensure token is set even if API fails
          final token = _storageService.getToken();
          if (token != null) {
            _apiClient.setToken(token);
            print('✅ Token set in ApiClient');
          }
          update(); // Notify listeners that state is ready (even if from storage)
          print('✅ Using stored data (offline mode)');
          print('========================================');
          return true; // Return true because we have valid stored data
        }
      }

      // If user is not restored, try to restore now
      // Check if user is logged in
      if (!_storageService.getLoginStatus()) {
        print('Auto-login: No login status found');
        return false;
      }

      // Get stored token
      final token = _storageService.getToken();
      if (token == null || token.isEmpty) {
        print('Auto-login: No token found');
        return false;
      }

      // Get stored user data
      var userData = _storageService.getUserData();

      // If stored user data is empty or invalid, try to get it from saved API response
      if (userData == null ||
          (userData['id']?.toString().isEmpty ?? true) ||
          (userData['email']?.toString().isEmpty ?? true)) {
        print(
          'Auto-login: Stored user data is empty, trying to restore from API response',
        );
        final apiResponse = _storageService.getLoginApiResponse();
        if (apiResponse != null && apiResponse['data'] != null) {
          final data = apiResponse['data'] as Map<String, dynamic>;
          if (data['user'] != null) {
            userData = data['user'] as Map<String, dynamic>;
            print(
              'Auto-login: Restored user data from API response: $userData',
            );
            // Save the corrected user data
            final user = UserModel.fromJson(userData);
            await _storageService.saveUserData(user.toJson());
          }
        }
      }

      if (userData == null) {
        print('Auto-login: No user data found in storage');
        return false;
      }

      // Set token in API client
      _apiClient.setToken(token);

      // Restore user from stored data
      try {
        print('🔄 Parsing stored user data to UserModel...');
        print('   - UserData: $userData');
        final user = UserModel.fromJson(userData).copyWith(token: token);
        print('✅ UserModel created:');
        print('   - ID: ${user.id}');
        print('   - Name: ${user.name}');
        print('   - Email: ${user.email}');
        print('   - Role: ${user.role}');
        print('   - Is Verified: ${user.isVerified}');
        print('   - Phone: ${user.phone}');
        print('   - Profile Image: ${user.profileImage}');
        print('   - Address: ${user.address}');
        print('   - City: ${user.city}');
        print('   - Country: ${user.country}');
        print('   - Created At: ${user.createdAt}');
        print('   - Wallet: ${user.wallet}');

        _currentUser.value = user;
        _initializeWallet(user.id, user.isVerified);
        update(); // Notify listeners that state has changed
        print('✅ User data restored from storage');
      } catch (parseError) {
        // If stored data is corrupted, clear it
        print('❌ Error parsing stored user data: $parseError');
        print('   - Stored userData was: $userData');
        await _storageService.clearAll();
        print('❌ Cleared corrupted data from storage');
        return false;
      }

      // Try to get fresh data from API to validate token and update user info
      try {
        print('🔄 Fetching fresh user data from API...');
        final currentUserData = await _authService.getCurrentUser();
        print('📦 Fresh user data from API (should be user object only):');
        print('   - Keys: ${currentUserData.keys.toList()}');
        print('   - Full Data: $currentUserData');

        // getCurrentUser() now returns ONLY the user object, not nested
        // UserModel.fromJson() will handle it correctly
        final user = UserModel.fromJson(currentUserData).copyWith(token: token);
        print('✅ Updated UserModel from API:');
        print('   - ID: "${user.id}"');
        print('   - Name: "${user.name}"');
        print('   - Email: "${user.email}"');
        print('   - Role: ${user.role}');
        print('   - Is Verified: ${user.isVerified}');
        print('   - Phone: ${user.phone}');
        print('   - Profile Image: ${user.profileImage}');
        print('   - Address: ${user.address}');
        print('   - City: ${user.city}');
        print('   - Country: ${user.country}');
        print('   - Created At: ${user.createdAt}');
        print('   - Wallet: ${user.wallet}');
        print(
          '   - Token: ${user.token != null ? "${user.token!.substring(0, 20)}..." : "null"}',
        );

        _currentUser.value = user;
        _apiClient.setToken(token);
        _initializeWallet(user.id, user.isVerified);
        update(); // Notify listeners that state has changed

        // Update stored user data with fresh data from API
        await _saveUserData(user, token);
        print('✅ User data updated from API and saved to storage');
        print('========================================');
        return true;
      } catch (e) {
        // If API call fails (network error, timeout, etc.), keep using stored data
        print('⚠️ API call failed, using stored data: $e');
        print(
          '   - Keeping existing user: ${_currentUser.value?.name} (${_currentUser.value?.email})',
        );
        update(); // Notify listeners that state is ready (even if from storage)
        print('✅ Using stored data (offline mode)');
        print('========================================');
        return true; // Return true because we already restored user from storage
      }
    } catch (e) {
      // Only clear data if there's a critical error (e.g., storage not accessible)
      print('Auto-login error: $e');
      return false;
    }
  }

  /// Refresh current user data from API
  ///
  /// Fetches the latest user data from /auth/me endpoint
  /// Updates the current user state with fresh data
  Future<void> refreshUser() async {
    if (!isAuthenticated) {
      print('AuthState.refreshUser: User not authenticated, skipping...');
      return;
    }

    _isLoading.value = true;
    update();

    try {
      print('AuthState.refreshUser: Fetching current user data from API...');
      final userData = await _authService.getCurrentUser();

      print('AuthState.refreshUser: Received user data: $userData');

      // Get current token (don't overwrite it)
      final currentToken =
          _currentUser.value?.token ?? _storageService.getToken() ?? '';

      // Create user model from fresh data
      final user = UserModel.fromJson(userData).copyWith(token: currentToken);

      print(
        'AuthState.refreshUser: Updated user model - Name: "${user.name}", Email: "${user.email}"',
      );

      // Update current user
      _currentUser.value = user;

      // Save to storage to keep it in sync
      await _saveUserData(user, currentToken);

      // Update wallet if needed
      _initializeWallet(user.id, user.isVerified);

      _isLoading.value = false;
      update();

      print('AuthState.refreshUser: Successfully refreshed user data');
    } on api.ApiException catch (e) {
      print('AuthState.refreshUser: API error - ${e.message}');
      _isLoading.value = false;
      update();
      // Don't throw - just log the error, keep existing user data
    } catch (e) {
      print('AuthState.refreshUser: Unexpected error - $e');
      _isLoading.value = false;
      update();
      // Don't throw - just log the error, keep existing user data
    }
  }

  /// Logout user
  Future<void> logout() async {
    _isLoading.value = true;
    update();

    try {
      // Call logout API if user is authenticated
      if (_currentUser.value != null) {
        try {
          await _authService.logout();
        } catch (e) {
          // Even if API call fails, clear local data
        }
      }

      // Clear local storage
      await _storageService.clearAll();

      // Clear state
      _currentUser.value = null;
      _wallet.value = null;
      _apiClient.setToken(null);

      _isLoading.value = false;
      update();
    } catch (e) {
      // Clear local data even if logout fails
      await _storageService.clearAll();
      _currentUser.value = null;
      _wallet.value = null;
      _apiClient.setToken(null);
      _isLoading.value = false;
      update();
    }
  }

  /// Save user data to storage
  Future<void> _saveUserData(UserModel user, String token) async {
    await _storageService.saveUserData(user.toJson());
    await _storageService.saveToken(token);
    await _storageService.saveLoginStatus(true);
  }

  /// Initialize wallet
  void _initializeWallet(String userId, bool isVerified) {
    // Start with empty wallet, will be updated from API in future
    _wallet.value = WalletModel(
      userId: userId,
      balance: 0.0,
      isVerified: isVerified,
      depositAmount: 0.0,
      depositDate: DateTime.now(),
    );
  }

  /// Mock wallet deposit (kept for backward compatibility)
  Future<void> mockDeposit(double amount) async {
    if (_currentUser.value == null) return;

    _isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    final currentWallet = _wallet.value;
    if (currentWallet != null) {
      _wallet.value = currentWallet.copyWith(
        balance: currentWallet.balance + amount,
        isVerified: amount >= 4500.0,
        depositAmount: amount >= 4500.0 ? amount : currentWallet.depositAmount,
        depositDate: amount >= 4500.0
            ? DateTime.now()
            : currentWallet.depositDate,
      );

      // Update user verification status
      if (amount >= 4500.0 && _currentUser.value != null) {
        _currentUser.value = _currentUser.value!.copyWith(isVerified: true);
      }
    } else {
      _wallet.value = WalletModel(
        userId: _currentUser.value!.id,
        balance: amount,
        isVerified: amount >= 4500.0,
        depositAmount: amount >= 4500.0 ? amount : null,
        depositDate: amount >= 4500.0 ? DateTime.now() : null,
      );
    }

    _isLoading.value = false;
    update();
  }
}
