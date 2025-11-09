# Device ID Save Troubleshooting Guide

## Current Issues & Solutions

### Issue 1: Firebase Initialization Error
**Status**: ✅ Handled - App continues without Firebase
- Firebase initialization fails if not configured
- App automatically falls back to generated device ID
- This is OK for now, but configure Firebase for production

### Issue 2: "Unauthorized - Session expired" Error
**Possible Causes**:

1. **Token Format**: API might expect different authorization format
   - Current: `Authorization: Bearer <token>`
   - Try: `Authorization: <token>` (token only)
   - Change in: `lib/core/network/network_service_impl.dart` line 223

2. **Timing Issue**: Token might not be ready
   - ✅ Added 300ms + 500ms delays
   - ✅ Added prefs.reload() to ensure token is committed

3. **Token Invalid**: Token might not be valid for this endpoint
   - Check logs to see what token is being sent
   - Verify token is correct format from login response

## Debug Steps

1. **Check Logs After Login**:
   ```
   Look for:
   - "Token available for device ID save"
   - "=== Save Device ID Debug ==="
   - "Authorization header set with Bearer token"
   - "POST ... Status: 401" (if unauthorized)
   ```

2. **Try Different Authorization Formats**:
   
   In `lib/core/network/network_service_impl.dart` line 223, try:
   
   ```dart
   // Option 1: Bearer format (current)
   headers['Authorization'] = 'Bearer $token';
   
   // Option 2: Token only
   headers['Authorization'] = token;
   
   // Option 3: Token prefix
   headers['Authorization'] = 'Token $token';
   ```

3. **Check API Response**:
   - Look at logs for "401 Unauthorized - Response body: ..."
   - The response body might tell us what the API expects

4. **Verify Endpoint**:
   - URL: `http://api.pickcargo.in/api/master/driver/deviceid`
   - Method: POST
   - Headers: Authorization (with token)
   - Body: `{"driverId": "...", "deviceId": "..."}`

## Quick Fixes to Try

### Fix 1: Change Authorization Format
```dart
// In lib/core/network/network_service_impl.dart
headers['Authorization'] = token; // Remove Bearer prefix
```

### Fix 2: Increase Delay
```dart
// In lib/screens/auth/login/repository/login_repository.dart
await Future.delayed(const Duration(seconds: 1)); // Increase from 500ms
```

### Fix 3: Check if API needs token in different header
Some APIs expect token in:
- `X-Auth-Token` instead of `Authorization`
- Query parameter instead of header

## Current Implementation Status

✅ Firebase/FCM integration ready (needs Firebase config)
✅ Fallback to generated device ID if FCM unavailable
✅ Token handling with retry mechanism
✅ Detailed logging for debugging
✅ Error handling that doesn't block login

## Next Steps

1. Check the actual API response in logs
2. Try different authorization formats
3. Verify the API documentation for exact requirements
4. If Firebase is needed, configure it properly


