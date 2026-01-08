import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../data/models/subscription_model.dart';
import '../data/models/insight_model.dart';
import '../data/models/user_settings_model.dart';
import '../data/repositories/subscription_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/services/intelligence_engine.dart';
import '../services/advanced_notification_service.dart';

/// Main controller for subscription management
class SubscriptionController extends GetxController {
  final SubscriptionRepository _subscriptionRepo = Get.find();
  final SettingsRepository _settingsRepo = Get.find();
  final InsightRepository _insightRepo = Get.find();
  final IntelligenceEngine _intelligenceEngine = Get.find();

  // Observable lists
  final RxList<SubscriptionModel> subscriptions = <SubscriptionModel>[].obs;
  final RxList<SubscriptionModel> filteredSubscriptions =
      <SubscriptionModel>[].obs;
  final RxList<InsightModel> insights = <InsightModel>[].obs;
  final Rx<UserSettingsModel?> settings = Rx(null);

  // UI state
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final Rx<SubscriptionCategory?> filterCategory = Rx(null);
  final Rx<SubscriptionStatus?> filterStatus = Rx(null);
  final RxList<String> filterTags = <String>[].obs;
  final RxString sortBy = 'nextBilling'.obs;
  final RxBool sortAscending = true.obs;

  // Summary data
  final RxDouble totalMonthlySpend = 0.0.obs;
  final RxDouble totalAnnualSpend = 0.0.obs;
  final RxInt activeCount = 0.obs;
  final RxInt upcomingThisWeek = 0.obs;
  final RxDouble potentialSavings = 0.0.obs;

  /// Reactive summary for UI
  final Rx<SubscriptionSummary> summary = SubscriptionSummary.empty().obs;

  /// Get subscription stats map (reactive - reads from observable subscriptions)
  Map<String, int> get subscriptionStats {
    // Access subscriptions.length to trigger reactivity
    final allSubs = subscriptions.toList();
    final active = allSubs
        .where((s) => s.status == SubscriptionStatus.active)
        .length;
    final paused = allSubs
        .where((s) => s.status == SubscriptionStatus.paused)
        .length;
    final trials = allSubs
        .where((s) => s.status == SubscriptionStatus.trial)
        .length;
    final cancelled = allSubs
        .where((s) => s.status == SubscriptionStatus.cancelled)
        .length;
    final expired = allSubs
        .where((s) => s.status == SubscriptionStatus.expired)
        .length;

    return {
      'active': active,
      'paused': paused,
      'trials': trials,
      'cancelled': cancelled,
      'expired': expired,
      'total': allSubs.length,
    };
  }

  /// Get upcoming subscriptions (reactive - computes from observable list)
  List<SubscriptionModel> get upcomingSubscriptions {
    final now = DateTime.now();
    final cutoff = now.add(const Duration(days: 30));
    return subscriptions.where((sub) {
      if (sub.status != SubscriptionStatus.active &&
          sub.status != SubscriptionStatus.trial)
        return false;
      return sub.nextBillingDate.isAfter(now) &&
          sub.nextBillingDate.isBefore(cutoff);
    }).toList()..sort((a, b) => a.nextBillingDate.compareTo(b.nextBillingDate));
  }

  /// Get spend by category (reactive - computes from observable list)
  Map<SubscriptionCategory, double> get spendByCategory {
    final result = <SubscriptionCategory, double>{};
    for (final sub in subscriptions) {
      if (sub.status == SubscriptionStatus.active) {
        result[sub.category] =
            (result[sub.category] ?? 0) + sub.monthlyEquivalent;
      }
    }
    return result;
  }

  /// Set search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Set sort option
  void setSortBy(String field) {
    sortBy.value = field;
  }

  /// Set status filter
  void setStatusFilter(SubscriptionStatus? status) {
    filterStatus.value = status;
  }

  /// Duplicate/clone subscription
  Future<void> duplicateSubscription(String id) async {
    await cloneSubscription(id);
  }

  /// Refresh insights from intelligence engine
  Future<void> refreshInsights() async {
    await runIntelligenceAnalysis();
  }

