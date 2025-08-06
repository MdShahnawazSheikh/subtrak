import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _notifications;

  static Future<void> init() async {
    tzData.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(settings);

    // ✅ Request POST_NOTIFICATIONS permission using permission_handler
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;

      if (!status.isGranted) {
        final result = await Permission.notification.request();

        if (!result.isGranted) {
          debugPrint("❌ Notification permission denied");
          // Optional: Show Snackbar or guide user to settings
        } else {
          debugPrint("✅ Notification permission granted");
        }
      }
    }
  }

  static Future<void> scheduleBillReminder({
    required int id,
    required String title,
    required DateTime dueDate,
  }) async {
    // ✅ Exact Alarm Permission check (Android only)
    if (Platform.isAndroid) {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        final isAllowed = await androidPlugin.requestExactAlarmsPermission();

        if (isAllowed != true) {
          // ✅ handles null and false
          throw PlatformException(
            code: 'exact_alarms_not_permitted',
            message: 'Exact alarms are not permitted',
          );
        }
      }
    }

    // Schedule for 9 AM *one day before* the due date
    final scheduleTime = tz.TZDateTime.from(
      DateTime(dueDate.year, dueDate.month, dueDate.day - 1, 9),
      tz.local,
    );
    //test notification:
    /* final now = tz.TZDateTime.now(tz.local);
      final scheduleTime = now.add(const Duration(minutes: 1)); */
    await _notifications.zonedSchedule(
      id,
      'Upcoming Bill',
      '“$title” is due tomorrow.',
      scheduleTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bill_reminders',
          'Bill Reminders',
          channelDescription: 'Notifications for upcoming bill reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  static Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id);
  }
}
