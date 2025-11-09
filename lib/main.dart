import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/providers/app_providers.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/routes_name.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (optional - only if Firebase is configured)
  try {
    await Firebase.initializeApp();
    // Initialize FCM
    await FCMService.initialize();
    print('Firebase and FCM initialized successfully');
  } catch (e) {
    // Firebase not configured - this is OK, app will use fallback device ID
    print('Firebase initialization skipped (not configured): $e');
    // Continue without Firebase
  }

  runApp(const PicCDriverApp());
}

class PicCDriverApp extends StatelessWidget {
  const PicCDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'Pic C Driver',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: Routes.languageSelection,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
