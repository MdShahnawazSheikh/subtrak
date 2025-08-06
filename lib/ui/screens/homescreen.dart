import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subtrak/app/controllers/bill_controller.dart';
import 'package:subtrak/app/services/notification_services.dart';
import 'package:subtrak/ui/screens/add_bill_screen.dart';
import 'package:subtrak/ui/widgets/bill_tile.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final box = GetStorage();

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'SubTrak',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              final isCurrentlyDark = theme.brightness == Brightness.dark;
              final newThemeMode = isCurrentlyDark
                  ? ThemeMode.light
                  : ThemeMode.dark;

              box.write('isDarkMode', !isCurrentlyDark); // 💾 Save preference
              Get.changeThemeMode(newThemeMode); // 🎨 Apply theme
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Monthly Summary
            Obx(() {
              final controller = Get.find<BillController>();
              final total = controller.getUpcomingBills().fold<double>(
                0,
                (sum, bill) => sum + bill.amount,
              );

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.primaryContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('This Month', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      '₹${total.toStringAsFixed(0)} due',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Upcoming List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upcoming Bills', style: theme.textTheme.titleMedium),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            const SizedBox(height: 12),

            // Upcoming List
            Expanded(
              child: Obx(() {
                final controller = Get.find<BillController>();
                final bills = controller.getUpcomingBills();

                if (bills.isEmpty) {
                  return const Center(child: Text("No upcoming bills"));
                }

                return ListView.builder(
                  itemCount: bills.length,
                  itemBuilder: (_, index) {
                    final bill = bills[index];
                    return BillTile(bill: bill);
                  },
                );
              }),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const AddBillScreen());
        },

        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
      /* floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            final scheduleTime = tz.TZDateTime.now(
              tz.local,
            ).add(const Duration(seconds: 10));

            await NotificationService.flutterLocalNotificationsPlugin
                .zonedSchedule(
                  999,
                  'Test Notification',
                  'This is a test notification!',
                  scheduleTime,
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      'test_channel',
                      'Test Channel',
                      channelDescription: 'Test notifications',
                      importance: Importance.max,
                      priority: Priority.high,
                    ),
                  ),
                  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                  matchDateTimeComponents: DateTimeComponents.dateAndTime,
                );

            Get.snackbar('Scheduled', 'Notification will appear in 10 seconds');
          } catch (e) {
            Get.snackbar('Error', e.toString());
          }
        },

        icon: const Icon(Icons.bug_report),
        label: const Text("Test Notify"),
      ), */
    );
  }
}