  @override
  void onInit() {
    super.onInit();
    _loadData();

    // Watch for filter changes
    ever(searchQuery, (_) => _applyFilters());
    ever(filterCategory, (_) => _applyFilters());
    ever(filterStatus, (_) => _applyFilters());
    ever(filterTags, (_) => _applyFilters());
    ever(sortBy, (_) => _applyFilters());
    ever(sortAscending, (_) => _applyFilters());
  }

  /// Load all data
  Future<void> _loadData() async {
    try {
      isLoading.value = true;

      // Load subscriptions
      subscriptions.assignAll(_subscriptionRepo.getAll());

      // Load settings
      settings.value = _settingsRepo.getSettings();

      // Load insights
      insights.assignAll(_insightRepo.getActive());

      // Apply filters
      _applyFilters();

      // Update summary
      _updateSummary();
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await _loadData();
  }

  /// Update summary statistics
  void _updateSummary() {
    totalMonthlySpend.value = _subscriptionRepo.getTotalMonthlySpend();
    totalAnnualSpend.value = _subscriptionRepo.getTotalAnnualSpend();
    activeCount.value = _subscriptionRepo.getActive().length;
    upcomingThisWeek.value = _subscriptionRepo.getUpcoming(days: 7).length;
    potentialSavings.value = _insightRepo.getTotalPotentialSavings();

    // Update summary reactive
    summary.value = SubscriptionSummary(
      totalMonthly: totalMonthlySpend.value,
      totalYearly: totalAnnualSpend.value,
      activeCount: activeCount.value,
      upcomingCount: upcomingThisWeek.value,
      potentialSavings: potentialSavings.value,
    );
  }

  /// Apply all filters and sorting
  void _applyFilters() {
    var result = subscriptions.toList();

    // Apply search
    if (searchQuery.value.isNotEmpty) {
      result = _subscriptionRepo.search(searchQuery.value);
    }

    // Apply category filter
    if (filterCategory.value != null) {
      result = result.where((s) => s.category == filterCategory.value).toList();
    }

    // Apply status filter
    if (filterStatus.value != null) {
      result = result.where((s) => s.status == filterStatus.value).toList();
    }

    // Apply tag filter
    if (filterTags.isNotEmpty) {
      result = result
          .where((s) => filterTags.any((tag) => s.tags.contains(tag)))
          .toList();
    }

    // Apply sorting
    result = _sortSubscriptions(result);

    filteredSubscriptions.assignAll(result);
  }

  /// Sort subscriptions
  List<SubscriptionModel> _sortSubscriptions(List<SubscriptionModel> subs) {
    final sorted = [...subs];

    sorted.sort((a, b) {
      int comparison;
      switch (sortBy.value) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'amount':
          comparison = a.amount.compareTo(b.amount);
          break;
        case 'nextBilling':
          comparison = a.nextBillingDate.compareTo(b.nextBillingDate);
          break;
        case 'monthlyEquivalent':
          comparison = a.monthlyEquivalent.compareTo(b.monthlyEquivalent);
          break;
        case 'createdAt':
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        default:
          comparison = a.nextBillingDate.compareTo(b.nextBillingDate);
      }
      return sortAscending.value ? comparison : -comparison;
    });

    return sorted;
  }

