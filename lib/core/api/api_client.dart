import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';
import 'api_helper.dart';

/// API Client Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;
}

/// Centralized HTTP client for API calls
/// Handles requests, responses, and error parsing
class ApiClient {
  ApiClient._();

  static final ApiClient _instance = ApiClient._();
  factory ApiClient() => _instance;

  /// Get the current authentication token
  String? _token;

  /// Set authentication token
  void setToken(String? token) {
    _token = token;
  }

  /// Get authentication token
  String? get token => _token;

  /// Make a POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    return _request(
      'POST',
      endpoint,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// Make a GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    String url = ApiHelper.buildUrl(endpoint);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      url = ApiHelper.buildUrlWithQuery(endpoint, queryParameters);
    }

    return _request(
      'GET',
      url,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// Make a PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    return _request(
      'PUT',
      endpoint,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// Make a DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    return _request(
      'DELETE',
      endpoint,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// Make a multipart/form-data POST request
  Future<Map<String, dynamic>> multipartPost(
    String endpoint, {
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    final urlString = endpoint.startsWith('http')
        ? endpoint
        : ApiHelper.buildUrl(endpoint);

    final request = http.MultipartRequest('POST', Uri.parse(urlString));

    request.headers.addAll({
      'Accept': ApiEndpoints.acceptJson,
      ...?headers,
    });

    if (requiresAuth && _token != null && _token!.isNotEmpty) {
      request.headers['Authorization'] = ApiHelper.getBearerToken(_token!);
    }

    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (files != null) {
      request.files.addAll(files);
    }

    print('API Multipart Request: POST $urlString');
    if (fields != null && fields.isNotEmpty) {
      print('API Multipart Fields: $fields');
    }
    if (files != null) {
      print('API Multipart Files: ${files.map((f) => f.filename).toList()}');
    }

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print('API Response: ${response.statusCode} ${response.reasonPhrase}');
      print('API Response Headers: ${response.headers}');
      print('API Response Body (raw): ${response.body}');

      return _handleResponse(response);
    } on TimeoutException catch (e) {
      print('API TimeoutException: ${e.message}');
      throw ApiException(
        'Connection timeout. Please check your internet connection and try again.',
        statusCode: 0,
      );
    } on http.ClientException catch (e) {
      print('API ClientException: ${e.message}');
      throw ApiException(
        'Network error. Please check your connection and try again.',
        statusCode: 0,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      print('API Unexpected error (multipart): $e');
      throw ApiException('An unexpected error occurred. Please try again.');
    }
  }

  /// Internal request handler
  Future<Map<String, dynamic>> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    // Build URL if endpoint is relative (outside try block for error logging)
    final urlString = endpoint.startsWith('http')
        ? endpoint
        : ApiHelper.buildUrl(endpoint);
    
    try {
      final url = Uri.parse(urlString);

      // Debug: Print the URL being called (remove in production)
      print('API Request: $method $urlString');
      if (body != null) {
        print('API Body: ${jsonEncode(body)}');
      }

      // Prepare headers
      final requestHeaders = <String, String>{
        'Content-Type': ApiEndpoints.contentTypeJson,
        'Accept': ApiEndpoints.acceptJson,
        ...?headers,
      };

      // Add authorization if required
      if (requiresAuth) {
        if (_token != null && _token!.isNotEmpty) {
          requestHeaders['Authorization'] = ApiHelper.getBearerToken(_token!);
          print('API Request: Added Authorization header with token (full): $_token');
          print('API Request: Authorization header value: ${requestHeaders['Authorization']}');
        } else {
          print('API Request: WARNING - requiresAuth=true but token is null or empty!');
          print('API Request: Token value: $_token');
        }
      }

      // Make request
      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: requestHeaders).timeout(
                const Duration(seconds: 30),
              );
          break;
        case 'POST':
          response = await http
              .post(
                url,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(const Duration(seconds: 30));
          break;
        case 'PUT':
          response = await http
              .put(
                url,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(const Duration(seconds: 30));
          break;
        case 'DELETE':
          response = await http
              .delete(url, headers: requestHeaders)
              .timeout(const Duration(seconds: 30));
          break;
        default:
          throw ApiException('Unsupported HTTP method: $method');
      }

      // Debug: Print response status
      print('API Response: ${response.statusCode} ${response.reasonPhrase}');
      print('API Response Headers: ${response.headers}');
      
      // Always print response body for debugging
      print('API Response Body (raw): ${response.body}');
      
      // Debug: Print response body for errors (helps with debugging)
      if (response.statusCode >= 400) {
        print('API Error Response Body: ${response.body}');
      }

      final result = _handleResponse(response);
      print('API Response (parsed): $result');
      return result;
    } on TimeoutException catch (e) {
      // Log detailed troubleshooting info
      print('API TimeoutException: ${e.message}');
      print('Request URL: $urlString');
      print('Troubleshooting:');
      print('  1. Is your API server running on port 8000?');
      print('  2. For Android emulator, ensure you\'re using http://10.0.2.2:8000');
      print('  3. For physical device, use your computer\'s IP address (e.g., http://192.168.1.100:8000)');
      print('  4. Check if the server is accessible from your device/emulator');
      print('  5. Server URL: ${ApiEndpoints.baseUrl}');
      
      // Show simple message to user
      throw ApiException(
        'Connection timeout. Please check your internet connection and try again.',
        statusCode: 0,
      );
    } on http.ClientException catch (e) {
      // Log detailed info
      print('API ClientException: ${e.message}');
      print('Request URL: $urlString');
      print('Server URL: ${ApiEndpoints.baseUrl}');
      print('Troubleshooting: Ensure the API server is running and accessible');
      
      // Show simple message to user
      throw ApiException(
        'Network error. Please check your connection and try again.',
        statusCode: 0,
      );
    } on FormatException catch (e) {
      // Log detailed info
      print('API FormatException: ${e.message}');
      print('Request URL: $urlString');
      
      // Show simple message to user
      throw ApiException(
        'Invalid response format. Please try again.',
        statusCode: 0,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      
      // Log detailed error
      print('API Unexpected error: $e');
      print('Request URL: $urlString');
      
      // Check if it's a timeout error by string matching
      if (e.toString().contains('TimeoutException') || e.toString().contains('Future not completed')) {
        print('Troubleshooting:');
        print('  1. Is your API server running on port 8000?');
        print('  2. For Android emulator, ensure you\'re using http://10.0.2.2:8000');
        print('  3. For physical device, use your computer\'s IP address');
        print('  4. Check if the server is accessible from your device/emulator');
        print('  5. Server URL: ${ApiEndpoints.baseUrl}');
        
        // Show simple message to user
        throw ApiException(
          'Connection timeout. Please check your internet connection and try again.',
          statusCode: 0,
        );
      }
      
      // Show simple message to user
      throw ApiException('An unexpected error occurred. Please try again.');
    }
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

      // Parse response body
      Map<String, dynamic>? responseData;
      try {
        if (response.body.isNotEmpty) {
          responseData = jsonDecode(response.body) as Map<String, dynamic>;
        }
      } catch (_) {
        // If parsing fails, treat as empty response
        responseData = null;
      }

    // Handle success responses (200-299)
    if (statusCode >= 200 && statusCode < 300) {
      return responseData ?? {'success': true};
    }

    // Handle error responses
    String errorMessage = 'An error occurred';
    Map<String, dynamic>? errors;

    if (responseData != null) {
      // Debug: Log full error response
      print('API Error Response Data: $responseData');
      
      // Try to extract error message from various possible fields
      if (responseData.containsKey('message')) {
        errorMessage = responseData['message'].toString();
      } else if (responseData.containsKey('error')) {
        errorMessage = responseData['error'].toString();
      } else if (responseData.containsKey('error_message')) {
        errorMessage = responseData['error_message'].toString();
      }

      // Extract validation errors if present
      if (responseData.containsKey('errors')) {
        errors = responseData['errors'] as Map<String, dynamic>;
        // Format validation errors into a readable message
        if (errors.isNotEmpty) {
          final errorList = <String>[];
          errors.forEach((key, value) {
            if (value is List) {
              errorList.addAll(value.map((e) => e.toString()));
            } else {
              errorList.add(value.toString());
            }
          });
          if (errorList.isNotEmpty) {
            errorMessage = errorList.join(', ');
          }
        }
      }
    }

    // Map status codes to user-friendly messages
    switch (statusCode) {
      case 401:
        errorMessage = 'Invalid credentials. Please try again.';
        break;
      case 403:
        errorMessage = 'Unauthorized. Please login again.';
        break;
      case 404:
        errorMessage = 'Resource not found.';
        break;
      case 422:
        errorMessage = errorMessage.isNotEmpty
            ? errorMessage
            : 'Validation error. Please check your input.';
        break;
      case 500:
        errorMessage = 'Server error. Please try again later.';
        break;
      default:
        if (errorMessage == 'An error occurred') {
          errorMessage = 'Request failed. Please try again.';
        }
    }

    throw ApiException(
      errorMessage,
      statusCode: statusCode,
      errors: errors,
    );
  }
}
