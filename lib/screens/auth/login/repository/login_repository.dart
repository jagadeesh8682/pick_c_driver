import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/constants/app_url.dart';
import '../../../../core/utils/location_service.dart';

class LoginRepository {
  final NetworkService _networkService;

  LoginRepository({required NetworkService networkService})
    : _networkService = networkService;

  Future<Map<String, dynamic>> login({
    required String driverId,
    required String password,
    String? latitude,
    String? longitude,
  }) async {
    try {
      // Resolve current location if not provided
      if (latitude == null || longitude == null) {
        final position = await LocationService.getCurrentPosition();
        if (position != null) {
          latitude = position.latitude.toStringAsFixed(6);
          longitude = position.longitude.toStringAsFixed(6);
        } else {
          latitude = '0.00';
          longitude = '0.00';
        }
      }

      final String url = AppUrl.baseUrl + AppUrl.driverLogin;
      final Map<String, String> payload = {
        'driverID': driverId,
        'password': password,
        'latitude': latitude,
        'longitude': longitude,
      };

      final dynamic response = await _networkService
          .getPostApiResponseUnauthenticated(url, payload);

      // Response could be JSON with token field or a raw string. Handle both.
      String? token;
      if (response is Map) {
        // Common cases: { token: "..." } or nested under data
        if (response['token'] is String) {
          token = response['token'] as String;
        } else if (response['data'] is Map &&
            (response['data']['token'] is String)) {
          token = response['data']['token'] as String;
        }
      } else if (response is String) {
        // Try to parse loose formats like token ="abc"
        final RegExp rx = RegExp(r'token\s*=\s*"?([A-Za-z0-9._\-]+)"?');
        final match = rx.firstMatch(response);
        if (match != null) {
          token = match.group(1);
        } else {
          // Try JSON parse fallback
          try {
            final parsed = jsonDecode(response);
            if (parsed is Map && parsed['token'] is String) {
              token = parsed['token'] as String;
            }
          } catch (_) {}
        }
      }

      if (token == null || token.isEmpty) {
        throw Exception('Token not found in response');
      }

      // Persist token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return {'success': true, 'token': token};
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> forgotPassword({
    required String driverId,
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiService.post('/auth/forgot-password', {
      //   'driverId': driverId,
      // });
      // return response.data;

      // Mock response for now
      await Future.delayed(const Duration(seconds: 1));

      return {
        'success': true,
        'message': 'Password reset instructions sent successfully',
        'data': {
          'resetToken': 'mock_reset_token',
          'expiresAt': DateTime.now()
              .add(const Duration(hours: 1))
              .toIso8601String(),
        },
      };
    } catch (e) {
      throw Exception('Failed to send reset instructions: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      // TODO: Replace with actual API call
      // await _apiService.post('/auth/logout');

      // Clear local storage
      // await _storageService.remove('auth_token');
      // await _storageService.remove('driver_data');
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  Future<bool> checkAuthStatus() async {
    try {
      // TODO: Replace with actual token validation
      // final token = await _storageService.get('auth_token');
      // if (token == null) return false;
      //
      // final response = await _apiService.get('/auth/verify');
      // return response.data['valid'] == true;

      return false; // Mock response
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      // TODO: Replace with actual API call
      // final refreshToken = await _storageService.get('refresh_token');
      // final response = await _apiService.post('/auth/refresh', {
      //   'refreshToken': refreshToken,
      // });
      // return response.data;

      // Mock response for now
      await Future.delayed(const Duration(milliseconds: 500));

      return {
        'success': true,
        'data': {
          'token': 'new_mock_jwt_token',
          'refreshToken': 'new_mock_refresh_token',
        },
      };
    } catch (e) {
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }
}
