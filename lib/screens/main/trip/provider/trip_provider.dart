import 'package:flutter/material.dart';
import '../../../../core/data/repositories/driver_repository.dart';
import '../../../../core/data/models/main/booking_info_model.dart';
import '../../../../core/network/network_service_impl.dart';
import '../repository/trip_repository.dart';

class TripProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  BookingInfo? _currentBooking;
  String? _currentTripId;
  String? _otp;
  bool _isTripStarted = false;
  bool _isPickupReached = false;
  bool _isDeliveryReached = false;

  late final TripRepository _repository;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  BookingInfo? get currentBooking => _currentBooking;
  String? get currentTripId => _currentTripId;
  String? get otp => _otp;
  bool get isTripStarted => _isTripStarted;
  bool get isPickupReached => _isPickupReached;
  bool get isDeliveryReached => _isDeliveryReached;

  TripProvider({TripRepository? repository}) {
    final driverRepo = DriverRepository(networkService: NetworkServiceImpl());
    _repository = repository ?? TripRepository(driverRepository: driverRepo);
  }

  /// Load booking information
  Future<void> loadBookingInfo({required String bookingNo}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentBooking = await _repository.getBookingInfo(bookingNo: bookingNo);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Accept a booking
  Future<bool> acceptBooking({
    required String bookingNo,
    required String vehicleNo,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.acceptBooking(
        bookingNo: bookingNo,
        vehicleNo: vehicleNo,
      );
      _isLoading = false;
      notifyListeners();
      return result.status.toLowerCase().contains('success') ||
          result.status.toLowerCase().contains('confirmed');
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Reject a booking
  Future<bool> rejectBooking({
    required String driverId,
    required String vehicleNo,
    required String bookingNo,
    required String cancelRemarks,
    required bool istripstarted,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.rejectBooking(
        driverId: driverId,
        vehicleNo: vehicleNo,
        bookingNo: bookingNo,
        cancelRemarks: cancelRemarks,
        istripstarted: istripstarted,
      );
      _isLoading = false;
      notifyListeners();
      return result.status.toLowerCase().contains('success');
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Start pickup journey
  Future<bool> startPickupJourney({required String bookingNo}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.startPickupJourney(bookingNo: bookingNo);
      _otp = result.otp;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Mark reached pickup location
  Future<bool> reachedPickupLocation({required String bookingNo}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.reachedPickupLocation(bookingNo: bookingNo);
      _isPickupReached = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOTP({
    required String bookingNo,
    required String otp,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.verifyOTP(
        bookingNo: bookingNo,
        otp: otp,
      );
      final isValid =
          result.status.toLowerCase().contains('success') ||
          result.status.toLowerCase().contains('valid');
      _isLoading = false;
      notifyListeners();
      return isValid;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Start trip
  Future<bool> startTrip({
    required BookingInfo bookingInfo,
    required String driverId,
    required String vehicleNo,
    String? waitingMinutes,
    String? tripMinutes,
    String? distance,
    String? totalWeight,
    String? remarks,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.startTrip(
        bookingInfo: bookingInfo,
        driverId: driverId,
        vehicleNo: vehicleNo,
        waitingMinutes: waitingMinutes,
        tripMinutes: tripMinutes,
        distance: distance,
        totalWeight: totalWeight,
        remarks: remarks,
      );
      _currentTripId = result.tripID;
      _isTripStarted = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Mark reached delivery location
  Future<bool> reachedDeliveryLocation({required String bookingNo}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.reachedDeliveryLocation(bookingNo: bookingNo);
      _isDeliveryReached = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// End trip
  Future<bool> endTrip({
    required String tripId,
    String? distance,
    String? tripMinutes,
    String? remarks,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.endTrip(
        tripId: tripId,
        distance: distance,
        tripMinutes: tripMinutes,
        remarks: remarks,
      );
      _isTripStarted = false;
      _isDeliveryReached = false;
      _isPickupReached = false;
      _currentTripId = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Confirm payment received
  Future<bool> confirmPaymentReceived({required String bookingNo}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.paymentReceived(bookingNo: bookingNo);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cancel trip
  Future<bool> cancelTrip({
    required String driverId,
    required String vehicleNo,
    required String bookingNo,
    required String cancelRemarks,
    required bool istripstarted,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.cancelTrip(
        driverId: driverId,
        vehicleNo: vehicleNo,
        bookingNo: bookingNo,
        cancelRemarks: cancelRemarks,
        istripstarted: istripstarted,
      );
      _isTripStarted = false;
      _currentTripId = null;
      _currentBooking = null;
      _isLoading = false;
      notifyListeners();
      return result.status.toLowerCase().contains('success');
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Reset trip state
  void resetTripState() {
    _currentBooking = null;
    _currentTripId = null;
    _otp = null;
    _isTripStarted = false;
    _isPickupReached = false;
    _isDeliveryReached = false;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
