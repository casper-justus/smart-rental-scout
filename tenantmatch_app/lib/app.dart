import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/theme_service.dart';
import 'widgets/app_route_transitions.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_search_screen.dart';
import 'screens/listing_details_screen.dart';
import 'screens/saved_searches_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/discovery_commute_setup_screen.dart';
import 'screens/commute_hub_settings_screen.dart';
import 'screens/compare_properties_screen.dart';
import 'screens/virtual_tour_screen.dart';
import 'screens/application_portal_step1_screen.dart';
import 'screens/application_portal_step2_screen.dart';
import 'screens/application_portal_step3_screen.dart';
import 'screens/application_portal_step4_review_screen.dart';
import 'screens/submission_success_screen.dart';

class TenantMatchApp extends StatelessWidget {
  const TenantMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.modeNotifier,
      builder: (context, _) {
        return MaterialApp(
          title: 'TenantMatch',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeService.modeNotifier.value,
          initialRoute: '/splash',
          onGenerateRoute: (settings) {
            Widget screen;
            switch (settings.name) {
              case '/splash':
                screen = const SplashScreen();
                return AppRouteTransitions.fadeIn(screen, settings);
              case '/discovery':
                screen = const DiscoveryCommuteSetupScreen();
                break;
              case '/commute-hub':
                screen = const CommuteHubSettingsScreen();
                break;
              case '/home':
                screen = const HomeScreen();
                break;
              case '/search':
                screen = const MapSearchScreen();
                break;
              case '/listing-details':
                final propId = settings.arguments as String? ?? 'prop_1';
                screen = ListingDetailsScreen(propertyId: propId);
                break;
              case '/saved':
                screen = const SavedSearchesScreen();
                break;
              case '/profile':
                screen = const UserProfileScreen();
                break;
              case '/compare':
                screen = const ComparePropertiesScreen();
                break;
              case '/virtual-tour':
                final propId = settings.arguments as String? ?? '';
                screen = VirtualTourScreen(propertyId: propId);
                return AppRouteTransitions.fadeIn(screen, settings);
              case '/app-step1':
                screen = const ApplicationPortalStep1Screen();
                break;
              case '/app-step2':
                screen = const ApplicationPortalStep2Screen();
                break;
              case '/app-step3':
                screen = const ApplicationPortalStep3Screen();
                break;
              case '/app-step4':
                screen = const ApplicationPortalStep4ReviewScreen();
                break;
              case '/submission-success':
                screen = const SubmissionSuccessScreen();
                break;
              default:
                screen = const HomeScreen();
            }
            // Default transition: slide from right
            return AppRouteTransitions.slideInFromRight(screen, settings);
          },
        );
      },
    );
  }
}
