import '../../network/network_service.dart';
import '../../constants/app_url.dart';
import '../models/main/booking_info_model.dart';
import '../models/main/booking_response_models.dart';
import '../models/main/trip_request_models.dart';
import '../models/main/driver_profile_model.dart';
import '../../utils/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverRepository {
  final NetworkService _networkService;

  DriverRepository({required NetworkService networkService})
    : _networkService = networkService;

  // ==================== Authentication ====================

  /// Save device ID for push notifications
  /// Returns a Map with 'success' (bool) and 'message' (String)
  Future<Map<String, dynamic>> saveDeviceId({
    required String driverId,
    required String deviceId,
    String? authToken,
  }) async {
    try {
      final url = AppUrl.baseUrl + AppUrl.saveDriverDeviceId;
      print('=== Save Device ID ===');
      print('Driver ID: $driverId');
      print(
        'Device ID: ${deviceId.length > 30 ? "${deviceId.substring(0, 30)}..." : deviceId}',
      );

      // Get token: prefer passed token, otherwise from SharedPreferences
      String? token = authToken;
      if (token == null || token.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();
        token = prefs.getString('token');
      }

      // Validate token exists
      if (token == null || token.isEmpty) {
        print('❌ FAILED: Authentication token is required');
        return {
          'success': false,
          'message': 'Authentication token is required',
        };
      }

      // Ensure token is saved to SharedPreferences for header building
      if (authToken != null && authToken.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', authToken);
        await prefs.reload();
      }

      // Prepare request body (API specification: driverId and deviceId only)
      final requestBody = {'driverId': driverId, 'deviceId': deviceId};

      final response = await _networkService.getPostApiResponse(
        url,
        requestBody,
      );

      // Parse response
      String message;
      if (response is String) {
        message = response;
      } else if (response is Map) {
        message =
            response['message'] ??
            response['status'] ??
            response['Message'] ??
            response['Status'] ??
            'Device ID saved successfully';
      } else {
        message = 'Device ID saved successfully';
      }

      print('✅ SUCCESS: $message');
      print('Response: $response');
      print('=== End Save Device ID ===');

      return {'success': true, 'message': message, 'data': response};
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('❌ FAILED: $errorMessage');
      print('Error: $e');
      print('=== End Save Device ID ===');
      return {'success': false, 'message': errorMessage, 'error': e.toString()};
    }
  }

  /// Driver logout
  Future<String> logout() async {
    try {
      final url = AppUrl.baseUrl + AppUrl.driverLogout;
      final response = await _networkService.getGetApiResponse(url);
      return response is String ? response : 'USER LOGGEDOUT SUCCESSFULLY';
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  // ==================== Booking Management ====================

  /// Accept booking
  Future<AcceptBookingStatus> acceptBooking({
    required String bookingNo,
    required String vehicleNo,
  }) async {
    try {
      final url =
          AppUrl.baseUrl +
          AppUrl.replacePathParams(AppUrl.acceptBooking, {
            'bno': bookingNo,
            'vno': vehicleNo,
          });
      final response = await _networkService.getGetApiResponse(url);

      if (response is Map) {
        return AcceptBookingStatus.fromJson(
          Map<String, dynamic>.from(response),
        );
      } else if (response is String) {
        return AcceptBookingStatus(status: response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to accept booking: ${e.toString()}');
    }
  }

  /// Reject booking
  Future<Status> rejectBooking({
    required String driverId,
    required String vehicleNo,
    required String bookingNo,
    required String cancelRemarks,
    required bool istripstarted,
  }) async {
    try {
      final url = AppUrl.baseUrl + AppUrl.rejectBooking;
      final rejectData = Reject(
        driverId: driverId,
        vehicleNo: vehicleNo,
        bookingNo: bookingNo,
        cancelRemarks: cancelRemarks,
        istripstarted: istripstarted,
      );
      final response = await _networkService.getPostApiResponse(
        url,
        rejectData.toJson(),
      );

      if (response is Map) {
        return Status.fromJson(Map<String, dynamic>.from(response));
      } else if (response is String) {
        return Status(status: response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to reject booking: ${e.toString()}');
    }
  }

  /// Cancel trip
  Future<Status> cancelTrip({
    required String driverId,
    required String vehicleNo,
    required String bookingNo,
    required String cancelRemarks,
    required bool istripstarted,
  }) async {
    try {
      final url = AppUrl.baseUrl + AppUrl.cancelTrip;
      final cancelData = Reject(
        driverId: driverId,
        vehicleNo: vehicleNo,
        bookingNo: bookingNo,
        cancelRemarks: cancelRemarks,
        istripstarted: istripstarted,
      );
      final response = await _networkService.getPostApiResponse(
        url,
        cancelData.toJson(),
      );

      if (response is Map) {
        return Status.fromJson(Map<String, dynamic>.from(response));
      } else if (response is String) {
        return Status(status: response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to cancel trip: ${e.toString()}');
    }
  }

  /// Get booking information
  Future<BookingInfo> getBookingInfo({required String bookingNo}) async {
    try {
      final url =
          AppUrl.baseUrl +
          AppUrl.replacePathParams(AppUrl.getDriverBookingInfo, {
            'bno': bookingNo,
          });
      final response = await _networkService.getGetApiResponse(url);

      if (response is Map) {
        return BookingInfo.fromJson(Map<String, dynamic>.from(response));
      } else if (response is List && response.isNotEmpty) {
        return BookingInfo.fromJson(Map<String, dynamic>.from(response[0]));
      } else {
        throw Exception('Booking not found');
      }
    } catch (e) {
      throw Exception('Failed to get booking info: ${e.toString()}');
    }
  }

  /// Get all notifications (bookings for driver)
  Future<List<BookingInfo>> getAllNotifications() async {
    try {
      final url = AppUrl.baseUrl + AppUrl.getAllNotifications;
      final response = await _networkService.getGetApiResponse(url);

      if (response is List) {
        return response
            .map(
              (item) => BookingInfo.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
      } else if (response is Map) {
        // Sometimes API returns single object in map
        return [BookingInfo.fromJson(Map<String, dynamic>.from(response))];
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get notifications: ${e.toString()}');
    }
  }

  /// Update driver busy status
  Future<bool> updateDriverBusyStatus() async {
    try {
      final url = AppUrl.baseUrl + AppUrl.updateDriverBusyStatus;
      final response = await _networkService.getGetApiResponse(url);
      return response is bool ? response : true;
    } catch (e) {
      throw Exception('Failed to update busy status: ${e.toString()}');
    }
  }

  // ==================== Trip Management ====================

  /// Start pickup journey
  Future<Start> startPickupJourney({required String bookingNo}) async {
    try {
      final url =
          AppUrl.baseUrl +
          AppUrl.replacePathParams(AppUrl.startPickupTrip, {'bno': bookingNo});
      final response = await _networkService.getGetApiResponse(url);

      if (response is Map) {
        return Start.fromJson(Map<String, dynamic>.from(response));
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to start pickup journey: ${e.toString()}');
    }
  }

  /// Reached pickup location
  Future<String> reachedPickupLocation({
    required String bookingNo,
    required String pickupReachDateTime,
  }) async {
    try {
      final url = AppUrl.baseUrl + AppUrl.reachedPickupLocation;
      final pickupData = PickUp(
        bookingNo: bookingNo,
        pickupReachDateTime: pickupReachDateTime,
      );
      final response = await _networkService.getPostApiResponse(
        url,
        pickupData.toJson(),
      );
      return response is String ? response : 'Success';
    } catch (e) {
      throw Exception('Failed to mark pickup reached: ${e.toString()}');
    }
  }

  /// Verify OTP
  Future<Status> verifyOTP({
    required String bookingNo,
    required String otp,
  }) async {
    try {
      final url =
          AppUrl.baseUrl +
          AppUrl.replacePathParams(AppUrl.verifyDriverOtp, {
            'bno': bookingNo,
            'otp': otp,
          });
      final response = await _networkService.getGetApiResponse(url);

      if (response is Map) {
        return Status.fromJson(Map<String, dynamic>.from(response));
      } else if (response is String) {
        return Status(status: response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  /// Start trip
  Future<StartTrip> startTrip({required TripRequest tripRequest}) async {
    try {
      final url = AppUrl.baseUrl + AppUrl.startTrip;
      final response = await _networkService.getPostApiResponse(
        url,
        tripRequest.toJson(),
      );

      if (response is Map) {
        return StartTrip.fromJson(Map<String, dynamic>.from(response));
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to start trip: ${e.toString()}');
    }
  }

  /// Reached delivery location
  Future<String> reachedDeliveryLocation({
    required String bookingNo,
    required String destinationReachDateTime,
  }) async {
    try {
      final url = AppUrl.baseUrl + AppUrl.reachedDeliveryLocation;
      final dropData = Drop(
        bookingNo: bookingNo,
        destinationReachDateTime: destinationReachDateTime,
      );
      final response = await _networkService.getPostApiResponse(
        url,
        dropData.toJson(),
      );
      return response is String ? response : 'Success';
    } catch (e) {
      throw Exception('Failed to mark delivery reached: ${e.toString()}');
    }
  }

  /// End trip
  Future<StartTrip> endTrip({required TripEnd tripEnd}) async {
    try {
      final url = AppUrl.baseUrl + AppUrl.tripEnd;
      final response = await _networkService.getPostApiResponse(
        url,
        tripEnd.toJson(),
      );

      if (response is Map) {
        return StartTrip.fromJson(Map<String, dynamic>.from(response));
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to end trip: ${e.toString()}');
    }
  }

  /// Payment received confirmation
  Future<PaymentReceived> paymentReceived({required String bookingNo}) async {
    try {
      final url =
          AppUrl.baseUrl +
          AppUrl.replacePathParams(AppUrl.paymentReceived, {'bno': bookingNo});
      final response = await _networkService.getGetApiResponse(url);

      if (response is Map) {
        return PaymentReceived.fromJson(Map<String, dynamic>.from(response));
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to confirm payment: ${e.toString()}');
    }
  }

  // ==================== Driver Status & Location ====================

  /// Update driver location
  Future<Status> updateDriverLocation({
    required String accuracy,
    required String bearing,
  }) async {
    try {
      // Get current location
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        throw Exception('Unable to get current location');
      }

      final url =
          AppUrl.baseUrl +
          AppUrl.replacePathParams(AppUrl.updateDriverLocation, {
            'acc': accuracy,
            'bear': bearing,
          });

      // Note: This endpoint requires latitude/longitude in body according to API
      // But path parameters are also required. We'll need to add body data
      final response = await _networkService.getPostApiResponse(url, {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      });

      if (response is Map) {
        return Status.fromJson(Map<String, dynamic>.from(response));
      } else if (response is String) {
        return Status(status: response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to update location: ${e.toString()}');
    }
  }

  /// Update driver duty status
  /// POST operation/driveractivity/dutystatus
  /// Body: { "isOnDuty": bool, "isInTrip": bool, "tripID": string }
  /// isOnDuty: true = ON Duty, false = OFF Duty
  /// isInTrip: true = In Trip, false = Not In Trip
  /// tripID: Current trip ID (empty string if not in trip)
  Future<String> updateDriverDutyStatus({
    required bool status, // isOnDuty
    required bool isitrd, // isInTrip
    String tripId = '', // tripID
  }) async {
    try {
      final url = AppUrl.baseUrl + AppUrl.updateDriverDutyStatus;

      // Prepare request body as per API spec
      final requestBody = {
        'isOnDuty': status, // boolean
        'isInTrip': isitrd, // boolean
        'tripID': tripId.isEmpty ? '' : tripId, // string
      };

      print('=== Update Duty Status ===');
      print('URL: $url');
      print('Request Body: $requestBody');
      print('Status: ${status ? "ON Duty" : "OFF Duty"}');
      print('In Trip: $isitrd');
      print('Trip ID: ${tripId.isEmpty ? "none" : tripId}');

      final response = await _networkService.getPostApiResponse(
        url,
        requestBody,
      );

      print('Response: $response');
      print('=== End Update Duty Status ===');

      // Response is a String according to API spec
      if (response is String) {
        return response;
      } else if (response is Map) {
        return response['message'] ?? response['status'] ?? 'Success';
      } else {
        return 'Success';
      }
    } catch (e) {
      print('❌ Error updating duty status: $e');
      throw Exception('Failed to update duty status: ${e.toString()}');
    }
  }

  // ==================== Driver Profile & Statistics ====================

  /// Get driver profile details
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

  // ==================== Vehicle & Lookup Data ====================

  /// Get vehicle group list
  Future<List<Map<String, dynamic>>> getVehicleGroupList() async {
    try {
      final url = AppUrl.baseUrl + 'master/vehiclegroup/list';
      final response = await _networkService.getGetApiResponse(url);

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get vehicle group list: ${e.toString()}');
    }
  }

  /// Get vehicle type list
  Future<List<Map<String, dynamic>>> getVehicleTypeList() async {
    try {
      final url = AppUrl.baseUrl + 'master/vehicletype/list';
      final response = await _networkService.getGetApiResponse(url);

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get vehicle type list: ${e.toString()}');
    }
  }

  /// Get rate card list
  Future<List<Map<String, dynamic>>> getRateCardList() async {
    try {
      final url = AppUrl.baseUrl + 'master/ratecard/list';
      final response = await _networkService.getGetApiResponse(url);

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get rate card list: ${e.toString()}');
    }
  }

  /// Get cargo type list
  Future<List<Map<String, dynamic>>> getCargoTypeList() async {
    try {
      final url = AppUrl.baseUrl + 'master/cargotype/list';
      final response = await _networkService.getGetApiResponse(url);

      if (response is List) {
        return response.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get cargo type list: ${e.toString()}');
    }
  }

  // ==================== Driver Verification & Status ====================

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
