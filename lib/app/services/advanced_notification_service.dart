import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;
import '../data/models/subscription_model.dart';
import '../data/models/user_settings_model.dart';

/// Advanced Notification Service with multi-stage alerts
class AdvancedNotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// Notification channels
  static const String billReminderChannel = 'bill_reminders';
  static const String insightChannel = 'insights';
  static const String criticalChannel = 'critical_alerts';
  static const String silentChannel = 'silent_updates';

  /// Get plugin instance
  static FlutterLocalNotificationsPlugin get plugin => _notifications;

  /// Instance method to initialize (calls static init)
  Future<void> initialize() async {
    await init();
  }

  /// Initialize notification service
  static Future<void> init() async {
    if (_initialized) return;

    tzData.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotification,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }

    // Request permissions
    await _requestPermissions();

    _initialized = true;
  }

  /// Create Android notification channels
  static Future<void> _createNotificationChannels() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // Bill reminder channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          billReminderChannel,
          'Bill Reminders',
          description: 'Notifications for upcoming bill due dates',
          importance: Importance.high,
          enableVibration: true,
          enableLights: true,
          ledColor: Color(0xFF00BCD4),
        ),
      );

      // Insight channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          insightChannel,
          'Insights & Tips',
          description: 'Smart insights about your subscriptions',
          importance: Importance.defaultImportance,
          enableVibration: true,
        ),
      );

      // Critical alerts channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          criticalChannel,
          'Critical Alerts',
          description:
              'Urgent notifications about trials ending, payment failures',
          importance: Importance.max,
          enableVibration: true,
          enableLights: true,
          ledColor: Color(0xFFF44336),
        ),
      );

      // Silent updates channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          silentChannel,
          'Background Updates',
          description: 'Silent notifications for background operations',
          importance: Importance.low,
          enableVibration: false,
          playSound: false,
        ),
      );
    }
  }

  /// Request notification permissions
  static Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        if (!result.isGranted) {
          debugPrint('Notification permission denied');
          return false;
        }
      }
    }
    return true;
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      // Parse payload and navigate accordingly
      // Format: "type:subscriptionId" or "type:action"
      debugPrint('Notification tapped: $payload');
      // Navigation will be handled by GetX routing
    }
  }

  /// Handle background notification
  @pragma('vm:entry-point')
  static void _onBackgroundNotification(NotificationResponse response) {
    debugPrint('Background notification: ${response.payload}');
  }

  /// Request exact alarm permission (Android 12+)
  static Future<bool> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        final isAllowed = await androidPlugin.requestExactAlarmsPermission();
        return isAllowed ?? false;
      }
    }
    return true;
  }

  /// Schedule multi-stage bill reminders
  static Future<void> scheduleBillReminders({
    required SubscriptionModel subscription,
    required NotificationPreference preferences,
    GlobalNotificationSettings? globalSettings,
  }) async {
    if (!preferences.enabled) return;

    // Check exact alarm permission
    final canSchedule = await requestExactAlarmPermission();
    if (!canSchedule) {
      throw PlatformException(
        code: 'exact_alarms_not_permitted',
        message: 'Cannot schedule exact alarms',
      );
    }

    // Cancel existing reminders for this subscription
    await cancelSubscriptionReminders(subscription.id);

    final dueDate = subscription.nextBillingDate;
    final baseNotificationId = subscription.id.hashCode.abs() % 100000;

    // Schedule reminders for each day before
    for (int i = 0; i < preferences.daysBefore.length; i++) {
      final days = preferences.daysBefore[i];
      final scheduleDate = dueDate.subtract(Duration(days: days));

      // Skip if date is in the past
      if (scheduleDate.isBefore(DateTime.now())) continue;

      // Determine notification time (default 9 AM)
      var notifyTime = DateTime(
        scheduleDate.year,
        scheduleDate.month,
        scheduleDate.day,
        9,
        0,
      );

      // Respect quiet hours
      if (globalSettings != null && globalSettings.quietHoursEnabled) {
        if (notifyTime.hour >= globalSettings.quietHoursStart ||
            notifyTime.hour < globalSettings.quietHoursEnd) {
          notifyTime = DateTime(
            scheduleDate.year,
            scheduleDate.month,
            scheduleDate.day,
            globalSettings.quietHoursEnd,
            0,
          );
        }
      }

      final scheduleTz = tz.TZDateTime.from(notifyTime, tz.local);
      final notificationId = baseNotificationId + i;

      final title = _getReminderTitle(days, subscription.name);
      final body = _getReminderBody(days, subscription);

      await _notifications.zonedSchedule(
        notificationId,
        title,
        body,
        scheduleTz,
        _getNotificationDetails(
          channelId: preferences.criticalAlert && days <= 1
              ? criticalChannel
              : billReminderChannel,
          silent: preferences.silentMode,
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'bill:${subscription.id}',
      );
    }

    // Schedule day-of reminder
    final dayOfSchedule = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      8,
      0,
    );

    if (dayOfSchedule.isAfter(DateTime.now())) {
      final dayOfTz = tz.TZDateTime.from(dayOfSchedule, tz.local);

      await _notifications.zonedSchedule(
        baseNotificationId + 100,
        '${subscription.name} is due today',
        '₹${subscription.amount.toStringAsFixed(0)} payment due now',
        dayOfTz,
        _getNotificationDetails(
          channelId: preferences.criticalAlert
              ? criticalChannel
              : billReminderChannel,
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'bill:${subscription.id}',
      );
    }
  }

  /// Get reminder title based on days
  static String _getReminderTitle(int days, String subscriptionName) {
    if (days == 1) return '$subscriptionName due tomorrow';
    if (days == 7) return '$subscriptionName coming up';
    if (days == 3) return '$subscriptionName due in 3 days';
    return '$subscriptionName due in $days days';
  }

  /// Get reminder body
  static String _getReminderBody(int days, SubscriptionModel subscription) {
    final amount = '₹${subscription.amount.toStringAsFixed(0)}';
    final recurrence = subscription.recurrenceDisplayString.toLowerCase();

    if (days == 1) {
      return '$amount $recurrence payment is due tomorrow.';
    }
    if (days == 7) {
      return '$amount will be charged in a week. Plan ahead!';
    }
    return '$amount $recurrence payment coming in $days days.';
  }

  /// Get notification details
  static NotificationDetails _getNotificationDetails({
    required String channelId,
    bool silent = false,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _getChannelName(channelId),
        channelDescription: _getChannelDescription(channelId),
        importance: _getImportance(channelId),
        priority: _getPriority(channelId),
        playSound: !silent,
        enableVibration: !silent,
        category: AndroidNotificationCategory.reminder,
        visibility: NotificationVisibility.private,
        autoCancel: true,
        styleInformation: const BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: !silent,
        interruptionLevel: channelId == criticalChannel
            ? InterruptionLevel.critical
            : InterruptionLevel.active,
      ),
    );
  }

  static String _getChannelName(String channelId) {
    switch (channelId) {
      case billReminderChannel:
        return 'Bill Reminders';
      case insightChannel:
        return 'Insights & Tips';
      case criticalChannel:
        return 'Critical Alerts';
      case silentChannel:
        return 'Background Updates';
      default:
        return 'Notifications';
    }
  }

  static String _getChannelDescription(String channelId) {
    switch (channelId) {
      case billReminderChannel:
        return 'Notifications for upcoming bill due dates';
      case insightChannel:
        return 'Smart insights about your subscriptions';
      case criticalChannel:
        return 'Urgent notifications about trials ending, payment failures';
      case silentChannel:
        return 'Silent notifications for background operations';
      default:
        return 'App notifications';
    }
  }

  static Importance _getImportance(String channelId) {
    switch (channelId) {
      case criticalChannel:
        return Importance.max;
      case billReminderChannel:
        return Importance.high;
      case insightChannel:
        return Importance.defaultImportance;
      case silentChannel:
        return Importance.low;
      default:
        return Importance.defaultImportance;
    }
  }

  static Priority _getPriority(String channelId) {
    switch (channelId) {
      case criticalChannel:
        return Priority.max;
      case billReminderChannel:
        return Priority.high;
      default:
        return Priority.defaultPriority;
    }
  }

  /// Cancel reminders for a subscription
  static Future<void> cancelSubscriptionReminders(String subscriptionId) async {
    final baseId = subscriptionId.hashCode.abs() % 100000;
    // Cancel all possible notification IDs for this subscription
    for (int i = 0; i < 20; i++) {
      await _notifications.cancel(baseId + i);
    }
    await _notifications.cancel(baseId + 100); // Day-of notification
  }

  /// Show instant notification
  static Future<void> showInstant({
    required String title,
    required String body,
    String? payload,
    String channelId = billReminderChannel,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    await _notifications.show(
      id,
      title,
      body,
      _getNotificationDetails(channelId: channelId),
      payload: payload,
    );
  }

  /// Show insight notification
  static Future<void> showInsight({
    required String title,
    required String body,
    String? actionId,
  }) async {
    await showInstant(
      title: title,
      body: body,
      payload: 'insight:$actionId',
      channelId: insightChannel,
    );
  }

  /// Show critical alert
  static Future<void> showCriticalAlert({
    required String title,
    required String body,
    String? subscriptionId,
  }) async {
    await showInstant(
      title: title,
      body: body,
      payload: subscriptionId != null ? 'critical:$subscriptionId' : null,
      channelId: criticalChannel,
    );
  }

  /// Show trial ending alert
  static Future<void> showTrialEndingAlert(
    SubscriptionModel subscription,
  ) async {
    final daysLeft = subscription.trialEndDate!
        .difference(DateTime.now())
        .inDays;

    await showCriticalAlert(
      title:
          '${subscription.name} trial ends ${daysLeft == 0 ? "today" : "in $daysLeft days"}',
      body:
          'Cancel now to avoid being charged ₹${subscription.amount.toStringAsFixed(0)}/${subscription.recurrenceDisplayString.toLowerCase()}',
      subscriptionId: subscription.id,
    );
  }

  /// Schedule trial ending reminder
  static Future<void> scheduleTrialEndingReminder(
    SubscriptionModel subscription,
  ) async {
    if (!subscription.isTrial || subscription.trialEndDate == null) return;

    final daysUntilEnd = subscription.trialEndDate!
        .difference(DateTime.now())
        .inDays;
    if (daysUntilEnd < 0) return;

    // Schedule reminders at T-3 and T-1
    final reminderDays = [3, 1].where((d) => d <= daysUntilEnd).toList();
    final baseId = subscription.id.hashCode.abs() % 100000 + 50000;

    for (int i = 0; i < reminderDays.length; i++) {
      final days = reminderDays[i];
      final scheduleDate = subscription.trialEndDate!.subtract(
        Duration(days: days),
      );
      final scheduleTime = DateTime(
        scheduleDate.year,
        scheduleDate.month,
        scheduleDate.day,
        10,
        0,
      );

      if (scheduleTime.isAfter(DateTime.now())) {
        await _notifications.zonedSchedule(
          baseId + i,
          '${subscription.name} trial ends in $days ${days == 1 ? "day" : "days"}',
          'Cancel before ${_formatDate(subscription.trialEndDate!)} to avoid charges',
          tz.TZDateTime.from(scheduleTime, tz.local),
          _getNotificationDetails(channelId: criticalChannel),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'trial:${subscription.id}',
        );
      }
    }
  }

  /// Get all pending notifications
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Reschedule all notifications (for after system reboot)
  static Future<void> rescheduleAll(
    List<SubscriptionModel> subscriptions,
  ) async {
    await cancelAll();

    for (final sub in subscriptions) {
      if (sub.status == SubscriptionStatus.active ||
          sub.status == SubscriptionStatus.trial) {
        await scheduleBillReminders(
          subscription: sub,
          preferences: sub.notificationPreference,
        );

        if (sub.isTrial) {
          await scheduleTrialEndingReminder(sub);
        }
      }
    }
  }

  /// Check notification health (are notifications still scheduled)
  static Future<NotificationHealth> checkHealth(
    List<SubscriptionModel> subscriptions,
  ) async {
    final pending = await getPendingNotifications();
    final activeSubscriptionIds = subscriptions
        .where(
          (s) =>
              s.status == SubscriptionStatus.active ||
              s.status == SubscriptionStatus.trial,
        )
        .map((s) => s.id)
        .toSet();

    int scheduled = 0;
    int missing = 0;
    final missingSubscriptionIds = <String>[];

    for (final subId in activeSubscriptionIds) {
      final baseId = subId.hashCode.abs() % 100000;
      final hasNotification = pending.any(
        (p) => p.id >= baseId && p.id <= baseId + 100,
      );

      if (hasNotification) {
        scheduled++;
      } else {
        missing++;
        missingSubscriptionIds.add(subId);
      }
    }

    return NotificationHealth(
      totalActive: activeSubscriptionIds.length,
      scheduled: scheduled,
      missing: missing,
      missingSubscriptionIds: missingSubscriptionIds,
      pendingCount: pending.length,
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Notification health status
class NotificationHealth {
  final int totalActive;
  final int scheduled;
  final int missing;
  final List<String> missingSubscriptionIds;
  final int pendingCount;

  const NotificationHealth({
    required this.totalActive,
    required this.scheduled,
    required this.missing,
    required this.missingSubscriptionIds,
    required this.pendingCount,
  });

  bool get isHealthy => missing == 0;
  double get healthPercent =>
      totalActive > 0 ? (scheduled / totalActive) * 100 : 100;
}
