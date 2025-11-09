import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/utils/location_service.dart';
import 'network_service.dart';

class NetworkServiceImpl implements NetworkService {
  static const Duration _defaultTimeout = Duration(seconds: 30);
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  /// Log curl command and request/response details for debugging
  void _logCurlCommand(
    String method,
    String url,
    Map<String, String> headers,
    dynamic body,
  ) {
    print('\n${'=' * 80}');
    print('📡 API REQUEST - $method $url');
    print('${'=' * 80}');

    // Build curl command
    final curlParts = <String>['curl', '-X', method, "'$url'"];

    // Add headers to curl command
    headers.forEach((key, value) {
      curlParts.add("-H '$key: $value'");
    });

    // Add body if present
    if (body != null) {
      final bodyStr = body is String ? body : jsonEncode(body);
      curlParts.add("--data-raw '$bodyStr'");
    }

    print('\n🔧 CURL COMMAND:');
    print(curlParts.join(' \\\n  '));

    print('\n📋 REQUEST DETAILS:');
    print('  Method: $method');
    print('  URL: $url');
    print('  Headers:');
    headers.forEach((key, value) {
      if (key.toLowerCase().contains('auth') ||
          key.toLowerCase().contains('token')) {
        print(
          '    $key: ${value.length > 30 ? "${value.substring(0, 30)}..." : "***MASKED***"}',
        );
      } else {
        print('    $key: $value');
      }
    });

    if (body != null) {
      final bodyStr = body is String ? body : jsonEncode(body);
      print('  Body: $bodyStr');
    }

    print('${'=' * 80}\n');
  }

  /// Log response details
  void _logResponse(http.Response response) {
    print('\n${'=' * 80}');
    print('📥 API RESPONSE');
    print('${'=' * 80}');
    print('  Status Code: ${response.statusCode}');
    print('  Status Message: ${response.reasonPhrase ?? "N/A"}');
    print('  Headers:');
    response.headers.forEach((key, value) {
      print('    $key: $value');
    });
    print('  Body:');
    try {
      // Try to format JSON for better readability
      final jsonData = jsonDecode(response.body);
      print('    ${const JsonEncoder.withIndent('    ').convert(jsonData)}');
    } catch (_) {
      // If not JSON, print as-is
      print('    ${response.body}');
    }
    print('${'=' * 80}\n');
  }

  @override
  Future getGetApiResponse(String url) async {
    try {
      final response = await _makeRequestWithRetry(() async {
        final headers = await _buildHeaders(isDriverApi: true);
        _logCurlCommand('GET', url, headers, null);

        final httpResponse = await http
            .get(Uri.parse(url), headers: headers)
            .timeout(_defaultTimeout);

        _logResponse(httpResponse);
        return httpResponse;
      });
      return _handleResponse(response);
    } catch (e) {
      print('\n❌ ERROR in GET $url:');
      print('  $e');
      print('${'=' * 80}\n');
      log('GET $url - Error: $e');
      return _handleError(e);
    }
  }

  /// Get API response without authentication headers (for public endpoints)
  @override
  Future getGetApiResponseUnauthenticated(String url) async {
    try {
      final headers = {"Content-Type": "application/json"};
      _logCurlCommand('GET', url, headers, null);

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(_defaultTimeout);

      _logResponse(response);
      return _handleResponse(response);
    } catch (e) {
      print('\n❌ ERROR in GET (Unauthenticated) $url:');
      print('  $e');
      print('${'=' * 80}\n');
      return _handleError(e);
    }
  }

  @override
  Future getPostApiResponse(String url, [dynamic data]) async {
    try {
      final response = await _makeRequestWithRetry(() async {
        final headers = await _buildHeaders(isDriverApi: true);
        final bodyStr = data != null ? jsonEncode(data) : null;
        _logCurlCommand('POST', url, headers, bodyStr);

        final httpResponse = await http
            .post(Uri.parse(url), body: bodyStr, headers: headers)
            .timeout(_defaultTimeout);

        _logResponse(httpResponse);
        return httpResponse;
      });
      return _handleResponse(response);
    } catch (e) {
      print('\n❌ ERROR in POST $url:');
      print('  $e');
      print('${'=' * 80}\n');
      log('POST $url - Error: $e');
      return _handleError(e);
    }
  }

