import '../../../../core/data/repositories/driver_repository.dart';
import '../../../../core/data/models/main/booking_info_model.dart';
import '../../../../core/data/models/main/booking_response_models.dart';
import '../../../../core/data/models/main/trip_request_models.dart';
import '../../../../core/utils/location_service.dart';

class TripRepository {
  final DriverRepository _driverRepository;

  TripRepository({required DriverRepository driverRepository})
    : _driverRepository = driverRepository;

  /// Accept a booking
  Future<AcceptBookingStatus> acceptBooking({
    required String bookingNo,
    required String vehicleNo,
  }) async {
    return await _driverRepository.acceptBooking(
      bookingNo: bookingNo,
      vehicleNo: vehicleNo,
    );
  }

  /// Reject a booking
  Future<Status> rejectBooking({
    required String driverId,
    required String vehicleNo,
    required String bookingNo,
    required String cancelRemarks,
    required bool istripstarted,
  }) async {
    return await _driverRepository.rejectBooking(
      driverId: driverId,
      vehicleNo: vehicleNo,
      bookingNo: bookingNo,
      cancelRemarks: cancelRemarks,
      istripstarted: istripstarted,
    );
  }

  /// Get booking information
  Future<BookingInfo> getBookingInfo({required String bookingNo}) async {
    return await _driverRepository.getBookingInfo(bookingNo: bookingNo);
  }

  /// Start pickup journey
  Future<Start> startPickupJourney({required String bookingNo}) async {
    return await _driverRepository.startPickupJourney(bookingNo: bookingNo);
  }

  /// Mark reached pickup location
  Future<String> reachedPickupLocation({required String bookingNo}) async {
    final now = DateTime.now();
    final dateTime =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    return await _driverRepository.reachedPickupLocation(
      bookingNo: bookingNo,
      pickupReachDateTime: dateTime,
    );
  }

  /// Verify OTP
  Future<Status> verifyOTP({
    required String bookingNo,
    required String otp,
  }) async {
    return await _driverRepository.verifyOTP(bookingNo: bookingNo, otp: otp);
  }

  /// Start trip
  Future<StartTrip> startTrip({
    required BookingInfo bookingInfo,
    required String driverId,
    required String vehicleNo,
    String? waitingMinutes,
    String? tripMinutes,
    String? distance,
    String? totalWeight,
    String? remarks,
  }) async {
    // Get current location
    final position = await LocationService.getCurrentPosition();
    if (position == null) {
      throw Exception('Unable to get current location');
    }

    final now = DateTime.now();
    final tripDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final startTime =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final tripRequest = TripRequest(
      tripDate: tripDate,
      customerMobile: bookingInfo.receiverMobileNo ?? '',
      driverID: driverId,
      vehicleNo: vehicleNo,
      vehicleType: bookingInfo.vehicleType?.toString() ?? '',
      vehicleGroup: bookingInfo.vehicleGroup?.toString() ?? '',
      locationFrom: bookingInfo.locationFrom ?? '',
      locationTo: bookingInfo.locationTo ?? '',
      cargoDescription: bookingInfo.cargoDescription ?? '',
      latitude: position.latitude,
      longitude: position.longitude,
      bookingNo: bookingInfo.bookingNo,
      waitingMinutes: waitingMinutes ?? '0',
      tripMinutes: tripMinutes ?? '0',
      startTime: startTime,
      endTime: '',
      distance: distance ?? '0',
      totalWeight: totalWeight ?? '0',
      remarks: remarks ?? '',
    );

    return await _driverRepository.startTrip(tripRequest: tripRequest);
  }

  /// Mark reached delivery location
  Future<String> reachedDeliveryLocation({required String bookingNo}) async {
    final now = DateTime.now();
    final dateTime =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    return await _driverRepository.reachedDeliveryLocation(
      bookingNo: bookingNo,
      destinationReachDateTime: dateTime,
    );
  }

  /// End trip
  Future<StartTrip> endTrip({
    required String tripId,
    String? distance,
    String? tripMinutes,
    String? remarks,
  }) async {
    // Get current location
    final position = await LocationService.getCurrentPosition();
    if (position == null) {
      throw Exception('Unable to get current location');
    }

    final now = DateTime.now();
    final endTime =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final tripEnd = TripEnd(
      tripID: tripId,
      endTime: endTime,
      tripEndLat: position.latitude.toString(),
      tripEndLong: position.longitude.toString(),
    );

    return await _driverRepository.endTrip(tripEnd: tripEnd);
  }

  /// Confirm payment received
  Future<PaymentReceived> paymentReceived({required String bookingNo}) async {
    return await _driverRepository.paymentReceived(bookingNo: bookingNo);
  }

  /// Cancel trip
  Future<Status> cancelTrip({
    required String driverId,
    required String vehicleNo,
    required String bookingNo,
    required String cancelRemarks,
    required bool istripstarted,
  }) async {
    return await _driverRepository.cancelTrip(
      driverId: driverId,
      vehicleNo: vehicleNo,
      bookingNo: bookingNo,
      cancelRemarks: cancelRemarks,
      istripstarted: istripstarted,
    );
  }
}
