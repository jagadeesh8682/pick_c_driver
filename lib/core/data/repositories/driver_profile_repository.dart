import '../models/main/driver_profile_model.dart';
import '../../network/network_service.dart';
import '../../constants/app_url.dart';

class DriverProfileRepository {
  final NetworkService _networkService;

  DriverProfileRepository({required NetworkService networkService})
    : _networkService = networkService;

  /// Get driver profile
  Future<DriverProfile> getDriverProfile({required String driverId}) async {
    try {
      final url = AppUrl.baseUrl + 'master/ADdriver/getDriver';
      final response = await _networkService.getPostApiResponse(url, {
        'DriverID': driverId,
      });

      if (response is Map) {
        return DriverProfile.fromJson(Map<String, dynamic>.from(response));
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to get driver profile: ${e.toString()}');
    }
  }

  /// Get driver details
  Future<DriverProfile> getDriverDetails({required String driverId}) async {
    try {
      final url = AppUrl.baseUrl + 'master/ADdriver/GetDriverDetails';
      final response = await _networkService.getPostApiResponse(url, {
        'DriverID': driverId,
      });

      if (response is Map) {
        return DriverProfile.fromJson(Map<String, dynamic>.from(response));
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to get driver details: ${e.toString()}');
    }
  }

  /// Get driver trip amount
  Future<Map<String, dynamic>> getDriverTripAmount({
    required String driverId,
  }) async {
    try {
      final url = AppUrl.baseUrl + 'master/ADdriver/DriverTripAmount';
      final response = await _networkService.getPostApiResponse(url, {
        'DriverID': driverId,
      });

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to get driver trip amount: ${e.toString()}');
    }
  }

  /// Get driver trip amount by payment type
  Future<Map<String, dynamic>> getDriverTripAmountByPaymentType({
    required String driverId,
    required String paymentType,
  }) async {
    try {
      final url =
          AppUrl.baseUrl + 'master/ADdriver/GetDriverTripAmountbyPaymentType';
      final response = await _networkService.getPostApiResponse(url, {
        'DriverID': driverId,
        'PaymentType': paymentType,
      });

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception(
        'Failed to get trip amount by payment type: ${e.toString()}',
      );
    }
  }

  /// Get driver trip count
  Future<Map<String, dynamic>> getDriverTripCount({
    required String driverId,
  }) async {
    try {
      final url = AppUrl.baseUrl + 'master/ADdriver/DriverTripCount';
      final response = await _networkService.getPostApiResponse(url, {
        'DriverID': driverId,
      });

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to get driver trip count: ${e.toString()}');
    }
  }

  /// Get list of trips for driver
  Future<List<Map<String, dynamic>>> getDriverListOfTrips({
    required String driverId,
  }) async {
    try {
      final url = AppUrl.baseUrl + 'master/ADdriver/DriverListOfTrips';
      final response = await _networkService.getPostApiResponse(url, {
        'DriverID': driverId,
      });

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else if (response is Map) {
        return [Map<String, dynamic>.from(response)];
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get driver trips: ${e.toString()}');
    }
  }

  /// Get driver referral information
  Future<Map<String, dynamic>> getDriverReferral({
    required String driverId,
  }) async {
    try {
      final url = AppUrl.baseUrl + 'master/ADdriver/DriverReferral';
      final response = await _networkService.getPostApiResponse(url, {
        'DriverID': driverId,
      });

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to get driver referral: ${e.toString()}');
    }
  }

  /// Check if driver vehicle is attached
  Future<Map<String, dynamic>> checkDriverVehicleAttachment({
    required String driverId,
  }) async {
    try {
      final url =
          AppUrl.baseUrl + 'operation/driveractivity/CheckDriverVehicle';
      final response = await _networkService.getPostApiResponse(url, {
        'DriverID': driverId,
      });

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception(
        'Failed to check driver vehicle attachment: ${e.toString()}',
      );
    }
  }

  /// Check if driver is in trip
  Future<DriverTrip> isDriverInTrip({required String driverId}) async {
    try {
      final url = AppUrl.baseUrl + 'operation/trip/driver/isintrip';
      final response = await _networkService.getPostApiResponse(url, {
        'DriverID': driverId,
      });

      if (response is Map) {
        return DriverTrip.fromJson(Map<String, dynamic>.from(response));
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to check trip status: ${e.toString()}');
    }
  }
}

