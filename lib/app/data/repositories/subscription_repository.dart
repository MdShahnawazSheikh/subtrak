import 'package:hive/hive.dart';
import '../models/subscription_model.dart';
import '../models/insight_model.dart';
import '../database/database_service.dart';

/// Repository for subscription data operations
class SubscriptionRepository {
  Box get _box => DatabaseService.subscriptions;

  /// Get all subscriptions
  List<SubscriptionModel> getAll() {
    return _box.values.whereType<SubscriptionModel>().toList();
  }

  /// Get active subscriptions (not archived, not cancelled)
  List<SubscriptionModel> getActive() {
    return getAll()
        .where(
          (s) =>
              !s.isArchived &&
              s.status != SubscriptionStatus.cancelled &&
              s.status != SubscriptionStatus.expired,
        )
        .toList();
  }

  /// Get subscription by ID
  SubscriptionModel? getById(String id) {
    final data = _box.get(id);
    return data is SubscriptionModel ? data : null;
  }

  /// Add new subscription
  Future<void> add(SubscriptionModel subscription) async {
    await _box.put(subscription.id, subscription);
    await _logAudit(
      AuditAction.create,
      subscription.id,
      subscription.name,
      null,
      {'name': subscription.name, 'amount': subscription.amount},
    );
  }

  /// Update subscription
  Future<void> update(SubscriptionModel subscription) async {
    final existing = getById(subscription.id);
    final previous = existing != null
        ? {
            'name': existing.name,
            'amount': existing.amount,
            'status': existing.status.index,
          }
        : null;

    await _box.put(subscription.id, subscription);
    await _logAudit(
      AuditAction.update,
      subscription.id,
      subscription.name,
      previous,
      {
        'name': subscription.name,
        'amount': subscription.amount,
        'status': subscription.status.index,
      },
    );
  }

  /// Delete subscription
  Future<void> delete(String id) async {
    final existing = getById(id);
    await _box.delete(id);
    if (existing != null) {
      await _logAudit(AuditAction.delete, id, existing.name, {
        'name': existing.name,
        'amount': existing.amount,
      }, null);
    }
  }

