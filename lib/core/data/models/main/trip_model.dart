class Trip {
  final String id;
  final String driverId;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String pickupLocation;
  final String dropoffLocation;
  final double fare;
  final String status; // pending, accepted, started, completed, cancelled
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double? rating;
  final String? feedback;
  final Map<String, double>? pickupCoordinates;
  final Map<String, double>? dropoffCoordinates;

  Trip({
    required this.id,
    required this.driverId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.rating,
    this.feedback,
    this.pickupCoordinates,
    this.dropoffCoordinates,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] ?? '',
      driverId: json['driverId'] ?? '',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      dropoffLocation: json['dropoffLocation'] ?? '',
      fare: (json['fare'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      rating: json['rating']?.toDouble(),
      feedback: json['feedback'],
      pickupCoordinates: json['pickupCoordinates'] != null 
          ? Map<String, double>.from(json['pickupCoordinates'])
          : null,
      dropoffCoordinates: json['dropoffCoordinates'] != null 
          ? Map<String, double>.from(json['dropoffCoordinates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'fare': fare,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'rating': rating,
      'feedback': feedback,
      'pickupCoordinates': pickupCoordinates,
      'dropoffCoordinates': dropoffCoordinates,
    };
  }

  Trip copyWith({
    String? id,
    String? driverId,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? pickupLocation,
    String? dropoffLocation,
    double? fare,
    String? status,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    double? rating,
    String? feedback,
    Map<String, double>? pickupCoordinates,
    Map<String, double>? dropoffCoordinates,
  }) {
    return Trip(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      fare: fare ?? this.fare,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
      pickupCoordinates: pickupCoordinates ?? this.pickupCoordinates,
      dropoffCoordinates: dropoffCoordinates ?? this.dropoffCoordinates,
    );
  }

  bool get isActive => status == 'accepted' || status == 'started';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isPending => status == 'pending';
}


