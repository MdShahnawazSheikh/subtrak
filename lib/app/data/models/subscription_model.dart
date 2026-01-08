import 'dart:ui';
import 'package:hive/hive.dart';

part 'subscription_model.g.dart';

/// Recurrence types for subscriptions
@HiveType(typeId: 10)
enum RecurrenceType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  biWeekly,
  @HiveField(3)
  monthly,
  @HiveField(4)
  biMonthly,
  @HiveField(5)
  quarterly,
  @HiveField(6)
  semiAnnual,
  @HiveField(7)
  annual,
  @HiveField(8)
  custom,
  @HiveField(9)
  oneTime,
}

/// Subscription status
@HiveType(typeId: 11)
enum SubscriptionStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  paused,
  @HiveField(2)
  cancelled,
  @HiveField(3)
  trial,
  @HiveField(4)
  expired,
  @HiveField(5)
  pendingCancellation,
  @HiveField(6)
  paymentFailed,
  @HiveField(7)
  gracePeriod,
}

/// Payment method types
@HiveType(typeId: 12)
enum PaymentMethod {
  @HiveField(0)
  creditCard,
  @HiveField(1)
  debitCard,
  @HiveField(2)
  upi,
  @HiveField(3)
  netBanking,
  @HiveField(4)
  wallet,
  @HiveField(5)
  autoPay,
  @HiveField(6)
  manual,
  @HiveField(7)
  other,
}

/// Subscription category
@HiveType(typeId: 13)
enum SubscriptionCategory {
  @HiveField(0)
  streaming,
  @HiveField(1)
  music,
  @HiveField(2)
  gaming,
  @HiveField(3)
  productivity,
  @HiveField(4)
  cloud,
  @HiveField(5)
  news,
  @HiveField(6)
  fitness,
  @HiveField(7)
  education,
  @HiveField(8)
  finance,
  @HiveField(9)
  utilities,
  @HiveField(10)
  shopping,
  @HiveField(11)
  social,
  @HiveField(12)
  food,
  @HiveField(13)
  travel,
  @HiveField(14)
  insurance,
  @HiveField(15)
  telecom,
  @HiveField(16)
  software,
  @HiveField(17)
  other,
}

/// Currency model
@HiveType(typeId: 14)
class CurrencyModel {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String symbol;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final double exchangeRateToBase;

  const CurrencyModel({
    required this.code,
    required this.symbol,
    required this.name,
    this.exchangeRateToBase = 1.0,
  });

  static const CurrencyModel inr = CurrencyModel(
    code: 'INR',
    symbol: '₹',
    name: 'Indian Rupee',
    exchangeRateToBase: 1.0,
  );

  static const CurrencyModel usd = CurrencyModel(
    code: 'USD',
    symbol: '\$',
    name: 'US Dollar',
    exchangeRateToBase: 83.0,
  );

  static const CurrencyModel eur = CurrencyModel(
    code: 'EUR',
    symbol: '€',
    name: 'Euro',
    exchangeRateToBase: 90.0,
  );

  static const CurrencyModel gbp = CurrencyModel(
    code: 'GBP',
    symbol: '£',
    name: 'British Pound',
    exchangeRateToBase: 105.0,
  );

  static const List<CurrencyModel> all = [inr, usd, eur, gbp];

  static CurrencyModel fromCode(String code) {
    return all.firstWhere((c) => c.code == code, orElse: () => inr);
  }
}

/// Price tier for price laddering
@HiveType(typeId: 15)
class PriceTier {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final DateTime startDate;

  @HiveField(2)
  final DateTime? endDate;

  @HiveField(3)
  final String? note;

  const PriceTier({
    required this.amount,
    required this.startDate,
    this.endDate,
    this.note,
  });
}

/// Notification preference for a subscription
@HiveType(typeId: 16)
class NotificationPreference {
  @HiveField(0)
  final bool enabled;

  @HiveField(1)
  final List<int> daysBefore; // e.g., [7, 3, 1] for T-7, T-3, T-1

  @HiveField(2)
  final bool criticalAlert;

  @HiveField(3)
  final int? snoozeMinutes;

  @HiveField(4)
  final bool silentMode;

  const NotificationPreference({
    this.enabled = true,
    this.daysBefore = const [7, 3, 1],
    this.criticalAlert = false,
    this.snoozeMinutes,
    this.silentMode = false,
  });