  /// Add new subscription
  Future<void> addSubscription(SubscriptionModel subscription) async {
    await _subscriptionRepo.add(subscription);
    subscriptions.add(subscription);
    _applyFilters();
    _updateSummary();

    // Schedule notifications
    await _scheduleNotifications(subscription);

    // Provide haptic feedback
    if (settings.value?.hapticFeedbackEnabled ?? true) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Update subscription
  Future<void> updateSubscription(SubscriptionModel subscription) async {
    await _subscriptionRepo.update(subscription);
    final index = subscriptions.indexWhere((s) => s.id == subscription.id);
    if (index != -1) {
      subscriptions[index] = subscription;
    }
    _applyFilters();
    _updateSummary();

    // Reschedule notifications
    await _scheduleNotifications(subscription);

    if (settings.value?.hapticFeedbackEnabled ?? true) {
      HapticFeedback.lightImpact();
    }
  }

  /// Delete subscription
  Future<void> deleteSubscription(String id) async {
    await _subscriptionRepo.delete(id);
    subscriptions.removeWhere((s) => s.id == id);
    _applyFilters();
    _updateSummary();

    // Cancel notifications
    await AdvancedNotificationService.cancelSubscriptionReminders(id);

    if (settings.value?.hapticFeedbackEnabled ?? true) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Pause subscription
  Future<void> pauseSubscription(String id, {DateTime? resumeAt}) async {
    await _subscriptionRepo.pause(id, resumeAt: resumeAt);
    final sub = _subscriptionRepo.getById(id);
    if (sub != null) {
      final index = subscriptions.indexWhere((s) => s.id == id);
      if (index != -1) {
        subscriptions[index] = sub;
      }
    }
    _applyFilters();

    await AdvancedNotificationService.cancelSubscriptionReminders(id);

    if (settings.value?.hapticFeedbackEnabled ?? true) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Resume subscription
  Future<void> resumeSubscription(String id) async {
    await _subscriptionRepo.resume(id);
    final sub = _subscriptionRepo.getById(id);
    if (sub != null) {
      final index = subscriptions.indexWhere((s) => s.id == id);
      if (index != -1) {
        subscriptions[index] = sub;
      }
      await _scheduleNotifications(sub);
    }
    _applyFilters();

    if (settings.value?.hapticFeedbackEnabled ?? true) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Archive subscription
  Future<void> archiveSubscription(String id) async {
    await _subscriptionRepo.archive(id);
    final sub = _subscriptionRepo.getById(id);
    if (sub != null) {
      final index = subscriptions.indexWhere((s) => s.id == id);
      if (index != -1) {
        subscriptions[index] = sub;
      }
    }
    _applyFilters();
    _updateSummary();

    await AdvancedNotificationService.cancelSubscriptionReminders(id);
  }

  /// Clone subscription
  Future<SubscriptionModel?> cloneSubscription(String id) async {
    final cloned = await _subscriptionRepo.clone(id);
    if (cloned != null) {
      subscriptions.add(cloned);
      _applyFilters();
      _updateSummary();
    }
    return cloned;
  }

  /// Log usage for subscription
  Future<void> logUsage(String id, int minutes, {String? note}) async {
    await _subscriptionRepo.logUsage(id, minutes, note: note);
    final sub = _subscriptionRepo.getById(id);
    if (sub != null) {
      final index = subscriptions.indexWhere((s) => s.id == id);
      if (index != -1) {
        subscriptions[index] = sub;
      }
    }
  }

  /// Record payment
  Future<void> recordPayment(
    String subscriptionId, {
    required double amount,
    bool successful = true,
    String? failureReason,
  }) async {
    await _subscriptionRepo.recordPayment(
      subscriptionId,
      amount: amount,
      successful: successful,
      failureReason: failureReason,
    );
    await refresh();
  }

  /// Bulk operations
  Future<void> bulkPause(List<String> ids) async {
    await _subscriptionRepo.bulkPause(ids);
    await refresh();
  }

  Future<void> bulkResume(List<String> ids) async {
    await _subscriptionRepo.bulkResume(ids);
    await refresh();
  }

  Future<void> bulkDelete(List<String> ids) async {
    await _subscriptionRepo.bulkDelete(ids);
    await refresh();
  }

  Future<void> bulkArchive(List<String> ids) async {
    await _subscriptionRepo.bulkArchive(ids);
    await refresh();
  }

  /// Get subscriptions for calendar
  List<SubscriptionModel> getSubscriptionsForDate(DateTime date) {
    return _subscriptionRepo.getDueOn(date);
  }

  /// Get subscriptions for date range
  List<SubscriptionModel> getSubscriptionsInRange(
    DateTime start,
    DateTime end,
  ) {
    return _subscriptionRepo.getInDateRange(start, end);
  }

  /// Get upcoming subscriptions
  List<SubscriptionModel> getUpcoming({int days = 30}) {
    return _subscriptionRepo.getUpcoming(days: days);
  }

  /// Get overdue subscriptions
  List<SubscriptionModel> getOverdue() {
    return _subscriptionRepo.getOverdue();
  }

  /// Get spend by category
  Map<SubscriptionCategory, double> getSpendByCategory() {
    return _subscriptionRepo.getSpendByCategory();
  }

  /// Get all tags
  Set<String> getAllTags() {
    return _subscriptionRepo.getAllTags();
  }

  /// Run intelligence analysis
  Future<void> runIntelligenceAnalysis() async {
    final newInsights = await _intelligenceEngine.runFullAnalysis();
    insights.assignAll(_insightRepo.getActive());
    potentialSavings.value = _insightRepo.getTotalPotentialSavings();

    // Show notification if there are high priority insights
    final criticalInsights = newInsights
        .where((i) => i.priority == InsightPriority.critical)
        .toList();
    if (criticalInsights.isNotEmpty) {
      await AdvancedNotificationService.showCriticalAlert(
        title: '${criticalInsights.length} important insights',
        body: criticalInsights.first.title,
      );
    }
  }

  /// Get monthly summary
  MonthlySummary getMonthlySummary() {
    return _intelligenceEngine.getMonthlySummary();
  }

  /// Get spend preview
  SpendPreview getSpendPreview({int days = 30}) {
    return _intelligenceEngine.getSpendPreview(days: days);
  }

  /// Calculate worth it score
  int getWorthItScore(SubscriptionModel subscription) {
    return _intelligenceEngine.calculateWorthItScore(subscription);
  }

  /// Dismiss insight
  Future<void> dismissInsight(String id) async {
    await _insightRepo.dismiss(id);
    insights.assignAll(_insightRepo.getActive());
    potentialSavings.value = _insightRepo.getTotalPotentialSavings();
  }

  /// Action insight
  Future<void> actionInsight(String id, InsightActionType actionType) async {
    await _insightRepo.markActioned(id, actionType);
    insights.assignAll(_insightRepo.getActive());
    potentialSavings.value = _insightRepo.getTotalPotentialSavings();
  }

  /// Schedule notifications for subscription
  Future<void> _scheduleNotifications(SubscriptionModel subscription) async {
    if (subscription.status != SubscriptionStatus.active &&
        subscription.status != SubscriptionStatus.trial) {
      return;
    }

    try {
      await AdvancedNotificationService.scheduleBillReminders(
        subscription: subscription,
        preferences: subscription.notificationPreference,
        globalSettings: settings.value?.notificationSettings,
      );

      if (subscription.isTrial) {
        await AdvancedNotificationService.scheduleTrialEndingReminder(
          subscription,
        );
      }
    } catch (e) {
      debugPrint('Failed to schedule notifications: $e');
    }
  }

  /// Reschedule all notifications
  Future<void> rescheduleAllNotifications() async {
    await AdvancedNotificationService.rescheduleAll(subscriptions);
  }

  /// Check notification health
  Future<NotificationHealth> checkNotificationHealth() async {
    return await AdvancedNotificationService.checkHealth(subscriptions);
  }

  /// Clear all filters
  void clearFilters() {
    searchQuery.value = '';
    filterCategory.value = null;
    filterStatus.value = null;
    filterTags.clear();
    sortBy.value = 'nextBilling';
    sortAscending.value = true;
  }

  /// Get subscription by ID
  SubscriptionModel? getById(String id) {
    return _subscriptionRepo.getById(id);
  }
}

/// Summary model for subscription statistics
class SubscriptionSummary {
  final double totalMonthly;
  final double totalYearly;
  final int activeCount;
  final int upcomingCount;
  final double potentialSavings;

  const SubscriptionSummary({
    required this.totalMonthly,
    required this.totalYearly,
    required this.activeCount,
    required this.upcomingCount,
    required this.potentialSavings,
  });

  factory SubscriptionSummary.empty() => const SubscriptionSummary(
    totalMonthly: 0,
    totalYearly: 0,
    activeCount: 0,
    upcomingCount: 0,
    potentialSavings: 0,
  );
}
