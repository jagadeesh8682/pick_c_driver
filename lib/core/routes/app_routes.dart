import 'package:flutter/material.dart';
import 'routes_name.dart';
import '../../screens/onboarding/language_selection/screen/language_selection_screen.dart';
import '../../screens/auth/login/screen/login_screen.dart';
import '../../screens/main/home/screen/home_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    Routes.languageSelection: (context) => const LanguageSelectionScreen(),
    Routes.login: (context) => const LoginScreen(),
    Routes.home: (context) => const HomeScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Handle custom routes if needed
    switch (settings.name) {
      default:
        return null;
    }
  }
}

/// Placeholder Screen for menu items not yet implemented
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                '$title Coming Soon',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This feature is under development and will be available soon.',
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.yellow,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