  NotificationPreference copyWith({
    bool? enabled,
    List<int>? daysBefore,
    bool? criticalAlert,
    int? snoozeMinutes,
    bool? silentMode,
  }) {
    return NotificationPreference(
      enabled: enabled ?? this.enabled,
      daysBefore: daysBefore ?? this.daysBefore,
      criticalAlert: criticalAlert ?? this.criticalAlert,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      silentMode: silentMode ?? this.silentMode,
    );
  }
}

/// Usage log entry
@HiveType(typeId: 17)
class UsageLog {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int usageMinutes;

  @HiveField(2)
  final String? note;

  const UsageLog({required this.date, required this.usageMinutes, this.note});
}

/// Payment history entry
@HiveType(typeId: 18)
class PaymentRecord {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final bool successful;

  @HiveField(4)
  final String? failureReason;

  @HiveField(5)
  final String? transactionId;

  const PaymentRecord({
    required this.id,
    required this.date,
    required this.amount,
    this.successful = true,
    this.failureReason,
    this.transactionId,
  });
}

/// Main Subscription Model - comprehensive
@HiveType(typeId: 1)
class SubscriptionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String currencyCode;

  @HiveField(5)
  final RecurrenceType recurrenceType;

  @HiveField(6)
  final int? customRecurrenceDays;

  @HiveField(7)
  final DateTime startDate;

  @HiveField(8)
  final DateTime nextBillingDate;

  @HiveField(9)
  final DateTime? endDate;

  @HiveField(10)
  final SubscriptionStatus status;

  @HiveField(11)
  final SubscriptionCategory category;

  @HiveField(12)
  final PaymentMethod paymentMethod;

  @HiveField(13)
  final String? paymentMethodDetails;

  @HiveField(14)
  final String? iconName;

  @HiveField(15)
  final String? colorHex;

  @HiveField(16)
  final String? websiteUrl;

  @HiveField(17)
  final String? cancellationUrl;

  @HiveField(18)
  final bool isTrial;

  @HiveField(19)
  final DateTime? trialEndDate;

  @HiveField(20)
  final int? gracePeriodDays;

  @HiveField(21)
  final List<PriceTier> priceHistory;

  @HiveField(22)
  final List<UsageLog> usageLogs;

  @HiveField(23)
  final List<PaymentRecord> paymentHistory;

  @HiveField(24)
  final NotificationPreference notificationPreference;

  @HiveField(25)
  final List<String> tags;

  @HiveField(26)
  final String? notes;

  @HiveField(27)
  final bool isPaused;

  @HiveField(28)
  final DateTime? pausedAt;

  @HiveField(29)
  final DateTime? resumeAt;

  @HiveField(30)
  final DateTime createdAt;

  @HiveField(31)
  final DateTime updatedAt;

  @HiveField(32)
  final bool isArchived;

  @HiveField(33)
  final String? linkedSubscriptionId;

  @HiveField(34)
  final bool autoRenew;

  @HiveField(35)
  final String? timezone;

  SubscriptionModel({
    required this.id,
    required this.name,
    this.description,
    required this.amount,
    this.currencyCode = 'INR',
    required this.recurrenceType,
    this.customRecurrenceDays,
    required this.startDate,
    required this.nextBillingDate,
    this.endDate,
    this.status = SubscriptionStatus.active,
    this.category = SubscriptionCategory.other,
    this.paymentMethod = PaymentMethod.other,
    this.paymentMethodDetails,
    this.iconName,
    this.colorHex,
    this.websiteUrl,
    this.cancellationUrl,
    this.isTrial = false,
    this.trialEndDate,
    this.gracePeriodDays,
    this.priceHistory = const [],
    this.usageLogs = const [],
    this.paymentHistory = const [],
    this.notificationPreference = const NotificationPreference(),
    this.tags = const [],
    this.notes,
    this.isPaused = false,
    this.pausedAt,
    this.resumeAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isArchived = false,
    this.linkedSubscriptionId,
    this.autoRenew = true,
    this.timezone,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  CurrencyModel get currency => CurrencyModel.fromCode(currencyCode);

  /// Calculate cost per day based on recurrence
  double get costPerDay {
    switch (recurrenceType) {
      case RecurrenceType.daily:
        return amount;
      case RecurrenceType.weekly:
        return amount / 7;
      case RecurrenceType.biWeekly:
        return amount / 14;
      case RecurrenceType.monthly:
        return amount / 30;
      case RecurrenceType.biMonthly:
        return amount / 60;
      case RecurrenceType.quarterly:
        return amount / 90;
      case RecurrenceType.semiAnnual:
        return amount / 180;
      case RecurrenceType.annual:
        return amount / 365;
      case RecurrenceType.custom:
        return customRecurrenceDays != null && customRecurrenceDays! > 0
            ? amount / customRecurrenceDays!
            : 0;
      case RecurrenceType.oneTime:
        return 0;
    }
  }

  /// Calculate monthly equivalent cost
  double get monthlyEquivalent {
    switch (recurrenceType) {
      case RecurrenceType.daily:
        return amount * 30;
      case RecurrenceType.weekly:
        return amount * 4.33;
      case RecurrenceType.biWeekly:
        return amount * 2.17;
      case RecurrenceType.monthly:
        return amount;
      case RecurrenceType.biMonthly:
        return amount / 2;
      case RecurrenceType.quarterly:
        return amount / 3;
      case RecurrenceType.semiAnnual:
        return amount / 6;
      case RecurrenceType.annual:
        return amount / 12;
      case RecurrenceType.custom:
        return customRecurrenceDays != null && customRecurrenceDays! > 0
            ? (amount / customRecurrenceDays!) * 30
            : 0;
      case RecurrenceType.oneTime:
        return 0;
    }
  }

  /// Calculate annual cost
  double get annualCost {
    switch (recurrenceType) {
      case RecurrenceType.daily:
        return amount * 365;
      case RecurrenceType.weekly:
        return amount * 52;
      case RecurrenceType.biWeekly:
        return amount * 26;
      case RecurrenceType.monthly:
        return amount * 12;
      case RecurrenceType.biMonthly:
        return amount * 6;
      case RecurrenceType.quarterly:
        return amount * 4;
      case RecurrenceType.semiAnnual:
        return amount * 2;
      case RecurrenceType.annual:
        return amount;
      case RecurrenceType.custom:
        return customRecurrenceDays != null && customRecurrenceDays! > 0
            ? (amount / customRecurrenceDays!) * 365
            : 0;
      case RecurrenceType.oneTime:
        return amount;
    }
  }

  /// Days until next billing
  int get daysUntilNextBilling {
    return nextBillingDate.difference(DateTime.now()).inDays;
  }

  /// Is the subscription overdue
  bool get isOverdue {
    return nextBillingDate.isBefore(DateTime.now()) &&
        status == SubscriptionStatus.active;
  }

  /// Is trial ending soon (within 3 days)
  bool get isTrialEndingSoon {
    if (!isTrial || trialEndDate == null) return false;
    final daysLeft = trialEndDate!.difference(DateTime.now()).inDays;
    return daysLeft >= 0 && daysLeft <= 3;
  }

  /// Average usage per month in minutes
  double get averageMonthlyUsage {
    if (usageLogs.isEmpty) return 0;
    final now = DateTime.now();
    final monthLogs = usageLogs
        .where(
          (log) => log.date.isAfter(now.subtract(const Duration(days: 30))),
        )
        .toList();
    if (monthLogs.isEmpty) return 0;
    return monthLogs.fold<int>(0, (sum, log) => sum + log.usageMinutes) /
        monthLogs.length;
  }

  /// Get Color from colorHex
  Color? get color {
    if (colorHex == null) return null;
    try {
      final hex = colorHex!.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return null;
    }
  }

  /// Cost per use (based on usage logs)
  double get costPerUse {
    if (usageLogs.isEmpty) return 0;
    final totalUsage = usageLogs.fold<int>(
      0,
      (sum, log) => sum + log.usageMinutes,
    );
    if (totalUsage == 0) return 0;
    return monthlyEquivalent / (totalUsage / 60); // per hour
  }

  /// Worth-it score: ratio of usage value to cost (0.0 - 1.0)
  double get worthItScore {
    if (usageLogs.isEmpty) return 0.5; // Default neutral score
    final avgUsage = averageMonthlyUsage;
    // More usage = higher score, capped at 1.0
    // Assume 60 mins/month = baseline for full value
    final usageScore = (avgUsage / 60).clamp(0.0, 1.0);
    return usageScore;
  }

  /// Detect price increase
  double? get priceIncreasePercent {
    if (priceHistory.length < 2) return null;
    final sorted = [...priceHistory]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    final firstPrice = sorted.first.amount;
    final currentPrice = amount;
    if (firstPrice == 0) return null;
    return ((currentPrice - firstPrice) / firstPrice) * 100;
  }

  /// Get recurrence display string
  String get recurrenceDisplayString {
    switch (recurrenceType) {
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.biWeekly:
        return 'Bi-weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
      case RecurrenceType.biMonthly:
        return 'Bi-monthly';
      case RecurrenceType.quarterly:
        return 'Quarterly';
      case RecurrenceType.semiAnnual:
        return 'Semi-annual';
      case RecurrenceType.annual:
        return 'Annual';
      case RecurrenceType.custom:
        return 'Every ${customRecurrenceDays ?? 0} days';
      case RecurrenceType.oneTime:
        return 'One-time';
    }
  }

  /// Get status display string
  String get statusDisplayString {
    switch (status) {
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.paused:
        return 'Paused';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
      case SubscriptionStatus.trial:
        return 'Trial';
      case SubscriptionStatus.expired:
        return 'Expired';
      case SubscriptionStatus.pendingCancellation:
        return 'Pending Cancellation';
      case SubscriptionStatus.paymentFailed:
        return 'Payment Failed';
      case SubscriptionStatus.gracePeriod:
        return 'Grace Period';
    }
  }

  /// Copy with method
  SubscriptionModel copyWith({
    String? id,
    String? name,
    String? description,
    double? amount,
    String? currencyCode,
    RecurrenceType? recurrenceType,
    int? customRecurrenceDays,
    DateTime? startDate,
    DateTime? nextBillingDate,
    DateTime? endDate,
    SubscriptionStatus? status,
    SubscriptionCategory? category,
    PaymentMethod? paymentMethod,
    String? paymentMethodDetails,
    String? iconName,
    String? colorHex,
    String? websiteUrl,
    String? cancellationUrl,
    bool? isTrial,
    DateTime? trialEndDate,
    int? gracePeriodDays,
    List<PriceTier>? priceHistory,
    List<UsageLog>? usageLogs,
    List<PaymentRecord>? paymentHistory,
    NotificationPreference? notificationPreference,
    List<String>? tags,
    String? notes,
    bool? isPaused,
    DateTime? pausedAt,
    DateTime? resumeAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
    String? linkedSubscriptionId,
    bool? autoRenew,
    String? timezone,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      customRecurrenceDays: customRecurrenceDays ?? this.customRecurrenceDays,
      startDate: startDate ?? this.startDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      category: category ?? this.category,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodDetails: paymentMethodDetails ?? this.paymentMethodDetails,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      cancellationUrl: cancellationUrl ?? this.cancellationUrl,
      isTrial: isTrial ?? this.isTrial,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      priceHistory: priceHistory ?? this.priceHistory,
      usageLogs: usageLogs ?? this.usageLogs,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      notificationPreference:
          notificationPreference ?? this.notificationPreference,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      isPaused: isPaused ?? this.isPaused,
      pausedAt: pausedAt ?? this.pausedAt,
      resumeAt: resumeAt ?? this.resumeAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isArchived: isArchived ?? this.isArchived,
      linkedSubscriptionId: linkedSubscriptionId ?? this.linkedSubscriptionId,
      autoRenew: autoRenew ?? this.autoRenew,
      timezone: timezone ?? this.timezone,
    );
  }

  /// Calculate next billing date based on recurrence
  DateTime calculateNextBillingDate(DateTime from) {
    switch (recurrenceType) {
      case RecurrenceType.daily:
        return from.add(const Duration(days: 1));
      case RecurrenceType.weekly:
        return from.add(const Duration(days: 7));
      case RecurrenceType.biWeekly:
        return from.add(const Duration(days: 14));
      case RecurrenceType.monthly:
        return DateTime(from.year, from.month + 1, from.day);
      case RecurrenceType.biMonthly:
        return DateTime(from.year, from.month + 2, from.day);
      case RecurrenceType.quarterly:
        return DateTime(from.year, from.month + 3, from.day);
      case RecurrenceType.semiAnnual:
        return DateTime(from.year, from.month + 6, from.day);
      case RecurrenceType.annual:
        return DateTime(from.year + 1, from.month, from.day);
      case RecurrenceType.custom:
        return from.add(Duration(days: customRecurrenceDays ?? 30));
      case RecurrenceType.oneTime:
        return from;
    }
  }

  @override
  String toString() {
    return 'SubscriptionModel(id: $id, name: $name, amount: $amount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubscriptionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
