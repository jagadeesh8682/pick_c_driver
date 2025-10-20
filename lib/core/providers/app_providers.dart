import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../network/network_service_impl.dart';
import '../../screens/onboarding/language_selection/provider/language_selection_provider.dart';
import '../../screens/auth/login/provider/login_provider.dart';
import '../../screens/main/home/provider/home_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
    // Network Service
    Provider<NetworkServiceImpl>(create: (_) => NetworkServiceImpl()),

    // Onboarding Providers
    ChangeNotifierProvider<LanguageSelectionProvider>(
      create: (_) => LanguageSelectionProvider(),
    ),

    // Auth Providers
    ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),

    // Main App Providers
    ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
  ];
}