  /// Pause subscription
  Future<void> pause(String id, {DateTime? resumeAt}) async {
    final subscription = getById(id);
    if (subscription != null) {
      final updated = subscription.copyWith(
        isPaused: true,
        pausedAt: DateTime.now(),
        resumeAt: resumeAt,
        status: SubscriptionStatus.paused,
      );
      await _box.put(id, updated);
      await _logAudit(
        AuditAction.pause,
        id,
        subscription.name,
        {'status': subscription.status.index},
        {
          'status': SubscriptionStatus.paused.index,
          'pausedAt': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  /// Resume subscription
  Future<void> resume(String id) async {
    final subscription = getById(id);
    if (subscription != null) {
      final updated = subscription.copyWith(
        isPaused: false,
        pausedAt: null,
        resumeAt: null,
        status: SubscriptionStatus.active,
      );
      await _box.put(id, updated);
      await _logAudit(
        AuditAction.resume,
        id,
        subscription.name,
        {'status': subscription.status.index},
        {'status': SubscriptionStatus.active.index},
      );
    }
  }

  /// Archive subscription
  Future<void> archive(String id) async {
    final subscription = getById(id);
    if (subscription != null) {
      final updated = subscription.copyWith(isArchived: true);
      await _box.put(id, updated);
      await _logAudit(
        AuditAction.archive,
        id,
        subscription.name,
        {'isArchived': false},
        {'isArchived': true},
      );
    }
  }

  /// Restore archived subscription
  Future<void> restore(String id) async {
    final subscription = getById(id);
    if (subscription != null) {
      final updated = subscription.copyWith(isArchived: false);
      await _box.put(id, updated);
      await _logAudit(
        AuditAction.restore,
        id,
        subscription.name,
        {'isArchived': true},
        {'isArchived': false},
      );
    }
  }

  /// Get subscriptions by category
  List<SubscriptionModel> getByCategory(SubscriptionCategory category) {
    return getAll()
        .where((s) => s.category == category && !s.isArchived)
        .toList();
  }

  /// Get subscriptions by status
  List<SubscriptionModel> getByStatus(SubscriptionStatus status) {
    return getAll().where((s) => s.status == status && !s.isArchived).toList();
  }

  /// Get subscriptions by tag
  List<SubscriptionModel> getByTag(String tag) {
    return getAll()
        .where((s) => s.tags.contains(tag) && !s.isArchived)
        .toList();
  }

  /// Get upcoming bills in next N days
  List<SubscriptionModel> getUpcoming({int days = 30}) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));
    return getActive()
        .where(
          (s) =>
              s.nextBillingDate.isAfter(
                now.subtract(const Duration(days: 1)),
              ) &&
              s.nextBillingDate.isBefore(endDate),
        )
        .toList()
      ..sort((a, b) => a.nextBillingDate.compareTo(b.nextBillingDate));
  }

  /// Get overdue subscriptions
  List<SubscriptionModel> getOverdue() {
    final now = DateTime.now();
    return getActive().where((s) => s.nextBillingDate.isBefore(now)).toList()
      ..sort((a, b) => a.nextBillingDate.compareTo(b.nextBillingDate));
  }

  /// Get trials ending soon
  List<SubscriptionModel> getTrialsEndingSoon({int days = 7}) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));
    return getActive()
        .where(
          (s) =>
              s.isTrial &&
              s.trialEndDate != null &&
              s.trialEndDate!.isAfter(now) &&
              s.trialEndDate!.isBefore(endDate),
        )
        .toList()
      ..sort((a, b) => a.trialEndDate!.compareTo(b.trialEndDate!));
  }

  /// Get total monthly spend
  double getTotalMonthlySpend() {
    return getActive().fold(0.0, (sum, s) => sum + s.monthlyEquivalent);
  }

  /// Get total annual spend
  double getTotalAnnualSpend() {
    return getActive().fold(0.0, (sum, s) => sum + s.annualCost);
  }

  /// Get spend by category
  Map<SubscriptionCategory, double> getSpendByCategory() {
    final map = <SubscriptionCategory, double>{};
    for (final sub in getActive()) {
      map[sub.category] = (map[sub.category] ?? 0) + sub.monthlyEquivalent;
    }
    return map;
  }

  /// Get subscriptions due on a specific date
  List<SubscriptionModel> getDueOn(DateTime date) {
    return getActive()
        .where(
          (s) =>
              s.nextBillingDate.year == date.year &&
              s.nextBillingDate.month == date.month &&
              s.nextBillingDate.day == date.day,
        )
        .toList();
  }

  /// Get subscriptions in date range
  List<SubscriptionModel> getInDateRange(DateTime start, DateTime end) {
    return getActive()
        .where(
          (s) =>
              s.nextBillingDate.isAfter(
                start.subtract(const Duration(days: 1)),
              ) &&
              s.nextBillingDate.isBefore(end.add(const Duration(days: 1))),
        )
        .toList();
  }

  /// Search subscriptions
  List<SubscriptionModel> search(String query) {
    final lowerQuery = query.toLowerCase();
    return getAll().where((s) {
      return s.name.toLowerCase().contains(lowerQuery) ||
          (s.description?.toLowerCase().contains(lowerQuery) ?? false) ||
          s.tags.any((t) => t.toLowerCase().contains(lowerQuery)) ||
          (s.notes?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Get all unique tags
  Set<String> getAllTags() {
    final tags = <String>{};
    for (final sub in getAll()) {
      tags.addAll(sub.tags);
    }
    return tags;
  }

  /// Bulk pause subscriptions
  Future<void> bulkPause(List<String> ids) async {
    for (final id in ids) {
      await pause(id);
    }
  }

  /// Bulk resume subscriptions
  Future<void> bulkResume(List<String> ids) async {
    for (final id in ids) {
      await resume(id);
    }
  }

  /// Bulk delete subscriptions
  Future<void> bulkDelete(List<String> ids) async {
    for (final id in ids) {
      await delete(id);
    }
  }

  /// Bulk archive subscriptions
  Future<void> bulkArchive(List<String> ids) async {
    for (final id in ids) {
      await archive(id);
    }
  }

  /// Log usage for subscription
  Future<void> logUsage(String id, int minutes, {String? note}) async {
    final subscription = getById(id);
    if (subscription != null) {
      final newLog = UsageLog(
        date: DateTime.now(),
        usageMinutes: minutes,
        note: note,
      );
      final updatedLogs = [...subscription.usageLogs, newLog];
      final updated = subscription.copyWith(usageLogs: updatedLogs);
      await _box.put(id, updated);
    }
  }

  /// Record payment
  Future<void> recordPayment(
    String subscriptionId, {
    required double amount,
    bool successful = true,
    String? failureReason,
    String? transactionId,
  }) async {
    final subscription = getById(subscriptionId);
    if (subscription != null) {
      final record = PaymentRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        amount: amount,
        successful: successful,
        failureReason: failureReason,
        transactionId: transactionId,
      );
      final updatedRecords = [...subscription.paymentHistory, record];

      // Also update next billing date if payment was successful
      DateTime? newNextBilling;
      if (successful) {
        newNextBilling = subscription.calculateNextBillingDate(
          subscription.nextBillingDate,
        );
      }

      final updated = subscription.copyWith(
        paymentHistory: updatedRecords,
        nextBillingDate: newNextBilling ?? subscription.nextBillingDate,
        status: successful
            ? SubscriptionStatus.active
            : SubscriptionStatus.paymentFailed,
      );
      await _box.put(subscriptionId, updated);
    }
  }

  /// Update price with history tracking
  Future<void> updatePrice(String id, double newAmount, {String? note}) async {
    final subscription = getById(id);
    if (subscription != null) {
      // Close current price tier
      final now = DateTime.now();
      final updatedHistory = subscription.priceHistory.map((tier) {
        if (tier.endDate == null) {
          return PriceTier(
            amount: tier.amount,
            startDate: tier.startDate,
            endDate: now,
            note: tier.note,
          );
        }
        return tier;
      }).toList();

      // Add new price tier
      updatedHistory.add(
        PriceTier(amount: newAmount, startDate: now, note: note),
      );

      final updated = subscription.copyWith(
        amount: newAmount,
        priceHistory: updatedHistory,
      );
      await _box.put(id, updated);
    }
  }

  /// Clone subscription
  Future<SubscriptionModel?> clone(String id) async {
    final original = getById(id);
    if (original == null) return null;

    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final cloned = original.copyWith(
      id: newId,
      name: '${original.name} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      usageLogs: [],
      paymentHistory: [],
    );
    await add(cloned);
    return cloned;
  }

  /// Log audit entry
  Future<void> _logAudit(
    AuditAction action,
    String entityId,
    String? entityName,
    Map<String, dynamic>? previous,
    Map<String, dynamic>? newState,
  ) async {
    final entry = AuditLogEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      action: action,
      entityType: 'subscription',
      entityId: entityId,
      entityName: entityName,
      previousState: previous,
      newState: newState,
    );
    await DatabaseService.auditLog.put(entry.id, entry);
  }
}
