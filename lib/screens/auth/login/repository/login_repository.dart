import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/constants/app_url.dart';
import '../../../../core/utils/location_service.dart';
import '../../../../core/utils/device_utils.dart';
import '../../../../core/data/repositories/driver_repository.dart';

class LoginRepository {
  final NetworkService _networkService;
  final DriverRepository _driverRepository;

  LoginRepository({
    required NetworkService networkService,
    DriverRepository? driverRepository,
  }) : _networkService = networkService,
       _driverRepository =
           driverRepository ?? DriverRepository(networkService: networkService);

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

      // Extract token from response
      String? token;
      if (response is Map) {
        // Common cases: { token: "..." } or nested under data
        if (response['token']  != null) {
          token = response['token'];
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

      // Persist token and driver ID
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('driver_id', driverId);
      await prefs.reload();

      // Save device ID for push notifications (non-blocking)
      final tokenForDeviceId = token; // Store in local variable
      Future.delayed(const Duration(milliseconds: 300), () {
        _saveDeviceIdAfterLogin(driverId, tokenForDeviceId).catchError((error) {
          // Log error but don't fail login if device ID save fails
          developer.log('Failed to save device ID after login: $error');
        });
      });

      return {'success': true, 'token': token, 'driverId': driverId};
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
      final String url = AppUrl.baseUrl + AppUrl.driverLogout;
      await _networkService.getGetApiResponse(url);

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('driver_id');
      await prefs.remove('driver_data');
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

  /// Save device ID after successful login (called asynchronously)
  Future<void> _saveDeviceIdAfterLogin(String driverId, String token) async {
    try {
      // Ensure token is saved to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') != token) {
        await prefs.setString('token', token);
        await prefs.reload();
      }

      // Get device ID and save to server
      final deviceId = await DeviceUtils.getDeviceId();
      final result = await _driverRepository.saveDeviceId(
        driverId: driverId,
        deviceId: deviceId,
        authToken: token,
      );

      // Log result
      if (result['success'] == true) {
        developer.log('✅ Device ID saved successfully: ${result['message']}');
      } else {
        developer.log('❌ Device ID save failed: ${result['message']}');
      }
    } catch (e) {
      // Device ID save failure shouldn't block login
      developer.log('❌ Failed to save device ID: $e');

      // Retry once after delay
      try {
        await Future.delayed(const Duration(seconds: 2));
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();
        final retryToken = prefs.getString('token');

        if (retryToken != null && retryToken.isNotEmpty) {
          final deviceId = await DeviceUtils.getDeviceId();
          final retryResult = await _driverRepository.saveDeviceId(
            driverId: driverId,
            deviceId: deviceId,
            authToken: retryToken,
          );

          if (retryResult['success'] == true) {
            developer.log(
              '✅ Device ID saved successfully on retry: ${retryResult['message']}',
            );
          } else {
            developer.log(
              '❌ Device ID save failed on retry: ${retryResult['message']}',
            );
          }
        }
      } catch (retryError) {
        developer.log('❌ Device ID save retry failed: $retryError');
      }
    }
  }
}
