import 'package:hive/hive.dart';

part 'insight_model.g.dart';

/// Types of insights
@HiveType(typeId: 30)
enum InsightType {
  @HiveField(0)
  costSaving,
  @HiveField(1)
  unusedSubscription,
  @HiveField(2)
  priceIncrease,
  @HiveField(3)
  trialEnding,
  @HiveField(4)
  duplicateService,
  @HiveField(5)
  budgetWarning,
  @HiveField(6)
  paymentUpcoming,
  @HiveField(7)
  regretDetection,
  @HiveField(8)
  spendDrift,
  @HiveField(9)
  categorySpike,
  @HiveField(10)
  monthlySummary,
  @HiveField(11)
  annualProjection,
  @HiveField(12)
  worthItScore,
  @HiveField(13)
  behavioralNudge,
}

/// Insight priority
@HiveType(typeId: 31)
enum InsightPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
  @HiveField(3)
  critical,
}

/// Insight action type
@HiveType(typeId: 32)
enum InsightActionType {
  @HiveField(0)
  cancel,
  @HiveField(1)
  pause,
  @HiveField(2)
  review,
  @HiveField(3)
  downgrade,
  @HiveField(4)
  negotiate,
  @HiveField(5)
  remind,
  @HiveField(6)
  dismiss,
  @HiveField(7)
  viewDetails,
  @HiveField(8)
  logUsage,
}

/// Insight action
@HiveType(typeId: 33)
class InsightAction {
  @HiveField(0)
  final InsightActionType type;

  @HiveField(1)
  final String label;

  @HiveField(2)
  final String? subscriptionId;

  @HiveField(3)
  final String? url;

  const InsightAction({
    required this.type,
    required this.label,
    this.subscriptionId,
    this.url,
  });
}

/// Main insight model
@HiveType(typeId: 4)
class InsightModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final InsightType type;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final InsightPriority priority;

  @HiveField(5)
  final double? potentialSavings;

  @HiveField(6)
  final String? currencyCode;

  @HiveField(7)
  final List<String> relatedSubscriptionIds;

  @HiveField(8)
  final List<InsightAction> actions;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime? expiresAt;

  @HiveField(11)
  final bool isDismissed;

  @HiveField(12)
  final DateTime? dismissedAt;

  @HiveField(13)
  final bool isActioned;

  @HiveField(14)
  final InsightActionType? actionedWith;

  @HiveField(15)
  final String? iconName;

  @HiveField(16)
  final String? colorHex;

  @HiveField(17)
  final Map<String, dynamic>? metadata;

  InsightModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.priority = InsightPriority.medium,
    this.potentialSavings,
    this.currencyCode,
    this.relatedSubscriptionIds = const [],
    this.actions = const [],
    DateTime? createdAt,
    this.expiresAt,
    this.isDismissed = false,
    this.dismissedAt,
    this.isActioned = false,
    this.actionedWith,
    this.iconName,
    this.colorHex,
    this.metadata,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isExpired {
    if (expiresAt == null) return false;
    return expiresAt!.isBefore(DateTime.now());
  }

  bool get isActive => !isDismissed && !isActioned && !isExpired;

  InsightModel copyWith({
    String? id,
    InsightType? type,
    String? title,
    String? description,
    InsightPriority? priority,
    double? potentialSavings,
    String? currencyCode,
    List<String>? relatedSubscriptionIds,
    List<InsightAction>? actions,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isDismissed,
    DateTime? dismissedAt,
    bool? isActioned,
    InsightActionType? actionedWith,
    String? iconName,
    String? colorHex,
    Map<String, dynamic>? metadata,
  }) {
    return InsightModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      potentialSavings: potentialSavings ?? this.potentialSavings,
      currencyCode: currencyCode ?? this.currencyCode,
      relatedSubscriptionIds:
          relatedSubscriptionIds ?? this.relatedSubscriptionIds,
      actions: actions ?? this.actions,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isDismissed: isDismissed ?? this.isDismissed,
      dismissedAt: dismissedAt ?? this.dismissedAt,
      isActioned: isActioned ?? this.isActioned,
      actionedWith: actionedWith ?? this.actionedWith,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      metadata: metadata ?? this.metadata,
    );
  }

  InsightModel dismiss() {
    return copyWith(isDismissed: true, dismissedAt: DateTime.now());
  }

  InsightModel markActioned(InsightActionType actionType) {
    return copyWith(isActioned: true, actionedWith: actionType);
  }
}

/// Smart rule for automation
@HiveType(typeId: 5)
class SmartRule {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final SmartRuleCondition condition;

  @HiveField(4)
  final SmartRuleAction action;

  @HiveField(5)
  final bool isEnabled;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? lastTriggeredAt;

  @HiveField(8)
  final int triggerCount;

