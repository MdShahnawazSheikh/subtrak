import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/user_settings_model.dart';
import '../data/repositories/settings_repository.dart';
import '../data/database/database_service.dart';
import '../../ui/themes/app_themes.dart';

/// Controller for app settings and user preferences
class SettingsController extends GetxController {
  final SettingsRepository _settingsRepo = Get.find();

  // Observables
  final Rx<UserSettingsModel?> settings = Rx(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// Load settings
  Future<void> _loadSettings() async {
    try {
      isLoading.value = true;
      settings.value = _settingsRepo.getSettings();
    } finally {
      isLoading.value = false;
    }
  }

  /// Reload settings
  Future<void> refresh() async {
    await _loadSettings();
  }

  // Theme helpers
  bool get isDarkMode => settings.value?.themeMode == AppThemeMode.dark;
  bool get isSystemTheme => settings.value?.themeMode == AppThemeMode.system;
  bool get isPro => settings.value?.isPro ?? false;
  bool get isLifetime => settings.value?.isLifetime ?? false;

  /// Get current app theme
  AppTheme get currentTheme {
    final index = settings.value?.selectedThemeIndex ?? 0;
    if (index >= 0 && index < AppTheme.values.length) {
      return AppTheme.values[index];
    }
    return AppTheme.midnightDark;
  }

  /// Get current theme data
  ThemeData get currentThemeData => AppThemes.getTheme(currentTheme);

  /// Get current theme metadata
  ThemeMetadata get currentThemeMetadata =>
      AppThemes.themeMetadata[currentTheme]!;

  /// Update selected theme
  Future<void> setSelectedTheme(AppTheme theme) async {
    final current = settings.value;
    if (current != null) {
      final index = AppTheme.values.indexOf(theme);
      final updated = current.copyWith(
        selectedThemeIndex: index,
        themeMode: AppThemes.themeMetadata[theme]!.isDark
            ? AppThemeMode.dark
            : AppThemeMode.light,
      );
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;

      // Force a full theme update by triggering the observable
      settings.refresh();

      _triggerHaptic();
    }
  }

  /// Update theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.copyWith(themeMode: mode);
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;

      // Apply theme
      ThemeMode themeMode;
      switch (mode) {
        case AppThemeMode.light:
          themeMode = ThemeMode.light;
          break;
        case AppThemeMode.dark:
          themeMode = ThemeMode.dark;
          break;
        case AppThemeMode.system:
          themeMode = ThemeMode.system;
          break;
      }
      Get.changeThemeMode(themeMode);

      _triggerHaptic();
    }
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    if (isDarkMode) {
      await setThemeMode(AppThemeMode.light);
    } else {
      await setThemeMode(AppThemeMode.dark);
    }
  }

  /// Update default currency
  Future<void> setDefaultCurrency(String currencyCode) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.copyWith(defaultCurrencyCode: currencyCode);
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;
      _triggerHaptic();
    }
  }

  /// Toggle haptic feedback
  Future<void> toggleHapticFeedback() async {
    final current = settings.value;
    if (current != null) {
      final updated = current.copyWith(
        hapticFeedbackEnabled: !current.hapticFeedbackEnabled,
      );
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;
      if (updated.hapticFeedbackEnabled) {
        HapticFeedback.mediumImpact();
      }
    }
  }

  /// Toggle animations
  Future<void> toggleAnimations() async {
    final current = settings.value;
    if (current != null) {
      final updated = current.copyWith(
        animationsEnabled: !current.animationsEnabled,
      );
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;
      _triggerHaptic();
    }
  }

  /// Toggle compact mode
  Future<void> toggleCompactMode() async {
    final current = settings.value;
    if (current != null) {
      final updated = current.copyWith(
        compactModeEnabled: !current.compactModeEnabled,
      );
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;
      _triggerHaptic();
    }
  }

  /// Toggle show cents
  Future<void> toggleShowCents() async {
    final current = settings.value;
    if (current != null) {
      final updated = current.copyWith(
        showCentsEnabled: !current.showCentsEnabled,
      );
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;
      _triggerHaptic();
    }
  }

  /// Update monthly budget
  Future<void> setMonthlyBudget(double? budget) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.copyWith(
        budgetSettings: current.budgetSettings.copyWith(monthlyBudget: budget),
      );
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;
      _triggerHaptic();
    }
  }

  /// Update notification settings
  Future<void> updateNotificationSettings(
    GlobalNotificationSettings notificationSettings,
  ) async {
    await _settingsRepo.updateNotificationSettings(notificationSettings);
    await refresh();
    _triggerHaptic();
  }

  /// Toggle notifications enabled
  Future<void> toggleNotificationsEnabled() async {
    final current = settings.value;
    if (current != null) {
      final updated = current.notificationSettings.copyWith(
        enabled: !current.notificationSettings.enabled,
      );
      await updateNotificationSettings(updated);
    }
  }

  /// Toggle quiet hours
  Future<void> toggleQuietHours() async {
    final current = settings.value;
    if (current != null) {
      final updated = current.notificationSettings.copyWith(
        quietHoursEnabled: !current.notificationSettings.quietHoursEnabled,
      );
      await updateNotificationSettings(updated);
    }
  }

  /// Update privacy settings
  Future<void> updatePrivacySettings(PrivacySettings privacySettings) async {
    await _settingsRepo.updatePrivacySettings(privacySettings);
    await refresh();
    _triggerHaptic();
  }

  /// Toggle hide amounts in notifications
  Future<void> toggleHideAmountsInNotifications() async {
    final current = settings.value;
    if (current != null) {
      final updated = current.privacySettings.copyWith(
        hideAmountsInNotifications:
            !current.privacySettings.hideAmountsInNotifications,
      );
      await updatePrivacySettings(updated);
    }
  }

  /// Toggle local encryption
  Future<void> toggleLocalEncryption() async {
    final current = settings.value;
    if (current != null) {
      final updated = current.privacySettings.copyWith(
        localEncryptionEnabled: !current.privacySettings.localEncryptionEnabled,
      );
      await updatePrivacySettings(updated);
    }
  }

  /// Upgrade to Pro
  Future<void> upgradeToPro({DateTime? expiryDate}) async {
    await _settingsRepo.upgradeToPro(expiryDate: expiryDate);
    await refresh();
    _triggerHaptic();
  }

  /// Upgrade to Lifetime
  Future<void> upgradeToLifetime() async {
    await _settingsRepo.upgradeToLifetime();
    await refresh();
    _triggerHaptic();
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    await _settingsRepo.completeOnboarding();
    await refresh();
  }

  /// Increment app open count
  Future<void> incrementAppOpenCount() async {
    await _settingsRepo.incrementAppOpenCount();
    settings.value = _settingsRepo.getSettings();
  }

  /// Toggle debug mode
  Future<void> toggleDebugMode() async {
    final current = settings.value;
    if (current != null) {
      final updated = current.copyWith(
        debugModeEnabled: !current.debugModeEnabled,
      );
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;
      _triggerHaptic();
    }
  }

  /// Reset to defaults
  Future<void> resetToDefaults() async {
    await _settingsRepo.resetToDefault();
    await refresh();
    Get.changeThemeMode(ThemeMode.system);
    _triggerHaptic();
  }

  /// Trigger haptic feedback if enabled
  void _triggerHaptic() {
    if (settings.value?.hapticFeedbackEnabled ?? true) {
      HapticFeedback.lightImpact();
    }
  }

  /// Format amount based on settings
  String formatAmount(double amount) {
    final current = settings.value;
    if (current == null) return '₹${amount.toStringAsFixed(2)}';

    final symbol = current.defaultCurrencyCode == 'INR'
        ? '₹'
        : current.defaultCurrencyCode == 'USD'
        ? '\$'
        : current.defaultCurrencyCode == 'EUR'
        ? '€'
        : current.defaultCurrencyCode == 'GBP'
        ? '£'
        : '₹';

    final formatted = current.showCentsEnabled
        ? amount.toStringAsFixed(2)
        : amount.toStringAsFixed(0);

    switch (current.currencyDisplayFormat) {
      case CurrencyDisplayFormat.symbolFirst:
        return '$symbol$formatted';
      case CurrencyDisplayFormat.symbolLast:
        return '$formatted$symbol';
      case CurrencyDisplayFormat.codeFirst:
        return '${current.defaultCurrencyCode} $formatted';
      case CurrencyDisplayFormat.codeLast:
        return '$formatted ${current.defaultCurrencyCode}';
    }
  }

  /// Set currency
  Future<void> setCurrency(String currencyCode) async {
    await setDefaultCurrency(currencyCode);
  }

  /// Toggle bill reminders
  Future<void> toggleBillReminders(bool value) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.notificationSettings.copyWith(
        billReminders: value,
      );
      await updateNotificationSettings(updated);
    }
  }

  /// Toggle insight alerts
  Future<void> toggleInsightAlerts(bool value) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.notificationSettings.copyWith(
        insightAlerts: value,
      );
      await updateNotificationSettings(updated);
    }
  }

  /// Toggle price change alerts
  Future<void> togglePriceAlerts(bool value) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.notificationSettings.copyWith(
        priceChangeAlerts: value,
      );
      await updateNotificationSettings(updated);
    }
  }

  /// Set quiet hours with start/end times
  Future<void> setQuietHours({
    required bool enabled,
    required String start,
    required String end,
  }) async {
    final current = settings.value;
    if (current != null) {
      final startParts = start.split(':');
      final endParts = end.split(':');
      final updated = current.notificationSettings.copyWith(
        quietHoursEnabled: enabled,
        quietHoursStart: int.parse(startParts[0]),
        quietHoursEnd: int.parse(endParts[0]),
      );
      await updateNotificationSettings(updated);
    }
  }

  /// Set default reminder days
  Future<void> setDefaultReminderDays(List<int> days) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.notificationSettings.copyWith(
        defaultReminderDays: days,
      );
      await updateNotificationSettings(updated);
    }
  }

  /// Toggle budget alerts
  Future<void> toggleBudgetAlerts(bool value) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.copyWith(
        budgetSettings: current.budgetSettings.copyWith(alertsEnabled: value),
      );
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;
      _triggerHaptic();
    }
  }

  /// Set budget limit
  Future<void> setBudgetLimit(double amount) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.copyWith(
        budgetSettings: current.budgetSettings.copyWith(monthlyBudget: amount),
      );
      await _settingsRepo.updateSettings(updated);
      settings.value = updated;
      _triggerHaptic();
    }
  }

  /// Toggle biometric lock
  Future<void> toggleBiometricLock(bool value) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.privacySettings.copyWith(
        biometricLockEnabled: value,
      );
      await updatePrivacySettings(updated);
    }
  }

  /// Toggle analytics
  Future<void> toggleAnalytics(bool value) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.privacySettings.copyWith(analyticsEnabled: value);
      await updatePrivacySettings(updated);
    }
  }

  /// Toggle cloud backup
  Future<void> toggleCloudBackup(bool value) async {
    final current = settings.value;
    if (current != null) {
      final updated = current.privacySettings.copyWith(
        cloudBackupEnabled: value,
      );
      await updatePrivacySettings(updated);
    }
  }

  /// Export data
  Future<void> exportData({required String format}) async {
    try {
      _triggerHaptic();

      final data = await DatabaseService.exportAll();
      String content;
      String fileName;

      if (format == 'json') {
        content = const JsonEncoder.withIndent('  ').convert(data);
        fileName =
            'subtrak_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      } else {
        // CSV format - export subscriptions only
        final subs = data['subscriptions'] as Map? ?? {};
        final buffer = StringBuffer();
        buffer.writeln(
          'id,name,amount,currency,category,status,nextBillingDate,recurrenceType',
        );
        for (final sub in subs.values) {
          if (sub is Map) {
            buffer.writeln(
              '${sub['id']},${sub['name']},${sub['amount']},${sub['currencyCode']},${sub['category']},${sub['status']},${sub['nextBillingDate']},${sub['recurrenceType']}',
            );
          }
        }
        content = buffer.toString();
        fileName =
            'subtrak_subscriptions_${DateTime.now().millisecondsSinceEpoch}.csv';
      }

      // Save to temp file and share
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(content);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'SubTrak Backup',
        text: 'SubTrak data export',
      );

      Get.snackbar(
        'Export Successful',
        'Your data has been exported',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Export Failed',
        'Could not export data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    }
  }

  /// Import data
  Future<void> importData() async {
    try {
      _triggerHaptic();

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Import Data'),
          content: const Text(
            'This will replace all your current data with the imported data. This action cannot be undone.\n\nDo you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Import', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      final success = await DatabaseService.importFromJson(data);

      if (success) {
        await refresh();
        Get.snackbar(
          'Import Successful',
          'Your data has been imported',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Import Failed',
          'Could not import data. The backup file may be invalid.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Import Failed',
        'Could not import data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    }
  }

  /// Clear all data
  Future<void> clearAllData() async {
    _triggerHaptic();

    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your subscriptions, settings, and data. This action cannot be undone.\n\nAre you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await DatabaseService.clearAll();
      await _settingsRepo.resetToDefault();
      await refresh();

      Get.snackbar(
        'Data Cleared',
        'All data has been deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not clear data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    }
  }

  /// Share app
  void shareApp() {
    _triggerHaptic();
    Share.share(
      'Check out SubTrak - the best app to track and manage all your subscriptions! Download it now: https://play.google.com/store/apps/details?id=com.subtrak.app',
      subject: 'SubTrak - Subscription Tracker',
    );
  }
}