  /// Post API response without authentication headers (for OTP verification, login, etc.)
  @override
  Future getPostApiResponseUnauthenticated(String url, [dynamic data]) async {
    try {
      // Add proper headers to avoid "No Hacking" error (HTTP 999)
      // The server may block requests that look suspicious or automated
      final uri = Uri.parse(url);
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "User-Agent": "PickC-Driver-App/1.0 (Android; Flutter)",
        "Accept-Language": "en-US,en;q=0.9",
        "Cache-Control": "no-cache",
        "Origin": "${uri.scheme}://${uri.host}",
        "Referer": "${uri.scheme}://${uri.host}/",
        "X-Requested-With": "XMLHttpRequest",
      };

      final bodyStr = data != null ? jsonEncode(data) : null;
      _logCurlCommand('POST', url, headers, bodyStr);

      final response = await http
          .post(Uri.parse(url), body: bodyStr, headers: headers)
          .timeout(_defaultTimeout);

      _logResponse(response);

      // Handle HTTP 999 specifically
      if (response.statusCode == 999) {
        print(
          '\n❌ HTTP 999 - Server blocked request. This usually means missing or incorrect headers.',
        );
        throw Exception(
          'HTTP 999: No Hacking - Server blocked the request. Please check API configuration.',
        );
      }

      return _handleResponse(response);
    } catch (e) {
      print('\n❌ ERROR in POST (Unauthenticated) $url:');
      print('  $e');
      print('  Error type: ${e.runtimeType}');
      print('${'=' * 80}\n');
      log('NetworkServiceImpl: Error in getPostApiResponseUnauthenticated: $e');
      log('NetworkServiceImpl: Error type: ${e.runtimeType}');
      return _handleError(e);
    }
  }

  @override
  Future getPutApiResponse(String url, [dynamic data]) async {
    try {
      final response = await _makeRequestWithRetry(() async {
        final headers = await _buildHeaders();
        final bodyStr = data != null ? jsonEncode(data) : null;
        _logCurlCommand('PUT', url, headers, bodyStr);

        final httpResponse = await http
            .put(Uri.parse(url), body: bodyStr, headers: headers)
            .timeout(_defaultTimeout);

        _logResponse(httpResponse);
        return httpResponse;
      });
      return _handleResponse(response);
    } catch (e) {
      print('\n❌ ERROR in PUT $url:');
      print('  $e');
      print('${'=' * 80}\n');
      return _handleError(e);
    }
  }

  @override
  Future getDeleteApiResponse(String url) async {
    try {
      final response = await _makeRequestWithRetry(() async {
        final headers = await _buildHeaders();
        _logCurlCommand('DELETE', url, headers, null);

        final httpResponse = await http
            .delete(Uri.parse(url), headers: headers)
            .timeout(_defaultTimeout);

        _logResponse(httpResponse);
        return httpResponse;
      });
      return _handleResponse(response);
    } catch (e) {
      print('\n❌ ERROR in DELETE $url:');
      print('  $e');
      print('${'=' * 80}\n');
      return _handleError(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case >= 200 && < 300: //9444246473 123456
        // Try to parse as JSON first
        try {
          final decoded = jsonDecode(response.body);
          return decoded;
        } catch (e) {
          // If JSON parsing fails, check if it's a plain string response
          // Some APIs return plain strings (e.g., duty status API)
          final trimmedBody = response.body.trim();
          if (trimmedBody.isNotEmpty) {
            // Return as string if it's not empty
            return trimmedBody;
          }
          // If body is empty, return null or empty string
          return null;
        }
      case 400:
        return _handleBadRequest(response);
      case 401:
        log('401 Unauthorized - Response: ${response.body}');
        String errorMessage = 'Unauthorized - Session expired';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage =
              errorData['message'] ??
              errorData['error'] ??
              errorData['Message'] ??
              errorData['Error'] ??
              response.body ??
              errorMessage;
        } catch (_) {
          errorMessage = response.body.isNotEmpty
              ? response.body
              : errorMessage;
        }
        throw Exception(errorMessage);
      case 403:
        throw Exception("Access denied");
      case 404:
        // Handle 404 responses that might contain valid JSON with error messages
        return _handleNotFoundResponse(response);
      case 500:
        throw Exception("Internal server error");
      case 999:
        // HTTP 999 is often used by servers to block suspicious requests
        String errorMessage = 'No Hacking';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage =
              errorData['message'] ??
              errorData['error'] ??
              response.body ??
              errorMessage;
        } catch (_) {
          errorMessage = response.body.isNotEmpty
              ? response.body
              : errorMessage;
        }
        throw Exception("HTTP 999: $errorMessage");
      default:
        throw Exception(
          "HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Unknown error'}",
        );
    }
  }

  dynamic _handleBadRequest(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      // Return the error data instead of throwing, so caller can handle specific errors
      return errorData;
    } catch (e) {
      if (e is FormatException) {
        throw Exception("Bad request: ${response.body}");
      }
      rethrow;
    }
  }

  dynamic _handleNotFoundResponse(http.Response response) {
    try {
      // Try to parse the response body as JSON
      final data = jsonDecode(response.body);
      // If it's a valid JSON response, return it (might contain error info)
      return data;
    } catch (e) {
      // If it's not valid JSON, throw a generic 404 error
      throw Exception("Resource not found");
    }
  }

  Future<http.Response> _makeRequestWithRetry(
    Future<http.Response> Function() request,
  ) async {
    int attempts = 0;
    while (attempts < _maxRetries) {
      try {
        final response = await request();
        return response;
      } catch (e) {
        attempts++;
        if (attempts >= _maxRetries) {
          rethrow;
        }
        // Wait before retrying
        await Future.delayed(_retryDelay * attempts);
      }
    }
    throw Exception("Max retries exceeded");
  }

  Future<Map<String, String>> _buildHeaders({bool isDriverApi = true}) async {
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    try {
      final prefs = await SharedPreferences.getInstance();

      // Get authentication token
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        headers['AUTH_TOKEN'] = token.trim();
      }

      // For Driver APIs, add all required headers
      if (isDriverApi) {
        // MOBILENO - empty string for driver APIs
        headers['MOBILENO'] = '';

        // DRIVERID - get from SharedPreferences
        final driverId = prefs.getString('driver_id');
        if (driverId != null && driverId.isNotEmpty) {
          headers['DRIVERID'] = driverId;
        }

        // LATITUDE and LONGITUDE - get current device location
        try {
          final position = await LocationService.getCurrentPosition();
          if (position != null) {
            headers['LATITUDE'] = position.latitude.toStringAsFixed(6);
            headers['LONGITUDE'] = position.longitude.toStringAsFixed(6);
          } else {
            // Use last known position or default to 0
            final lastPosition = await Geolocator.getLastKnownPosition();
            if (lastPosition != null) {
              headers['LATITUDE'] = lastPosition.latitude.toStringAsFixed(6);
              headers['LONGITUDE'] = lastPosition.longitude.toStringAsFixed(6);
            } else {
              headers['LATITUDE'] = '0.00';
              headers['LONGITUDE'] = '0.00';
            }
          }
        } catch (e) {
          log('Error getting location for headers: $e');
          headers['LATITUDE'] = '0.00';
          headers['LONGITUDE'] = '0.00';
        }

        // TYPE = "DRIVER" for driver APIs
        headers['TYPE'] = 'DRIVER';
      } else {
        // For Customer APIs
        // MOBILENO - get from SharedPreferences if available
        final mobile = prefs.getString('mobile_number');
        headers['MOBILENO'] = mobile ?? '';
        headers['TYPE'] = ''; // Empty string for customer APIs
      }
    } catch (e) {
      log('Error building headers: $e');
    }

    return headers;
  }

  dynamic _handleError(dynamic error) {
    if (error is FormatException) {
      throw Exception("Data format error: ${error.message}");
    } else if (error is Exception) {
      throw error;
    } else {
      throw Exception("Network error: $error");
    }
  }
}
