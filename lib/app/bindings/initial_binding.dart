import 'package:get/get.dart';
import '../controllers/subscription_controller.dart';
import '../controllers/settings_controller.dart';
import '../data/repositories/subscription_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/services/intelligence_engine.dart';
import '../services/advanced_notification_service.dart';
import '../services/debug_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize repositories first (they depend on Hive which is already initialized)
    Get.put(SubscriptionRepository(), permanent: true);
    Get.put(SettingsRepository(), permanent: true);
    Get.put(InsightRepository(), permanent: true);
    Get.put(SmartRuleRepository(), permanent: true);
    Get.put(SavedViewRepository(), permanent: true);
    Get.put(AuditLogRepository(), permanent: true);

    // Initialize services
    Get.put(
      IntelligenceEngine(
        subscriptionRepo: Get.find<SubscriptionRepository>(),
        settingsRepo: Get.find<SettingsRepository>(),
        insightRepo: Get.find<InsightRepository>(),
      ),
      permanent: true,
    );
    Get.put(AdvancedNotificationService(), permanent: true);
    Get.put(DebugService(), permanent: true);

    // Initialize controllers (they depend on repositories and services)
    Get.put(SettingsController(), permanent: true);
    Get.put(SubscriptionController(), permanent: true);

    // Initialize notification service asynchronously
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    final notificationService = Get.find<AdvancedNotificationService>();
    await notificationService.initialize();
  }
}
