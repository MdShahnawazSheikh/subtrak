import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../data/models/subscription_model.dart';
import '../data/models/insight_model.dart';
import '../data/repositories/subscription_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../controllers/subscription_controller.dart';
import 'notification_services.dart';

/// Comprehensive Debug Service for testing all app features
class DebugService extends GetxService {
  static DebugService get to => Get.find<DebugService>();

  final RxList<String> logs = <String>[].obs;
  final RxBool isLoading = false.obs;
  final Random _random = Random();

  // Sample brand names for testing
  static const List<String> _sampleBrands = [
    'Netflix',
    'Spotify',
    'YouTube Premium',
    'Disney+',
    'Amazon Prime',
    'Apple Music',
    'HBO Max',
    'Hulu',
    'Paramount+',
    'Peacock',
    'Microsoft 365',
    'Adobe Creative Cloud',
    'Dropbox',
    'Google One',
    'iCloud+',
    'Notion',
    'Slack',
    'Zoom',
    'Canva Pro',
    'Figma',
    'PlayStation Plus',
    'Xbox Game Pass',
    'Nintendo Switch Online',
    'ChatGPT Plus',
    'Claude Pro',
    'Midjourney',
    'GitHub Copilot',
    'LinkedIn Premium',
    'Coursera Plus',
    'Duolingo Plus',
    'Headspace',
    'Calm',
    'Peloton',
    'Strava',
    'MyFitnessPal Premium',
    'NordVPN',
    'ExpressVPN',
    '1Password',
    'LastPass',
    'Bitwarden',
    'The New York Times',
    'The Washington Post',
    'Medium',
    'Substack',
    'Uber One',
    'DoorDash DashPass',
    'Instacart+',
    'Walmart+',
    'Costco Membership',
    'Amazon Subscribe & Save',
  ];

  void log(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    logs.insert(0, '[$timestamp] $message');
    debugPrint('🔧 DEBUG: $message');
  }

  // Internal log helper
  void _log(String message) => log(message);

