import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/network/network_service_impl.dart';
import '../repository/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  bool _isOnDuty = false;
  bool _isLoading = false;
  bool _isInTrip = false;
  String _tripId = '';
  Map<String, double>? _currentLocation;
  List<Map<String, dynamic>> _nearbyLocations = [];
  String? _errorMessage;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  CameraPosition? _initialCameraPosition;

  late final HomeRepository _repository;

  bool get isOnDuty => _isOnDuty;
  bool get isLoading => _isLoading;
  bool get isInTrip => _isInTrip;
  String get tripId => _tripId;
  Map<String, double>? get currentLocation => _currentLocation;
  List<Map<String, dynamic>> get nearbyLocations => _nearbyLocations;
  String? get errorMessage => _errorMessage;
  GoogleMapController? get mapController => _mapController;
  Set<Marker> get markers => _markers;
  CameraPosition? get initialCameraPosition => _initialCameraPosition;

  HomeProvider({HomeRepository? repository}) {
    _repository =
        repository ?? HomeRepository(networkService: NetworkServiceImpl());
    // Set default initial camera position immediately
    _initialCameraPosition = const CameraPosition(
      target: LatLng(17.3850, 78.4867), // Hyderabad default
      zoom: 12.0,
    );
  }

  Future<void> initializeMap() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get current location
      final locationResult = await _repository.getCurrentLocation();
      if (locationResult['success'] == true) {
        final locationData = locationResult['data'];
        final lat = locationData['latitude']?.toDouble() ?? 0.0;
        final lng = locationData['longitude']?.toDouble() ?? 0.0;

        _currentLocation = {'latitude': lat, 'longitude': lng};

        // Set initial camera position to current location
        if (lat != 0.0 && lng != 0.0) {
          _initialCameraPosition = CameraPosition(
            target: LatLng(lat, lng),
            zoom: 14.0,
          );
          print('✅ Map initialized with current location: $lat, $lng');
        } else {
          print('⚠️ Location coordinates are 0.0, using default position');
        }
      } else {
        print('⚠️ Location fetch failed, using default position');
        // Keep default position that was set in constructor
      }

      // Get notifications/bookings
      try {
        final notifications = await _repository.getAllNotifications();
        _nearbyLocations = notifications.cast<Map<String, dynamic>>();
        print('✅ Loaded ${_nearbyLocations.length} nearby locations');
      } catch (e) {
        print('⚠️ Failed to load notifications: $e');
        _nearbyLocations = [];
      }

      // Build markers for nearby locations
      _buildMarkers();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('❌ Error initializing map: $_errorMessage');
      _isLoading = false;
      // Ensure we still have a camera position even on error
      if (_initialCameraPosition == null) {
        _initialCameraPosition = const CameraPosition(
          target: LatLng(17.3850, 78.4867),
          zoom: 12.0,
        );
      }
      notifyListeners();
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void _buildMarkers() {
    _markers.clear();

    // Add current location marker if available
    if (_currentLocation != null) {
      final lat = _currentLocation!['latitude']!;
      final lng = _currentLocation!['longitude']!;

      if (lat != 0.0 && lng != 0.0) {
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: const InfoWindow(
              title: 'Your Location',
              snippet: 'Current driver location',
            ),
          ),
        );
      }
    }

    // Add markers for nearby locations/bookings
    for (var i = 0; i < _nearbyLocations.length; i++) {
      final location = _nearbyLocations[i];
      final lat = location['latitude']?.toDouble();
      final lng = location['longitude']?.toDouble();

      if (lat != null && lng != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('location_$i'),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: location['name']?.toString() ?? 'Location',
              snippet: location['address']?.toString() ?? '',
            ),
          ),
        );
      }
    }
  }

  Future<void> toggleDutyStatus() async {
    if (_isLoading) return; // Prevent multiple simultaneous calls

    _isLoading = true;
    _errorMessage = null;
    final oldStatus = _isOnDuty;
    final newStatus = !_isOnDuty;

    // Optimistically update UI
    _isOnDuty = newStatus;
    notifyListeners();

    try {
      final result = await _repository.updateDutyStatus(
        isOnDuty: newStatus,
        isInTrip: _isInTrip,
        tripId: _tripId,
      );

      if (result['success'] == true) {
        // Success - status already updated optimistically
        print(
          '✅ Duty status updated successfully: ${newStatus ? "ON Duty" : "OFF Duty"}',
        );
      } else {
        // Revert on failure
        _isOnDuty = oldStatus;
        _errorMessage = result['message'] ?? 'Failed to update duty status';
        print('❌ Duty status update failed: ${_errorMessage}');
      }
    } catch (e) {
      // Revert on error
      _isOnDuty = oldStatus;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('❌ Error toggling duty status: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> centerMapOnLocation() async {
    try {
      if (_mapController != null && _currentLocation != null) {
        final lat = _currentLocation!['latitude']!;
        final lng = _currentLocation!['longitude']!;

        if (lat != 0.0 && lng != 0.0) {
          await _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(lat, lng), zoom: 14.0),
            ),
          );
        }
      }
    } catch (e) {
      print('Error centering map: $e');
    }
  }

  Future<void> refreshNearbyLocations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final notifications = await _repository.getAllNotifications();
      _nearbyLocations = notifications.cast<Map<String, dynamic>>();
      _buildMarkers(); // Rebuild markers with new locations
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> updateLocation() async {
    try {
      final position = _currentLocation;
      if (position != null) {
        await _repository.updateDriverLocation(
          accuracy: '10.0',
          bearing: '0.0',
        );
      }
    } catch (e) {
      // Silently fail for location updates
      print('Failed to update location: $e');
    }
  }

  void setTripStatus({required bool isInTrip, String tripId = ''}) {
    _isInTrip = isInTrip;
    _tripId = tripId;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.logout();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
