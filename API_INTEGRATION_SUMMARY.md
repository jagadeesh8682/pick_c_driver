# API Integration Summary

## Overview
All driver API endpoints from the PickC Driver API documentation have been integrated into the Flutter application. The integration follows a clean architecture pattern with repositories, providers, and data models.

## What Was Implemented

### 1. Data Models Created
All API request/response models have been created:

**Location**: `lib/core/data/models/main/`
- `booking_info_model.dart` - BookingInfo model
- `booking_response_models.dart` - AcceptBookingStatus, Status, Reject, Start, PickUp, Drop, PaymentReceived
- `trip_request_models.dart` - TripRequest, StartTrip, TripEnd
- `driver_profile_model.dart` - DriverProfile, DriverTrip, DriverStatus
- `driver_stats_model.dart` - Already existed, used for statistics
- `trip_model.dart` - Already existed, used for trip management

### 2. Core Repository - DriverRepository
**Location**: `lib/core/data/repositories/driver_repository.dart`

This is the main repository that handles all driver-related API calls:

#### Authentication APIs
- ✅ `saveDeviceId()` - Register device ID for push notifications
- ✅ `logout()` - Driver logout

#### Booking Management APIs
- ✅ `acceptBooking()` - Accept a booking request
- ✅ `rejectBooking()` - Reject a booking request
- ✅ `cancelTrip()` - Cancel an ongoing trip
- ✅ `getBookingInfo()` - Get detailed booking information
- ✅ `getAllNotifications()` - Get all booking notifications for driver
- ✅ `updateDriverBusyStatus()` - Update driver's busy/available status

#### Trip Management APIs
- ✅ `startPickupJourney()` - Start journey to pickup location
- ✅ `reachedPickupLocation()` - Mark arrival at pickup location
- ✅ `verifyOTP()` - Verify customer OTP
- ✅ `startTrip()` - Start the actual trip after pickup
- ✅ `reachedDeliveryLocation()` - Mark arrival at delivery location
- ✅ `endTrip()` - Complete and end the trip
- ✅ `paymentReceived()` - Confirm payment received from customer

#### Driver Status & Location APIs
- ✅ `updateDriverLocation()` - Update driver's current location in real-time
- ✅ `updateDriverDutyStatus()` - Update driver on/off duty status

### 3. Screen-Specific Repositories

#### HomeRepository
**Location**: `lib/screens/main/home/repository/home_repository.dart`
- ✅ `getCurrentLocation()` - Get driver's current location using LocationService
- ✅ `updateDutyStatus()` - Toggle driver duty status (on/off duty)
- ✅ `updateDriverLocation()` - Update driver location to server
- ✅ `getAllNotifications()` - Fetch all booking notifications
- ✅ `logout()` - Logout driver

#### TripRepository
**Location**: `lib/screens/main/trip/repository/trip_repository.dart`
A high-level repository that wraps DriverRepository for trip-specific operations:
- ✅ `acceptBooking()` - Accept booking
- ✅ `rejectBooking()` - Reject booking
- ✅ `getBookingInfo()` - Get booking details
- ✅ `startPickupJourney()` - Start pickup journey
- ✅ `reachedPickupLocation()` - Mark pickup reached
- ✅ `verifyOTP()` - Verify OTP before starting trip
- ✅ `startTrip()` - Start trip with all trip details
- ✅ `reachedDeliveryLocation()` - Mark delivery reached
- ✅ `endTrip()` - End trip
- ✅ `paymentReceived()` - Confirm payment
- ✅ `cancelTrip()` - Cancel trip

#### LoginRepository
**Location**: `lib/screens/auth/login/repository/login_repository.dart`
- ✅ `login()` - Driver login (already implemented)
- ✅ `logout()` - Updated to use real API

### 4. Updated Providers

#### HomeProvider
**Location**: `lib/screens/main/home/provider/home_provider.dart`
- ✅ Integrated with HomeRepository for real API calls
- ✅ `initializeMap()` - Now fetches real location and notifications
- ✅ `toggleDutyStatus()` - Updates duty status via API
- ✅ `refreshNearbyLocations()` - Fetches notifications from API
- ✅ `updateLocation()` - Updates driver location
- ✅ `logout()` - Logs out via API

## API Endpoints Used

### Base URL
```
http://api.pickcargo.in/api/
```

### All Integrated Endpoints

