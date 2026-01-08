import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'app/bindings/initial_binding.dart';
import 'app/data/database/database_service.dart';
import 'app/controllers/settings_controller.dart';
import 'app/services/notification_services.dart';
import 'ui/themes/app_themes.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/subscription_detail_screen.dart';
import 'ui/screens/add_subscription_screen.dart';
import 'ui/screens/calendar_screen.dart';
import 'ui/screens/insights_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/theme_selector_screen.dart';
import 'ui/screens/help_screen.dart';
import 'ui/screens/legal_screen.dart';
// Premium Feature Screens
import 'ui/screens/analytics_dashboard_screen.dart';
import 'ui/screens/budget_goals_screen.dart';
import 'ui/screens/smart_insights_screen.dart';
import 'ui/screens/export_reports_screen.dart';
import 'ui/screens/family_sharing_screen.dart';
import 'ui/screens/price_alerts_screen.dart';
import 'ui/screens/subscription_comparison_screen.dart';
import 'ui/screens/cancellation_manager_screen.dart';
import 'ui/screens/usage_tracking_screen.dart';
import 'ui/screens/debug_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone data
  tz_data.initializeTimeZones();

  // Initialize GetStorage for simple key-value storage
  await GetStorage.init();

  // Initialize Hive database
  await DatabaseService.initialize();

  // Initialize notifications
  await NotificationService.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0F),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Check if first launch
  final storage = GetStorage();
  final isFirstLaunch = storage.read<bool>('hasCompletedOnboarding') != true;

  runApp(SubTrakApp(isFirstLaunch: isFirstLaunch));
}

class SubTrakApp extends StatelessWidget {
  final bool isFirstLaunch;

  const SubTrakApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    // Initialize binding first to make SettingsController available
    InitialBinding().dependencies();

    final settingsController = Get.find<SettingsController>();

    return Obx(() {
      // Get current theme from settings
      final currentSettings = settingsController.settings.value;
      final themeIndex = currentSettings?.selectedThemeIndex ?? 0;
      final appTheme = (themeIndex >= 0 && themeIndex < AppTheme.values.length)
          ? AppTheme.values[themeIndex]
          : AppTheme.midnightDark;
      final themeData = AppThemes.getTheme(appTheme);
      final isDark = AppThemes.themeMetadata[appTheme]!.isDark;

      return GetMaterialApp(
        title: 'SubTrak',
        debugShowCheckedModeBanner: false,

        // Theme configuration - reactive to settings
        theme: themeData,
        darkTheme: themeData,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

        // Initial route
        home: isFirstLaunch ? const OnboardingScreen() : const HomeScreen(),

        // Route configuration
        getPages: [
          GetPage(
            name: '/home',
            page: () => const HomeScreen(),
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: '/subscription/:id',
            page: () => const SubscriptionDetailScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/add',
            page: () => const AddSubscriptionScreen(),
            transition: Transition.downToUp,
          ),
          GetPage(
            name: '/edit/:id',
            page: () => const AddSubscriptionScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/calendar',
            page: () => const CalendarScreen(),
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: '/insights',
            page: () => const InsightsScreen(),
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: '/settings',
            page: () => const SettingsScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/onboarding',
            page: () => const OnboardingScreen(),
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: '/themes',
            page: () => const ThemeSelectorScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/help',
            page: () => const HelpScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/privacy',
            page: () => const LegalScreen(type: LegalType.privacy),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/terms',
            page: () => const LegalScreen(type: LegalType.terms),
            transition: Transition.rightToLeft,
          ),
          // Premium Feature Routes
          GetPage(
            name: '/analytics',
            page: () => const AnalyticsDashboardScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/budget-goals',
            page: () => const BudgetGoalsScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/ai-insights',
            page: () => const SmartInsightsScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/export',
            page: () => const ExportReportsScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/family-sharing',
            page: () => const FamilySharingScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/price-alerts',
            page: () => const PriceAlertsScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/compare',
            page: () => const SubscriptionComparisonScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/renewals',
            page: () => const CancellationManagerScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/usage-tracking',
            page: () => const UsageTrackingScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/debug',
            page: () => const DebugScreen(),
            transition: Transition.rightToLeft,
          ),
        ],

        // Default transition
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),

        // Localization
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),

        // Builder to apply global configurations
        builder: (context, child) {
          // Update system UI based on theme
          final brightness = isDark ? Brightness.light : Brightness.dark;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: brightness,
              systemNavigationBarColor: isDark
                  ? const Color(0xFF0A0A0F)
                  : Colors.white,
              systemNavigationBarIconBrightness: brightness,
            ),
          );

          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          );
        },
      );
    });
  }
}