  void clearLogs() {
    logs.clear();
    _log('Logs cleared');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SAMPLE DATA GENERATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Generate sample subscriptions for testing
  Future<int> generateSampleSubscriptions({int count = 10}) async {
    isLoading.value = true;
    _log('Generating $count sample subscriptions...');

    try {
      final repo = Get.find<SubscriptionRepository>();
      final now = DateTime.now();
      int created = 0;

      final categories = SubscriptionCategory.values;
      final recurrenceTypes = [
        RecurrenceType.monthly,
        RecurrenceType.annual,
        RecurrenceType.weekly,
        RecurrenceType.quarterly,
      ];
      final statuses = [
        SubscriptionStatus.active,
        SubscriptionStatus.active,
        SubscriptionStatus.active,
        SubscriptionStatus.trial,
        SubscriptionStatus.paused,
      ];

      final usedBrands = <String>{};

      for (int i = 0; i < count; i++) {
        // Pick unique brand
        String brand;
        do {
          brand = _sampleBrands[_random.nextInt(_sampleBrands.length)];
        } while (usedBrands.contains(brand) &&
            usedBrands.length < _sampleBrands.length);
        usedBrands.add(brand);

        final category = categories[_random.nextInt(categories.length)];
        final recurrence =
            recurrenceTypes[_random.nextInt(recurrenceTypes.length)];
        final status = statuses[_random.nextInt(statuses.length)];

        // Generate realistic price based on recurrence
        double amount;
        switch (recurrence) {
          case RecurrenceType.weekly:
            amount = (_random.nextInt(10) + 2) * 10.0; // ₹20-120/week
            break;
          case RecurrenceType.monthly:
            amount = (_random.nextInt(50) + 5) * 10.0; // ₹50-550/month
            break;
          case RecurrenceType.quarterly:
            amount = (_random.nextInt(100) + 20) * 10.0; // ₹200-1200/quarter
            break;
          case RecurrenceType.annual:
            amount = (_random.nextInt(500) + 50) * 10.0; // ₹500-5500/year
            break;
          default:
            amount = (_random.nextInt(30) + 5) * 10.0;
        }

        // Random start date in past 6 months
        final startDate = now.subtract(Duration(days: _random.nextInt(180)));

        // Calculate next billing based on recurrence
        DateTime nextBilling = startDate;
        while (nextBilling.isBefore(now)) {
          switch (recurrence) {
            case RecurrenceType.weekly:
              nextBilling = nextBilling.add(const Duration(days: 7));
              break;
            case RecurrenceType.monthly:
              nextBilling = DateTime(
                nextBilling.year,
                nextBilling.month + 1,
                nextBilling.day,
              );
              break;
            case RecurrenceType.quarterly:
              nextBilling = DateTime(
                nextBilling.year,
                nextBilling.month + 3,
                nextBilling.day,
              );
              break;
            case RecurrenceType.annual:
              nextBilling = DateTime(
                nextBilling.year + 1,
                nextBilling.month,
                nextBilling.day,
              );
              break;
            default:
              nextBilling = nextBilling.add(const Duration(days: 30));
          }
        }

        // Generate payment history
        final paymentHistory = <PaymentRecord>[];
        DateTime paymentDate = startDate;
        while (paymentDate.isBefore(now)) {
          paymentHistory.add(
            PaymentRecord(
              id: 'pay_${now.millisecondsSinceEpoch}_$i${paymentHistory.length}',
              date: paymentDate,
              amount: amount,
              successful: _random.nextDouble() > 0.05, // 95% success rate
            ),
          );
          switch (recurrence) {
            case RecurrenceType.weekly:
              paymentDate = paymentDate.add(const Duration(days: 7));
              break;
            case RecurrenceType.monthly:
              paymentDate = DateTime(
                paymentDate.year,
                paymentDate.month + 1,
                paymentDate.day,
              );
              break;
            default:
              paymentDate = paymentDate.add(const Duration(days: 30));
          }
        }

        // Generate usage logs
        final usageLogs = <UsageLog>[];
        for (int j = 0; j < _random.nextInt(30) + 5; j++) {
          usageLogs.add(
            UsageLog(
              date: now.subtract(Duration(days: j)),
              usageMinutes: _random.nextInt(180) + 5,
            ),
          );
        }

        final subscription = SubscriptionModel(
          id: 'debug_${now.millisecondsSinceEpoch}_$i',
          name: brand,
          description: 'Debug sample subscription for $brand',
          amount: amount,
          currencyCode: 'INR',
          recurrenceType: recurrence,
          startDate: startDate,
          nextBillingDate: nextBilling,
          status: status,
          category: category,
          paymentMethod: PaymentMethod
              .values[_random.nextInt(PaymentMethod.values.length)],
          isTrial: status == SubscriptionStatus.trial,
          trialEndDate: status == SubscriptionStatus.trial
              ? now.add(Duration(days: _random.nextInt(14) + 1))
              : null,
          tags: _generateRandomTags(),
          notificationPreference: NotificationPreference(
            enabled: true,
            daysBefore: [7, 3, 1],
          ),
          paymentHistory: paymentHistory,
          usageLogs: usageLogs,
          autoRenew: _random.nextBool(),
        );

        await repo.add(subscription);
        created++;
        _log(
          'Created: $brand (₹${amount.toStringAsFixed(0)}/${_getRecurrenceLabel(recurrence)})',
        );
      }

      // Refresh controller
      await Get.find<SubscriptionController>().refresh();

      _log('✅ Successfully created $created subscriptions');
      return created;
    } catch (e) {
      _log('❌ Error generating subscriptions: $e');
      return 0;
    } finally {
      isLoading.value = false;
    }
  }

  List<String> _generateRandomTags() {
    final allTags = [
      'essential',
      'entertainment',
      'work',
      'family',
      'personal',
      'can-cancel',
      'shared',
      'annual-save',
      'student-discount',
    ];
    final count = _random.nextInt(3);
    return List.generate(
      count,
      (_) => allTags[_random.nextInt(allTags.length)],
    );
  }

  String _getRecurrenceLabel(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.weekly:
        return 'week';
      case RecurrenceType.monthly:
        return 'month';
      case RecurrenceType.quarterly:
        return 'quarter';
      case RecurrenceType.annual:
        return 'year';
      default:
        return 'month';
    }
  }

