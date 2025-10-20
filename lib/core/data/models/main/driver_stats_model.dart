class DriverStats {
  final String driverId;
  final int totalTrips;
  final int completedTrips;
  final int cancelledTrips;
  final double totalEarnings;
  final double todayEarnings;
  final double weeklyEarnings;
  final double monthlyEarnings;
  final double averageRating;
  final int totalHours;
  final DateTime lastUpdated;

  DriverStats({
    required this.driverId,
    required this.totalTrips,
    required this.completedTrips,
    required this.cancelledTrips,
    required this.totalEarnings,
    required this.todayEarnings,
    required this.weeklyEarnings,
    required this.monthlyEarnings,
    required this.averageRating,
    required this.totalHours,
    required this.lastUpdated,
  });

  factory DriverStats.fromJson(Map<String, dynamic> json) {
    return DriverStats(
      driverId: json['driverId'] ?? '',
      totalTrips: json['totalTrips'] ?? 0,
      completedTrips: json['completedTrips'] ?? 0,
      cancelledTrips: json['cancelledTrips'] ?? 0,
      totalEarnings: (json['totalEarnings'] ?? 0.0).toDouble(),
      todayEarnings: (json['todayEarnings'] ?? 0.0).toDouble(),
      weeklyEarnings: (json['weeklyEarnings'] ?? 0.0).toDouble(),
      monthlyEarnings: (json['monthlyEarnings'] ?? 0.0).toDouble(),
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalHours: json['totalHours'] ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'totalTrips': totalTrips,
      'completedTrips': completedTrips,
      'cancelledTrips': cancelledTrips,
      'totalEarnings': totalEarnings,
      'todayEarnings': todayEarnings,
      'weeklyEarnings': weeklyEarnings,
      'monthlyEarnings': monthlyEarnings,
      'averageRating': averageRating,
      'totalHours': totalHours,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  double get completionRate => totalTrips > 0 ? (completedTrips / totalTrips) * 100 : 0.0;
  double get cancellationRate => totalTrips > 0 ? (cancelledTrips / totalTrips) * 100 : 0.0;
  double get averageEarningsPerTrip => completedTrips > 0 ? totalEarnings / completedTrips : 0.0;
}
