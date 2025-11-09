class DriverProfile {
  final String driverID;
  final String? driverName;
  final String? password;
  final String? vehicleNo;
  final String? vehicleType;
  final String? vehicleGroup;
  final String? fatherName;
  final String? dateOfBirth;
  final String? placeOfBirth;
  final int? gender;
  final String? genderDescription;
  final int? maritialStatus;
  final String? maritialStatusDescription;
  final String? mobileNo;
  final String? phoneNo;
  final String? panNo;
  final String? aadharCardNo;
  final String? licenseNo;
  final bool? acceptBookingStatus;
  final String? createdBy;
  final String? createdOn;
  final String? modifiedBy;
  final String? modifiedOn;
  final bool? isVerified;
  final String? verifiedBy;
  final String? verifiedOn;
  final String? deviceID;
  final List<dynamic>? addressList;
  final dynamic nationality;
  final dynamic operatorID;
  final dynamic bankDetails;

  DriverProfile({
    required this.driverID,
    this.driverName,
    this.password,
    this.vehicleNo,
    this.vehicleType,
    this.vehicleGroup,
    this.fatherName,
    this.dateOfBirth,
    this.placeOfBirth,
    this.gender,
    this.genderDescription,
    this.maritialStatus,
    this.maritialStatusDescription,
    this.mobileNo,
    this.phoneNo,
    this.panNo,
    this.aadharCardNo,
    this.licenseNo,
    this.acceptBookingStatus,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.isVerified,
    this.verifiedBy,
    this.verifiedOn,
    this.deviceID,
    this.addressList,
    this.nationality,
    this.operatorID,
    this.bankDetails,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      driverID: json['DriverID'] ?? '',
      driverName: json['DriverName'],
      password: json['Password'],
      vehicleNo: json['VehicleNo'],
      vehicleType: json['VehicleType'],
      vehicleGroup: json['VehicleGroup'],
      fatherName: json['FatherName'],
      dateOfBirth: json['DateOfBirth'],
      placeOfBirth: json['PlaceOfBirth'],
      gender: json['Gender'] is int
          ? json['Gender']
          : (json['Gender'] != null
                ? int.tryParse(json['Gender'].toString())
                : null),
      genderDescription: json['GenderDescription'],
      maritialStatus: json['MaritialStatus'] is int
          ? json['MaritialStatus']
          : (json['MaritialStatus'] != null
                ? int.tryParse(json['MaritialStatus'].toString())
                : null),
      maritialStatusDescription: json['MaritialStatusDescription'],
      mobileNo: json['MobileNo'],
      phoneNo: json['PhoneNo'],
      panNo: json['PANNo'],
      aadharCardNo: json['AadharCardNo'],
      licenseNo: json['LicenseNo'],
      acceptBookingStatus: json['AcceptBookingStatus'] is bool
          ? json['AcceptBookingStatus']
          : (json['AcceptBookingStatus']?.toString().toLowerCase() == 'true'),
      createdBy: json['CreatedBy'],
      createdOn: json['CreatedOn'],
      modifiedBy: json['ModifiedBy'],
      modifiedOn: json['ModifiedOn'],
      isVerified: json['IsVerified'] is bool
          ? json['IsVerified']
          : (json['IsVerified']?.toString().toLowerCase() == 'true'),
      verifiedBy: json['VerifiedBy'],
      verifiedOn: json['VerifiedOn'],
      deviceID: json['DeviceID'],
      addressList: json['AddressList'],
      nationality: json['Nationality'],
      operatorID: json['OperatorID'],
      bankDetails: json['BankDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DriverID': driverID,
      'DriverName': driverName,
      'Password': password,
      'VehicleNo': vehicleNo,
      'VehicleType': vehicleType,
      'VehicleGroup': vehicleGroup,
      'FatherName': fatherName,
      'DateOfBirth': dateOfBirth,
      'PlaceOfBirth': placeOfBirth,
      'Gender': gender,
      'GenderDescription': genderDescription,
      'MaritialStatus': maritialStatus,
      'MaritialStatusDescription': maritialStatusDescription,
      'MobileNo': mobileNo,
      'PhoneNo': phoneNo,
      'PANNo': panNo,
      'AadharCardNo': aadharCardNo,
      'LicenseNo': licenseNo,
      'AcceptBookingStatus': acceptBookingStatus,
      'CreatedBy': createdBy,
      'CreatedOn': createdOn,
      'ModifiedBy': modifiedBy,
      'ModifiedOn': modifiedOn,
      'IsVerified': isVerified,
      'VerifiedBy': verifiedBy,
      'VerifiedOn': verifiedOn,
      'DeviceID': deviceID,
      'AddressList': addressList,
      'Nationality': nationality,
      'OperatorID': operatorID,
      'BankDetails': bankDetails,
    };
  }
}

// DriverTrip model
class DriverTrip {
  final bool isintrip;
  final String? tripid;
  final String? bookingno;
  final bool? isOnDuty;
  final String? message;

  DriverTrip({
    required this.isintrip,
    this.tripid,
    this.bookingno,
    this.isOnDuty,
    this.message,
  });

  factory DriverTrip.fromJson(Map<String, dynamic> json) {
    return DriverTrip(
      isintrip: json['isintrip'] is bool
          ? json['isintrip']
          : (json['isintrip']?.toString().toLowerCase() == 'true'),
      tripid: json['tripid'],
      bookingno: json['bookingno'],
      isOnDuty: json['isOnDuty'] is bool
          ? json['isOnDuty']
          : (json['isOnDuty']?.toString().toLowerCase() == 'true'),
      message: json['Message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isintrip': isintrip,
      'tripid': tripid,
      'bookingno': bookingno,
      'isOnDuty': isOnDuty,
      'Message': message,
    };
  }
}

// DriverStatus model
class DriverStatus {
  final String? bookingNo;
  final String? message;

  DriverStatus({this.bookingNo, this.message});

  factory DriverStatus.fromJson(Map<String, dynamic> json) {
    return DriverStatus(bookingNo: json['BookingNo'], message: json['Message']);
  }

  Map<String, dynamic> toJson() {
    return {'BookingNo': bookingNo, 'Message': message};
  }
}