  SmartRule({
    required this.id,
    required this.name,
    required this.description,
    required this.condition,
    required this.action,
    this.isEnabled = true,
    DateTime? createdAt,
    this.lastTriggeredAt,
    this.triggerCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  SmartRule copyWith({
    String? id,
    String? name,
    String? description,
    SmartRuleCondition? condition,
    SmartRuleAction? action,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? lastTriggeredAt,
    int? triggerCount,
  }) {
    return SmartRule(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      action: action ?? this.action,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastTriggeredAt: lastTriggeredAt ?? this.lastTriggeredAt,
      triggerCount: triggerCount ?? this.triggerCount,
    );
  }

  SmartRule triggered() {
    return copyWith(
      lastTriggeredAt: DateTime.now(),
      triggerCount: triggerCount + 1,
    );
  }
}

/// Rule condition types
@HiveType(typeId: 34)
enum RuleConditionType {
  @HiveField(0)
  unusedForDays,
  @HiveField(1)
  costExceeds,
  @HiveField(2)
  categorySpendExceeds,
  @HiveField(3)
  trialEndingSoon,
  @HiveField(4)
  priceIncreased,
  @HiveField(5)
  subscriptionAgeDays,
  @HiveField(6)
  lowUsage,
}

/// Smart rule condition
@HiveType(typeId: 35)
class SmartRuleCondition {
  @HiveField(0)
  final RuleConditionType type;

  @HiveField(1)
  final String? subscriptionId;

  @HiveField(2)
  final String? subscriptionName;

  @HiveField(3)
  final String? category;

  @HiveField(4)
  final double? threshold;

  @HiveField(5)
  final int? days;

  const SmartRuleCondition({
    required this.type,
    this.subscriptionId,
    this.subscriptionName,
    this.category,
    this.threshold,
    this.days,
  });
}

/// Rule action types
@HiveType(typeId: 36)
enum RuleActionType {
  @HiveField(0)
  sendAlert,
  @HiveField(1)
  createInsight,
  @HiveField(2)
  suggestCancel,
  @HiveField(3)
  suggestPause,
  @HiveField(4)
  logWarning,
}

/// Smart rule action
@HiveType(typeId: 37)
class SmartRuleAction {
  @HiveField(0)
  final RuleActionType type;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final InsightPriority priority;

  const SmartRuleAction({
    required this.type,
    required this.message,
    this.priority = InsightPriority.medium,
  });
}

/// Audit log entry
@HiveType(typeId: 6)
class AuditLogEntry {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final AuditAction action;

  @HiveField(2)
  final String entityType;

  @HiveField(3)
  final String entityId;

  @HiveField(4)
  final String? entityName;

  @HiveField(5)
  final Map<String, dynamic>? previousState;

  @HiveField(6)
  final Map<String, dynamic>? newState;

  @HiveField(7)
  final DateTime timestamp;

  @HiveField(8)
  final String? notes;

  AuditLogEntry({
    required this.id,
    required this.action,
    required this.entityType,
    required this.entityId,
    this.entityName,
    this.previousState,
    this.newState,
    DateTime? timestamp,
    this.notes,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Audit actions
@HiveType(typeId: 38)
enum AuditAction {
  @HiveField(0)
  create,
  @HiveField(1)
  update,
  @HiveField(2)
  delete,
  @HiveField(3)
  pause,
  @HiveField(4)
  resume,
  @HiveField(5)
  cancel,
  @HiveField(6)
  archive,
  @HiveField(7)
  restore,
  @HiveField(8)
  import_,
  @HiveField(9)
  export_,
  @HiveField(10)
  backup,
  @HiveField(11)
  settingsChange,
}

/// Saved view for power users
@HiveType(typeId: 7)
class SavedView {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? iconName;

  @HiveField(3)
  final List<String> filterTags;

  @HiveField(4)
  final List<String> filterCategories;

  @HiveField(5)
  final List<String> filterStatuses;

  @HiveField(6)
  final String? sortBy;

  @HiveField(7)
  final bool sortAscending;

  @HiveField(8)
  final double? minAmount;

  @HiveField(9)
  final double? maxAmount;

  @HiveField(10)
  final bool showArchived;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final int usageCount;

  SavedView({
    required this.id,
    required this.name,
    this.iconName,
    this.filterTags = const [],
    this.filterCategories = const [],
    this.filterStatuses = const [],
    this.sortBy,
    this.sortAscending = true,
    this.minAmount,
    this.maxAmount,
    this.showArchived = false,
    DateTime? createdAt,
    this.usageCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  SavedView copyWith({
    String? id,
    String? name,
    String? iconName,
    List<String>? filterTags,
    List<String>? filterCategories,
    List<String>? filterStatuses,
    String? sortBy,
    bool? sortAscending,
    double? minAmount,
    double? maxAmount,
    bool? showArchived,
    DateTime? createdAt,
    int? usageCount,
  }) {
    return SavedView(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      filterTags: filterTags ?? this.filterTags,
      filterCategories: filterCategories ?? this.filterCategories,
      filterStatuses: filterStatuses ?? this.filterStatuses,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      showArchived: showArchived ?? this.showArchived,
      createdAt: createdAt ?? this.createdAt,
      usageCount: usageCount ?? this.usageCount,
    );
  }

  SavedView incrementUsage() {
    return copyWith(usageCount: usageCount + 1);
  }
}
