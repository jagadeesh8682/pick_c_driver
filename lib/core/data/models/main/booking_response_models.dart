// AcceptBookingStatus model
class AcceptBookingStatus {
  final String status;

  AcceptBookingStatus({required this.status});

  factory AcceptBookingStatus.fromJson(Map<String, dynamic> json) {
    return AcceptBookingStatus(status: json['status'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'status': status};
  }
}

// Status model
class Status {
  final String status;

  Status({required this.status});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(status: json['Status'] ?? json['status'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'Status': status};
  }
}

// Reject model (used for reject and cancel booking)
class Reject {
  final String driverId;
  final String vehicleNo;
  final String bookingNo;
  final String cancelRemarks;
  final bool istripstarted;

  Reject({
    required this.driverId,
    required this.vehicleNo,
    required this.bookingNo,
    required this.cancelRemarks,
    required this.istripstarted,
  });

  Map<String, dynamic> toJson() {
    return {
      'DriverId': driverId,
      'VehicleNo': vehicleNo,
      'BookingNo': bookingNo,
      'CancelRemarks': cancelRemarks,
      'istripstarted': istripstarted,
    };
  }
}

// Start model (response from start pickup journey)
class Start {
  final String bookingNo;
  final String otp;

  Start({required this.bookingNo, required this.otp});

  factory Start.fromJson(Map<String, dynamic> json) {
    return Start(bookingNo: json['BookingNo'] ?? '', otp: json['OTP'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'BookingNo': bookingNo, 'OTP': otp};
  }
}

// PickUp model
class PickUp {
  final String bookingNo;
  final String pickupReachDateTime;

  PickUp({required this.bookingNo, required this.pickupReachDateTime});

  Map<String, dynamic> toJson() {
    return {'bookingNo': bookingNo, 'PickupReachDateTime': pickupReachDateTime};
  }
}

// Drop model
class Drop {
  final String bookingNo;
  final String destinationReachDateTime;

  Drop({required this.bookingNo, required this.destinationReachDateTime});

  Map<String, dynamic> toJson() {
    return {
      'bookingNo': bookingNo,
      'DestinationReachDateTime': destinationReachDateTime,
    };
  }
}

// PaymentReceived model
class PaymentReceived {
  final String notifyDriverpaymentReceived;

  PaymentReceived({required this.notifyDriverpaymentReceived});

  factory PaymentReceived.fromJson(Map<String, dynamic> json) {
    return PaymentReceived(
      notifyDriverpaymentReceived: json['NotifyDriverpaymentReceived'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'NotifyDriverpaymentReceived': notifyDriverpaymentReceived};
  }
}