1. **POST** `operation/driveractivity/login` - Driver login
2. **GET** `operation/driveractivity/logout` - Driver logout
3. **POST** `master/driver/deviceid` - Save device ID
4. **GET** `operation/driveractivity/{bno}/{vno}` - Accept booking
5. **POST** `operation/booking/Reject` - Reject booking
6. **POST** `operation/booking/cancel` - Cancel trip
7. **GET** `master/customer/booking/{bno}` - Get booking info
8. **GET** `operation/booking/driver` - Get all notifications
9. **GET** `operation/booking/UpdateDriverBusyStatus` - Update busy status
10. **GET** `operation/booking/PickupTripStartbyBookingNo/{bno}` - Start pickup journey
11. **POST** `operation/booking/pickupreachdatetime` - Reached pickup location
12. **GET** `operation/driveractivity/checkOTP/{bno}/{otp}` - Verify OTP
13. **POST** `operation/trip/start` - Start trip
14. **POST** `operation/booking/destinationreachdatetime` - Reached delivery location
15. **POST** `operation/trip/end` - End trip
16. **GET** `operation/booking/DriverReceivedConfirm/{bno}` - Payment received
17. **POST** `operation/driveractivity/UpdateDriverCurrentLocation/{acc}/{bear}/` - Update location
18. **GET** `operation/driveractivity/dutystatus/{status}/{isitrd}/{tripId}` - Update duty status

## Usage Examples

### Using DriverRepository Directly

```dart
import 'package:your_app/core/data/repositories/driver_repository.dart';
import 'package:your_app/core/network/network_service_impl.dart';

final driverRepo = DriverRepository(
  networkService: NetworkServiceImpl()
);

// Accept a booking
final result = await driverRepo.acceptBooking(
  bookingNo: 'BK123456',
  vehicleNo: 'VEH123',
);

// Get all notifications
final notifications = await driverRepo.getAllNotifications();

// Update driver location
final status = await driverRepo.updateDriverLocation(
  accuracy: '10.0',
  bearing: '0.0',
);
```

### Using TripRepository

```dart
import 'package:your_app/screens/main/trip/repository/trip_repository.dart';
import 'package:your_app/core/data/repositories/driver_repository.dart';

final tripRepo = TripRepository(
  driverRepository: DriverRepository(networkService: NetworkServiceImpl())
);

// Start pickup journey
final startResult = await tripRepo.startPickupJourney(
  bookingNo: 'BK123456',
);

// Verify OTP
final otpStatus = await tripRepo.verifyOTP(
  bookingNo: 'BK123456',
  otp: '1234',
);

// Start trip
final tripStart = await tripRepo.startTrip(
  bookingInfo: bookingInfo,
  driverId: 'DRV123',
  vehicleNo: 'VEH123',
);
```

### Using in Provider (HomeProvider Example)

```dart
final homeProvider = HomeProvider();

// Initialize and fetch data
await homeProvider.initializeMap();

// Toggle duty status
await homeProvider.toggleDutyStatus();

// Refresh notifications
await homeProvider.refreshNearbyLocations();
```

## Error Handling

All repositories include comprehensive error handling:
- Network errors are caught and wrapped in descriptive exceptions
- Invalid response formats are handled gracefully
- Location service failures are handled appropriately

## Authentication

All authenticated endpoints automatically include the token from SharedPreferences via NetworkServiceImpl's `_buildHeaders()` method.

## Date/Time Format

The API expects dates in format: `dd/MM/yyyy HH:mm:ss`
- TripRepository handles date formatting automatically
- Uses Dart's DateTime formatting without external dependencies

## Next Steps

1. **UI Integration**: Connect these repositories to your UI screens
2. **Background Location Updates**: Implement periodic location updates while driver is on duty
3. **Push Notifications**: Integrate FCM device token registration with `saveDeviceId()`
4. **Trip Management Screens**: Create UI screens for trip flow (accept, start, end, etc.)
5. **Error UI**: Add proper error handling UI for failed API calls
6. **Loading States**: Use provider loading states in UI

## Testing

To test the integration:
1. Ensure you have a valid driver account
2. Test login with `LoginRepository.login()`
3. Verify token is stored in SharedPreferences
4. Test duty status toggle
5. Test booking acceptance/rejection
6. Test trip flow (start, verify OTP, end)

## Notes

- All API endpoints are relative to base URL defined in `AppUrl.baseUrl`
- Path parameters are replaced using `AppUrl.replacePathParams()`
- The network service automatically adds authentication headers when available
- Location updates use `LocationService` which handles permissions internally


