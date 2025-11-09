// Trip model (for start trip request)
class TripRequest {
  final String tripDate;
  final String customerMobile;
  final String driverID;
  final String vehicleNo;
  final String vehicleType;
  final String vehicleGroup;
  final String locationFrom;
  final String locationTo;
  final String cargoDescription;
  final double latitude;
  final double longitude;
  final String bookingNo;
  final String waitingMinutes;
  final String tripMinutes;
  final String startTime;
  final String endTime;
  final String distance;
  final String totalWeight;
  final String remarks;

  TripRequest({
    required this.tripDate,
    required this.customerMobile,
    required this.driverID,
    required this.vehicleNo,
    required this.vehicleType,
    required this.vehicleGroup,
    required this.locationFrom,
    required this.locationTo,
    required this.cargoDescription,
    required this.latitude,
    required this.longitude,
    required this.bookingNo,
    required this.waitingMinutes,
    required this.tripMinutes,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.totalWeight,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'TripDate': tripDate,
      'CustomerMobile': customerMobile,
      'DriverID': driverID,
      'VehicleNo': vehicleNo,
      'VehicleType': vehicleType,
      'VehicleGroup': vehicleGroup,
      'LocationFrom': locationFrom,
      'LocationTo': locationTo,
      'CargoDescription': cargoDescription,
      'latitude': latitude,
      'longitude': longitude,
      'BookingNo': bookingNo,
      'WaitingMinutes': waitingMinutes,
      'TripMinutes': tripMinutes,
      'StartTime': startTime,
      'EndTime': endTime,
      'Distance': distance,
      'TotalWeight': totalWeight,
      'Remarks': remarks,
    };
  }
}

// StartTrip model (response from start/end trip)
class StartTrip {
  final String tripID;
  final String message;

  StartTrip({required this.tripID, required this.message});

  factory StartTrip.fromJson(Map<String, dynamic> json) {
    return StartTrip(
      tripID: json['tripID'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'tripID': tripID, 'message': message};
  }
}

// TripEnd model
class TripEnd {
  final String tripID;
  final String endTime;
  final String tripEndLat;
  final String tripEndLong;

  TripEnd({
    required this.tripID,
    required this.endTime,
    required this.tripEndLat,
    required this.tripEndLong,
  });

  Map<String, dynamic> toJson() {
    return {
      'TripID': tripID,
      'EndTime': endTime,
      'TripEndLat': tripEndLat,
      'TripEndLong': tripEndLong,
    };
  }
}

