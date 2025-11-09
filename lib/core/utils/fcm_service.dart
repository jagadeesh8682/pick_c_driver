import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMService {
  static const String _fcmTokenKey = 'fcm_token';
  static FirebaseMessaging? _firebaseMessaging;

  /// Initialize Firebase Cloud Messaging
  static Future<void> initialize() async {
    try {
      // Check if Firebase is initialized
      try {
        _firebaseMessaging = FirebaseMessaging.instance;
      } catch (e) {
        print('Firebase Messaging not available: $e');
        return; // Exit early if Firebase is not configured
      }

      // Request permission for iOS
      NotificationSettings settings = await _firebaseMessaging!
          .requestPermission(alert: true, badge: true, sound: true);

      print(
        'FCM initialized successfully - Authorization status: ${settings.authorizationStatus}',
      );
    } catch (e) {
      // Firebase not configured - this is OK, app will use fallback device ID
      print('FCM initialization skipped (Firebase not configured): $e');
      _firebaseMessaging = null;
    }
  }

  /// Get FCM token for push notifications
  static Future<String?> getFCMToken() async {
    try {
      // First check if we have a stored token
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString(_fcmTokenKey);

      // Initialize if not already done
      if (_firebaseMessaging == null) {
        await initialize();
      }

      // Check if Firebase messaging is still null after initialization
      if (_firebaseMessaging == null) {
        print('Firebase Messaging not available - using fallback device ID');
        return null;
      }

      // Get FCM token
      String? token;
      try {
        token = await _firebaseMessaging!.getToken();
      } catch (e) {
        print('Error getting FCM token: $e');
        // If Firebase is not configured, return null and fall back to generated ID
        return null;
      }

      if (token != null && token.isNotEmpty) {
        // Store the token
        await prefs.setString(_fcmTokenKey, token);

        // Listen for token refresh
        _firebaseMessaging!.onTokenRefresh.listen((newToken) async {
          await prefs.setString(_fcmTokenKey, newToken);
          print('FCM token refreshed: $newToken');
        });

        print(
          'FCM token retrieved: ${token.length > 20 ? token.substring(0, 20) + "..." : token}',
        );
        return token;
      }

      // Return stored token if available even if current request failed
      if (storedToken != null && storedToken.isNotEmpty) {
        print('Using stored FCM token: ${storedToken.substring(0, 20)}...');
        return storedToken;
      }

      print('FCM token not available');
      return null;
    } catch (e) {
      print('Error getting FCM token: $e');
      // Try to return stored token as fallback
      try {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(_fcmTokenKey);
      } catch (_) {
        return null;
      }
    }
  }

  /// Clear stored FCM token
  static Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_fcmTokenKey);
      if (_firebaseMessaging != null) {
        await _firebaseMessaging!.deleteToken();
      }
    } catch (e) {
      print('Error clearing FCM token: $e');
    }
  }
}
