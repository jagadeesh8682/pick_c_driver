import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  bool _isOnDuty = false;
  bool _isLoading = false;
  Map<String, double>? _currentLocation;
  List<Map<String, dynamic>> _nearbyLocations = [];

  bool get isOnDuty => _isOnDuty;
  bool get isLoading => _isLoading;
  Map<String, double>? get currentLocation => _currentLocation;
  List<Map<String, dynamic>> get nearbyLocations => _nearbyLocations;

  Future<void> initializeMap() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate map initialization
      await Future.delayed(const Duration(seconds: 1));

      // Mock current location
      _currentLocation = {'latitude': 17.3850, 'longitude': 78.4867};

      // Mock nearby locations
      _nearbyLocations = [
        {
          'id': '1',
          'name': 'Heart Cup Coffee, Kondapur',
          'type': 'cafe',
          'latitude': 17.3840,
          'longitude': 78.4850,
          'distance': 0.5,
        },
        {
          'id': '2',
          'name': 'TCS Kohinoor Park',
          'type': 'office',
          'latitude': 17.3860,
          'longitude': 78.4870,
          'distance': 0.8,
        },
        {
          'id': '3',
          'name': 'WeWork Krishe Emerald - Coworking',
          'type': 'coworking',
          'latitude': 17.3830,
          'longitude': 78.4880,
          'distance': 1.2,
        },
        {
          'id': '4',
          'name': 'Trendset Elevate',
          'type': 'building',
          'latitude': 17.3870,
          'longitude': 78.4850,
          'distance': 0.9,
        },
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      // Handle error
    }
  }

  void toggleDutyStatus() {
    _isOnDuty = !_isOnDuty;
    notifyListeners();

    // TODO: Send API call to update duty status
    // _apiService.updateDutyStatus(isOnDuty: _isOnDuty);

    // Show feedback message
    print('Driver is now ${_isOnDuty ? "On Duty" : "Off Duty"}');
  }

  Future<void> centerMapOnLocation() async {
    try {
      // TODO: Implement map centering logic
      // This would typically interact with Google Maps or other map service
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> refreshNearbyLocations() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock refresh - in real app, this would fetch new locations
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      // Handle error
    }
  }

  Future<void> logout() async {
    try {
      // TODO: Implement logout logic
      // Clear local storage, invalidate tokens, etc.
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      // Handle error
    }
  }
}