  /// Clear all sample/debug subscriptions
  Future<int> clearDebugSubscriptions() async {
    isLoading.value = true;
    _log('Clearing debug subscriptions...');

    try {
      final repo = Get.find<SubscriptionRepository>();
      final all = repo.getAll();
      int deleted = 0;

      for (final sub in all) {
        if (sub.id.startsWith('debug_')) {
          await repo.delete(sub.id);
          deleted++;
        }
      }

      await Get.find<SubscriptionController>().refresh();
      _log('✅ Deleted $deleted debug subscriptions');
      return deleted;
    } catch (e) {
      _log('❌ Error clearing subscriptions: $e');
      return 0;
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear ALL subscriptions (use with caution!)
  Future<int> clearAllSubscriptions() async {
    isLoading.value = true;
    _log('⚠️ Clearing ALL subscriptions...');

    try {
      final repo = Get.find<SubscriptionRepository>();
      final all = repo.getAll();

      for (final sub in all) {
        await repo.delete(sub.id);
      }

      await Get.find<SubscriptionController>().refresh();
      _log('✅ Deleted all ${all.length} subscriptions');
      return all.length;
    } catch (e) {
      _log('❌ Error: $e');
      return 0;
    } finally {
      isLoading.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTIFICATION TESTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Test instant notification
  Future<void> testInstantNotification() async {
    _log('Sending instant test notification...');

    try {
      await NotificationService.flutterLocalNotificationsPlugin.show(
        9999,
        '🧪 Test Notification',
        'This is a test notification from SubTrak debug mode',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'debug_channel',
            'Debug Notifications',
            channelDescription: 'Debug and test notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
      _log('✅ Instant notification sent');
    } catch (e) {
      _log('❌ Notification error: $e');
    }
  }

  /// Test scheduled notification (1 minute from now)
  Future<void> testScheduledNotification() async {
    _log('Scheduling notification for 1 minute from now...');

    try {
      await NotificationService.scheduleBillReminder(
        id: 9998,
        title: 'Test Subscription',
        dueDate: DateTime.now().add(const Duration(days: 1, minutes: 1)),
      );
      _log('✅ Scheduled notification for ~1 minute from now');
    } catch (e) {
      _log('❌ Schedule error: $e');
    }
  }

  /// Get all pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    _log('Fetching pending notifications...');

    try {
      final pending = await NotificationService.flutterLocalNotificationsPlugin
          .pendingNotificationRequests();
      _log('Found ${pending.length} pending notifications');

      for (final n in pending) {
        _log('  ID: ${n.id}, Title: ${n.title}');
      }

      return pending;
    } catch (e) {
      _log('❌ Error: $e');
      return [];
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    _log('Cancelling all notifications...');

    try {
      await NotificationService.flutterLocalNotificationsPlugin.cancelAll();
      _log('✅ All notifications cancelled');
    } catch (e) {
      _log('❌ Error: $e');
    }
  }

  /// Schedule notifications for upcoming bills
  Future<int> scheduleUpcomingBillNotifications() async {
    _log('Scheduling notifications for all upcoming bills...');

    try {
      final controller = Get.find<SubscriptionController>();
      final upcoming = controller.upcomingSubscriptions;
      int scheduled = 0;

      for (final sub in upcoming) {
        try {
          await NotificationService.scheduleBillReminder(
            id: sub.id.hashCode,
            title: sub.name,
            dueDate: sub.nextBillingDate,
          );
          scheduled++;
          _log(
            'Scheduled: ${sub.name} (${sub.nextBillingDate.toString().substring(0, 10)})',
          );
        } catch (e) {
          _log('Failed: ${sub.name} - $e');
        }
      }

      _log('✅ Scheduled $scheduled notifications');
      return scheduled;
    } catch (e) {
      _log('❌ Error: $e');
      return 0;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DATABASE TESTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get database statistics
  Future<Map<String, dynamic>> getDatabaseStats() async {
    _log('Fetching database statistics...');

    try {
      final subRepo = Get.find<SubscriptionRepository>();
      final insightRepo = Get.find<InsightRepository>();
      final settingsRepo = Get.find<SettingsRepository>();

      final subscriptions = subRepo.getAll();
      final insights = insightRepo.getAll();
      // Settings loaded to verify connection
      settingsRepo.getSettings();

      final stats = {
        'subscriptions': subscriptions.length,
        'active': subscriptions
            .where((s) => s.status == SubscriptionStatus.active)
            .length,
        'paused': subscriptions
            .where((s) => s.status == SubscriptionStatus.paused)
            .length,
        'trials': subscriptions
            .where((s) => s.status == SubscriptionStatus.trial)
            .length,
        'cancelled': subscriptions
            .where((s) => s.status == SubscriptionStatus.cancelled)
            .length,
        'insights': insights.length,
        'totalMonthlySpend': subscriptions
            .where((s) => s.status == SubscriptionStatus.active)
            .fold<double>(0, (sum, s) => sum + s.monthlyEquivalent),
        'hasSettings': true,
        'debugSubscriptions': subscriptions
            .where((s) => s.id.startsWith('debug_'))
            .length,
      };

      _log(
        'Stats: ${stats.entries.map((e) => '${e.key}=${e.value}').join(', ')}',
      );
      return stats;
    } catch (e) {
      _log('❌ Error: $e');
      return {};
    }
  }

  /// Generate sample insights
  Future<int> generateSampleInsights() async {
    _log('Generating sample insights...');

    try {
      final repo = Get.find<InsightRepository>();
      final now = DateTime.now();

      final sampleInsights = [
        InsightModel(
          id: 'insight_${now.millisecondsSinceEpoch}_1',
          type: InsightType.costSaving,
          title: 'Switch to Annual Plan',
          description:
              'You could save ₹1,200/year by switching Netflix to annual billing',
          priority: InsightPriority.high,
          potentialSavings: 1200.0,
          createdAt: now,
          expiresAt: now.add(const Duration(days: 30)),
        ),
        InsightModel(
          id: 'insight_${now.millisecondsSinceEpoch}_2',
          type: InsightType.unusedSubscription,
          title: 'Low Usage Detected',
          description: 'You haven\'t used Spotify in the last 30 days',
          priority: InsightPriority.medium,
          potentialSavings: 119.0,
          createdAt: now,
          expiresAt: now.add(const Duration(days: 14)),
        ),
        InsightModel(
          id: 'insight_${now.millisecondsSinceEpoch}_3',
          type: InsightType.duplicateService,
          title: 'Duplicate Streaming Services',
          description:
              'You have 3 video streaming services. Consider consolidating.',
          priority: InsightPriority.low,
          potentialSavings: 500.0,
          createdAt: now,
          expiresAt: now.add(const Duration(days: 60)),
        ),
        InsightModel(
          id: 'insight_${now.millisecondsSinceEpoch}_4',
          type: InsightType.priceIncrease,
          title: 'Price Increase Alert',
          description: 'YouTube Premium increased prices by 20% this month',
          priority: InsightPriority.high,
          createdAt: now,
          expiresAt: now.add(const Duration(days: 7)),
        ),
        InsightModel(
          id: 'insight_${now.millisecondsSinceEpoch}_5',
          type: InsightType.trialEnding,
          title: 'Trial Ending Soon',
          description: 'Your HBO Max trial ends in 3 days',
          priority: InsightPriority.high,
          createdAt: now,
          expiresAt: now.add(const Duration(days: 3)),
        ),
      ];

      for (final insight in sampleInsights) {
        await repo.add(insight);
        _log('Created insight: ${insight.title}');
      }

      _log('✅ Created ${sampleInsights.length} sample insights');
      return sampleInsights.length;
    } catch (e) {
      _log('❌ Error: $e');
      return 0;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FEATURE TESTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Test all premium features
  Future<Map<String, bool>> testPremiumFeatures() async {
    _log('Testing premium features...');

    final results = <String, bool>{};

    // Test Analytics
    try {
      final controller = Get.find<SubscriptionController>();
      final stats = controller.subscriptionStats;
      results['analytics'] = stats.isNotEmpty;
      _log('Analytics: ${results['analytics'] == true ? '✅' : '❌'}');
    } catch (e) {
      results['analytics'] = false;
      _log('Analytics: ❌ $e');
    }

    // Test Category Breakdown
    try {
      final controller = Get.find<SubscriptionController>();
      final byCategory = controller.spendByCategory;
      results['categoryBreakdown'] = true;
      _log('Category Breakdown: ✅ (${byCategory.length} categories)');
    } catch (e) {
      results['categoryBreakdown'] = false;
      _log('Category Breakdown: ❌ $e');
    }

    // Test Upcoming Subscriptions
    try {
      final controller = Get.find<SubscriptionController>();
      final upcoming = controller.upcomingSubscriptions;
      results['upcomingBills'] = true;
      _log('Upcoming Bills: ✅ (${upcoming.length} upcoming)');
    } catch (e) {
      results['upcomingBills'] = false;
      _log('Upcoming Bills: ❌ $e');
    }

    // Test Summary Calculation
    try {
      final controller = Get.find<SubscriptionController>();
      final summary = controller.summary.value;
      results['summaryCalculation'] = summary.totalMonthly >= 0;
      _log('Summary: ✅ (₹${summary.totalMonthly.toStringAsFixed(0)}/month)');
    } catch (e) {
      results['summaryCalculation'] = false;
      _log('Summary: ❌ $e');
    }

    // Test Notifications Permission
    try {
      final pending = await NotificationService.flutterLocalNotificationsPlugin
          .pendingNotificationRequests();
      results['notifications'] = true;
      _log('Notifications: ✅ (${pending.length} pending)');
    } catch (e) {
      results['notifications'] = false;
      _log('Notifications: ❌ $e');
    }

    final passed = results.values.where((v) => v).length;
    _log('Feature test complete: $passed/${results.length} passed');

    return results;
  }

  /// Stress test - generate many subscriptions
  Future<void> runStressTest({int count = 100}) async {
    _log('🏋️ Starting stress test with $count subscriptions...');

    final stopwatch = Stopwatch()..start();

    await generateSampleSubscriptions(count: count);

    stopwatch.stop();
    _log('✅ Stress test complete in ${stopwatch.elapsedMilliseconds}ms');
  }

  /// Validate all subscriptions data integrity
  Future<Map<String, int>> validateDataIntegrity() async {
    _log('Validating data integrity...');

    final issues = <String, int>{
      'missingName': 0,
      'invalidAmount': 0,
      'pastNextBilling': 0,
      'invalidDates': 0,
    };

    try {
      final repo = Get.find<SubscriptionRepository>();
      final all = repo.getAll();
      final now = DateTime.now();

      for (final sub in all) {
        if (sub.name.isEmpty)
          issues['missingName'] = issues['missingName']! + 1;
        if (sub.amount < 0)
          issues['invalidAmount'] = issues['invalidAmount']! + 1;
        if (sub.nextBillingDate.isBefore(now) &&
            sub.status == SubscriptionStatus.active) {
          issues['pastNextBilling'] = issues['pastNextBilling']! + 1;
        }
        if (sub.startDate.isAfter(sub.nextBillingDate)) {
          issues['invalidDates'] = issues['invalidDates']! + 1;
        }
      }

      final totalIssues = issues.values.fold<int>(0, (a, b) => a + b);
      if (totalIssues == 0) {
        _log('✅ Data integrity check passed (${all.length} subscriptions)');
      } else {
        _log('⚠️ Found $totalIssues data issues');
        issues.forEach((key, value) {
          if (value > 0) _log('  $key: $value');
        });
      }

      return issues;
    } catch (e) {
      _log('❌ Error: $e');
      return issues;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EXPORT/IMPORT FOR TESTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Export current state for debugging
  Future<Map<String, dynamic>> exportDebugState() async {
    _log('Exporting debug state...');

    try {
      final controller = Get.find<SubscriptionController>();

      return {
        'timestamp': DateTime.now().toIso8601String(),
        'subscriptionCount': controller.subscriptions.length,
        'summary': {
          'monthly': controller.summary.value.totalMonthly,
          'annual': controller.summary.value.totalYearly,
        },
        'stats': controller.subscriptionStats,
        'categories': controller.spendByCategory.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
        'recentLogs': logs.take(50).toList(),
      };
    } catch (e) {
      _log('❌ Error: $e');
      return {'error': e.toString()};
    }
  }
}
