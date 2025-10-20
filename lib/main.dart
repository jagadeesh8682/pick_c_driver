import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_providers.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/routes_name.dart';
import 'core/theme/app_theme.dart';

void main() {
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
