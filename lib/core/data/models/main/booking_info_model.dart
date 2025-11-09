class BookingInfo {
  final String bookingNo;
  final String? bookingDate;
  final String? requiredDate;
  final String? customerId;
  final String? customerName;
  final String? driverId;
  final String? driverName;
  final String? vehicleNo;
  final int? vehicleType;
  final String? vehicleTypeDescription;
  final int? vehicleGroup;
  final String? locationFrom;
  final String? locationTo;
  final double? latitude;
  final double? longitude;
  final double? toLatitude;
  final double? toLongitude;
  final String? cargoDescription;
  final String? cargoType;
  final String? payLoad;
  final int? loadingUnLoading;
  final String? loadingUnLoadingDescription;
  final String? remarks;
  final bool? isConfirm;
  final String? confirmDate;
  final bool? isCancel;
  final String? cancelTime;
  final String? cancelRemarks;
  final bool? isComplete;
  final String? completeTime;
  final int? status;
  final String? otp;
  final String? invoiceNo;
  final int? invoiceAmount;
  final String? receiverMobileNo;

  BookingInfo({
    required this.bookingNo,
    this.bookingDate,
    this.requiredDate,
    this.customerId,
    this.customerName,
    this.driverId,
    this.driverName,
    this.vehicleNo,
    this.vehicleType,
    this.vehicleTypeDescription,
    this.vehicleGroup,
    this.locationFrom,
    this.locationTo,
    this.latitude,
    this.longitude,
    this.toLatitude,
    this.toLongitude,
    this.cargoDescription,
    this.cargoType,
    this.payLoad,
    this.loadingUnLoading,
    this.loadingUnLoadingDescription,
    this.remarks,
    this.isConfirm,
    this.confirmDate,
    this.isCancel,
    this.cancelTime,
    this.cancelRemarks,
    this.isComplete,
    this.completeTime,
    this.status,
    this.otp,
    this.invoiceNo,
    this.invoiceAmount,
    this.receiverMobileNo,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      bookingNo: json['BookingNo'] ?? '',
      bookingDate: json['BookingDate'],
      requiredDate: json['RequiredDate'],
      customerId: json['CustomerId'],
      customerName: json['CustomerName'],
      driverId: json['DriverId'],
      driverName: json['DriverName'],
      vehicleNo: json['VehicleNo'],
      vehicleType: json['VehicleType'] is int
          ? json['VehicleType']
          : (json['VehicleType'] != null
                ? int.tryParse(json['VehicleType'].toString())
                : null),
      vehicleTypeDescription: json['VehicleTypeDescription'],
      vehicleGroup: json['VehicleGroup'] is int
          ? json['VehicleGroup']
          : (json['VehicleGroup'] != null
                ? int.tryParse(json['VehicleGroup'].toString())
                : null),
      locationFrom: json['LocationFrom'],
      locationTo: json['LocationTo'],
      latitude: json['Latitude'] is double
          ? json['Latitude']
          : (json['Latitude'] != null
                ? double.tryParse(json['Latitude'].toString())
                : null),
      longitude: json['Longitude'] is double
          ? json['Longitude']
          : (json['Longitude'] != null
                ? double.tryParse(json['Longitude'].toString())
                : null),
      toLatitude: json['ToLatitude'] is double
          ? json['ToLatitude']
          : (json['ToLatitude'] != null
                ? double.tryParse(json['ToLatitude'].toString())
                : null),
      toLongitude: json['ToLongitude'] is double
          ? json['ToLongitude']
          : (json['ToLongitude'] != null
                ? double.tryParse(json['ToLongitude'].toString())
                : null),
      cargoDescription: json['CargoDescription'],
      cargoType: json['CargoType'],
      payLoad: json['PayLoad'],
      loadingUnLoading: json['LoadingUnLoading'] is int
          ? json['LoadingUnLoading']
          : (json['LoadingUnLoading'] != null
                ? int.tryParse(json['LoadingUnLoading'].toString())
                : null),
      loadingUnLoadingDescription: json['LoadingUnLoadingDescription'],
      remarks: json['Remarks'],
      isConfirm: json['IsConfirm'] is bool
          ? json['IsConfirm']
          : (json['IsConfirm']?.toString().toLowerCase() == 'true'),
      confirmDate: json['ConfirmDate'],
      isCancel: json['IsCancel'] is bool
          ? json['IsCancel']
          : (json['IsCancel']?.toString().toLowerCase() == 'true'),
      cancelTime: json['CancelTime'],
      cancelRemarks: json['CancelRemarks'],
      isComplete: json['IsComplete'] is bool
          ? json['IsComplete']
          : (json['IsComplete']?.toString().toLowerCase() == 'true'),
      completeTime: json['CompleteTime'],
      status: json['Status'] is int
          ? json['Status']
          : (json['Status'] != null
                ? int.tryParse(json['Status'].toString())
                : null),
      otp: json['OTP'],
      invoiceNo: json['InvoiceNo'],
      invoiceAmount: json['InvoiceAmount'] is int
          ? json['InvoiceAmount']
          : (json['InvoiceAmount'] != null
                ? int.tryParse(json['InvoiceAmount'].toString())
                : null),
      receiverMobileNo: json['ReceiverMobileNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BookingNo': bookingNo,
      'BookingDate': bookingDate,
      'RequiredDate': requiredDate,
      'CustomerId': customerId,
      'CustomerName': customerName,
      'DriverId': driverId,
      'DriverName': driverName,
      'VehicleNo': vehicleNo,
      'VehicleType': vehicleType,
      'VehicleTypeDescription': vehicleTypeDescription,
      'VehicleGroup': vehicleGroup,
      'LocationFrom': locationFrom,
      'LocationTo': locationTo,
      'Latitude': latitude,
      'Longitude': longitude,
      'ToLatitude': toLatitude,
      'ToLongitude': toLongitude,
      'CargoDescription': cargoDescription,
      'CargoType': cargoType,
      'PayLoad': payLoad,
      'LoadingUnLoading': loadingUnLoading,
      'LoadingUnLoadingDescription': loadingUnLoadingDescription,
      'Remarks': remarks,
      'IsConfirm': isConfirm,
      'ConfirmDate': confirmDate,
      'IsCancel': isCancel,
      'CancelTime': cancelTime,
      'CancelRemarks': cancelRemarks,
      'IsComplete': isComplete,
      'CompleteTime': completeTime,
      'Status': status,
      'OTP': otp,
      'InvoiceNo': invoiceNo,
      'InvoiceAmount': invoiceAmount,
      'ReceiverMobileNo': receiverMobileNo,
    };
  }
}

