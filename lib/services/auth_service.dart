import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

/// Authentication Service
/// Handles all authentication-related API calls
class AuthService {
  AuthService._();

  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;

  final ApiClient _apiClient = ApiClient();

  /// Register a new user
  /// 
  /// Returns a map containing:
  /// - user: Map with user data
  /// - token: String authentication token
  /// 
  /// Throws ApiException on error
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    Uint8List? registrationImage1,
    Uint8List? registrationImage2,
  }) async {
    try {
      final fields = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
      };

      final files = <http.MultipartFile>[];
      if (registrationImage1 != null) {
        files.add(
          http.MultipartFile.fromBytes(
            'registration_image_1',
            registrationImage1,
            filename: 'registration_front.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }
      if (registrationImage2 != null) {
        files.add(
          http.MultipartFile.fromBytes(
            'registration_image_2',
            registrationImage2,
            filename: 'registration_back.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final response = await _apiClient.multipartPost(
        ApiEndpoints.register,
        fields: fields,
        files: files.isEmpty ? null : files,
      );

      // Parse response
      
      // Check for error response (success: false)
      if (response['success'] == false) {
        final errorMessage = response['message']?.toString() ?? 
                            response['error']?.toString() ?? 
                            'Registration failed. Please try again.';
        throw ApiException(errorMessage);
      }
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return {
          'user': data['user'] ?? data,
          'token': data['token'] ?? '',
        };
      }

      // Fallback: if response structure is different
      if (response['user'] != null) {
        return {
          'user': response['user'],
          'token': response['token'] ?? '',
        };
      }

      throw ApiException('Invalid response format from server');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Registration failed: ${e.toString()}');
    }
  }

  /// Login user
  /// 
  /// Returns a map containing:
  /// - user: Map with user data
  /// - token: String authentication token
  /// - fullResponse: The complete original API response
  /// 
  /// Throws ApiException on error
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final fullResponse = await _apiClient.post(
        ApiEndpoints.login,
        body: {
          'email': email,
          'password': password,
        },
      );

      // Parse response
      print('AuthService.login: Full response: $fullResponse');
      
      // Check for error response (success: false)
      if (fullResponse['success'] == false) {
        final errorMessage = fullResponse['message']?.toString() ?? 
                            fullResponse['error']?.toString() ?? 
                            'Login failed. Please try again.';
        throw ApiException(errorMessage);
      }
      
      if (fullResponse['success'] == true && fullResponse['data'] != null) {
        final data = fullResponse['data'] as Map<String, dynamic>;
        print('AuthService.login: Data object: $data');
        print('AuthService.login: User object: ${data['user']}');
        print('AuthService.login: Token: ${data['token']}');
        
        final userData = data['user'] as Map<String, dynamic>? ?? data;
        final tokenData = data['token'] as String? ?? '';
        
        print('AuthService.login: Extracted user data: $userData');
        print('AuthService.login: Extracted token: $tokenData');
        
        return {
          'user': userData,
          'token': tokenData,
          'fullResponse': fullResponse, // Include full response
        };
      }

      // Fallback: if response structure is different
      if (fullResponse['user'] != null) {
        return {
          'user': fullResponse['user'],
          'token': fullResponse['token'] ?? '',
          'fullResponse': fullResponse, // Include full response
        };
      }

      throw ApiException('Invalid response format from server');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Login failed: ${e.toString()}');
    }
  }

  /// Admin login
  /// 
  /// Returns a map containing:
  /// - user: Map with user data
  /// - token: String authentication token
  /// - fullResponse: The complete original API response
  /// 
  /// Throws ApiException on error
  Future<Map<String, dynamic>> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      final fullResponse = await _apiClient.post(
        ApiEndpoints.adminLogin,
        body: {
          'email': email,
          'password': password,
        },
      );

      // Parse response
      print('AuthService.adminLogin: Full response: $fullResponse');
      
      // Check for error response (success: false)
      if (fullResponse['success'] == false) {
        final errorMessage = fullResponse['message']?.toString() ?? 
                            fullResponse['error']?.toString() ?? 
                            'Admin login failed. Please try again.';
        throw ApiException(errorMessage);
      }
      
      if (fullResponse['success'] == true && fullResponse['data'] != null) {
        final data = fullResponse['data'] as Map<String, dynamic>;
        print('AuthService.adminLogin: Data object: $data');
        print('AuthService.adminLogin: User object: ${data['user']}');
        print('AuthService.adminLogin: Token: ${data['token']}');
        
        final userData = data['user'] as Map<String, dynamic>? ?? data;
        final tokenData = data['token'] as String? ?? '';
        
        print('AuthService.adminLogin: Extracted user data: $userData');
        print('AuthService.adminLogin: Extracted token: $tokenData');
        
        return {
          'user': userData,
          'token': tokenData,
          'fullResponse': fullResponse, // Include full response
        };
      }

      // Fallback: if response structure is different
      if (fullResponse['user'] != null) {
        return {
          'user': fullResponse['user'],
          'token': fullResponse['token'] ?? '',
          'fullResponse': fullResponse, // Include full response
        };
      }

      throw ApiException('Invalid response format from server');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Admin login failed: ${e.toString()}');
    }
  }

  /// Logout user
  /// 
  /// Throws ApiException on error
  Future<void> logout() async {
    try {
      await _apiClient.post(
        ApiEndpoints.logout,
        requiresAuth: true,
      );
    } on ApiException {
      // Even if API call fails, we should still clear local data
      rethrow;
    } catch (e) {
      throw ApiException('Logout failed: ${e.toString()}');
    }
  }

  /// Get current authenticated user
  /// 
  /// Returns user data map (ONLY the user object, not nested in data)
  /// 
  /// Throws ApiException on error
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getCurrentUser,
        requiresAuth: true,
      );

      print('AuthService.getCurrentUser: Full response: $response');

      // Parse response - API returns {success: true, data: {user: {...}}}
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        print('AuthService.getCurrentUser: Data object: $data');
        
        // Extract user object from data
        if (data['user'] != null) {
          final userData = data['user'] as Map<String, dynamic>;
          print('AuthService.getCurrentUser: Extracted user object: $userData');
          return userData;
        }
        
        // If data itself is the user object (fallback)
        print('AuthService.getCurrentUser: Data is user object (fallback)');
        return data;
      }

      // Fallback: if response structure is different
      if (response['user'] != null) {
        print('AuthService.getCurrentUser: User at root level (fallback)');
        return response['user'] as Map<String, dynamic>;
      }

      throw ApiException('Invalid response format from server');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get user data: ${e.toString()}');
    }
  }
}
