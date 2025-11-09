import '../../../../core/network/network_service.dart';
import '../../../../core/utils/location_service.dart';
import '../../../../core/data/repositories/driver_repository.dart';

class HomeRepository {
  final DriverRepository _driverRepository;

  HomeRepository({
    required NetworkService networkService,
    DriverRepository? driverRepository,
  }) : _driverRepository =
           driverRepository ?? DriverRepository(networkService: networkService);

  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        throw Exception('Unable to get current location');
      }

      return {
        'success': true,
        'data': {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'timestamp': DateTime.now().toIso8601String(),
        },
      };
    } catch (e) {
      throw Exception('Failed to get current location: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateDutyStatus({
    required bool isOnDuty,
    required bool isInTrip,
    String tripId = '',
  }) async {
    try {
      final response = await _driverRepository.updateDriverDutyStatus(
        status: isOnDuty, // true = ON Duty, false = OFF Duty
        isitrd: isInTrip, // true = In Trip, false = Not In Trip
        tripId: tripId.isEmpty ? '' : tripId,
      );

      return {
        'success': true,
        'message': response,
        'data': {
          'isOnDuty': isOnDuty,
          'isInTrip': isInTrip,
          'tripId': tripId,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      };
    } catch (e) {
      throw Exception('Failed to update duty status: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateDriverLocation({
    String accuracy = '10.0',
    String bearing = '0.0',
  }) async {
    try {
      final response = await _driverRepository.updateDriverLocation(
        accuracy: accuracy,
        bearing: bearing,
      );

      return {'success': true, 'message': response.status};
    } catch (e) {
      throw Exception('Failed to update location: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getAllNotifications() async {
    try {
      final bookings = await _driverRepository.getAllNotifications();
      return bookings.map((b) => b.toJson()).toList();
    } catch (e) {
      throw Exception('Failed to get notifications: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radius = 5.0, // km
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiService.get('/locations/nearby', queryParameters: {
      //   'latitude': latitude,
      //   'longitude': longitude,
      //   'radius': radius,
      // });
      // return response.data;

      // Mock response for now
      await Future.delayed(const Duration(seconds: 1));

      return {
        'success': true,
        'data': [
          {
            'id': '1',
            'name': 'Heart Cup Coffee, Kondapur',
            'type': 'cafe',
            'latitude': 17.3840,
            'longitude': 78.4850,
            'distance': 0.5,
            'address': 'Kondapur, Hyderabad',
            'rating': 4.2,
            'isOpen': true,
          },
          {
            'id': '2',
            'name': 'TCS Kohinoor Park',
            'type': 'office',
            'latitude': 17.3860,
            'longitude': 78.4870,
            'distance': 0.8,
            'address': 'Kohinoor Park, Hyderabad',
            'rating': 4.5,
            'isOpen': true,
          },
          {
            'id': '3',
            'name': 'WeWork Krishe Emerald - Coworking',
            'type': 'coworking',
            'latitude': 17.3830,
            'longitude': 78.4880,
            'distance': 1.2,
            'address': 'Krishe Emerald, Hyderabad',
            'rating': 4.3,
            'isOpen': true,
          },
          {
            'id': '4',
            'name': 'Trendset Elevate',
            'type': 'building',
            'latitude': 17.3870,
            'longitude': 78.4850,
            'distance': 0.9,
            'address': 'Elevate Building, Hyderabad',
            'rating': 4.0,
            'isOpen': true,
          },
        ],
      };
    } catch (e) {
      throw Exception('Failed to get nearby locations: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await _driverRepository.logout();
      return {'success': true, 'message': 'Logged out successfully'};
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
}
