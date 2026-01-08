import 'package:hive/hive.dart';
import '../models/user_settings_model.dart';
import '../models/insight_model.dart';
import '../database/database_service.dart';

/// Repository for user settings operations
class SettingsRepository {
  static const String defaultSettingsId = 'user_settings';

  Box get _box => DatabaseService.settings;

  /// Get current settings (creates default if not exists)
  UserSettingsModel getSettings() {
    final data = _box.get(defaultSettingsId);
    if (data == null || data is! UserSettingsModel) {
      final defaultSettings = UserSettingsModel();
      _box.put(defaultSettingsId, defaultSettings);
      return defaultSettings;
    }
    return data;
  }

  /// Update settings
  Future<void> updateSettings(UserSettingsModel settings) async {
    final previous = _box.get(defaultSettingsId);
    await _box.put(defaultSettingsId, settings);
    final prevSettings = previous is UserSettingsModel ? previous : null;
    await _logAudit(
      prevSettings != null
          ? {
              'themeMode': prevSettings.themeMode.index,
              'tier': prevSettings.tier.index,
            }
          : null,
      {'themeMode': settings.themeMode.index, 'tier': settings.tier.index},
    );
  }

  /// Update specific setting fields
  Future<void> updateField<T>(String field, T value) async {
    final current = getSettings();
    UserSettingsModel updated;

    switch (field) {
      case 'defaultCurrencyCode':
        updated = current.copyWith(defaultCurrencyCode: value as String);
        break;
      case 'themeMode':
        updated = current.copyWith(themeMode: value as AppThemeMode);
        break;
      case 'accentColorHex':
        updated = current.copyWith(accentColorHex: value as String);
        break;
      case 'hapticFeedbackEnabled':
        updated = current.copyWith(hapticFeedbackEnabled: value as bool);
        break;
      case 'animationsEnabled':
        updated = current.copyWith(animationsEnabled: value as bool);
        break;
      case 'compactModeEnabled':
        updated = current.copyWith(compactModeEnabled: value as bool);
        break;
      case 'showCentsEnabled':
        updated = current.copyWith(showCentsEnabled: value as bool);
        break;
      case 'onboardingCompleted':
        updated = current.copyWith(onboardingCompleted: value as bool);
        break;
      case 'debugModeEnabled':
        updated = current.copyWith(debugModeEnabled: value as bool);
        break;
      default:
        return;
    }

    await updateSettings(updated);
  }

  /// Update notification settings
  Future<void> updateNotificationSettings(
    GlobalNotificationSettings settings,
  ) async {
    final current = getSettings();
    final updated = current.copyWith(notificationSettings: settings);
    await updateSettings(updated);
  }

  /// Update budget settings
  Future<void> updateBudgetSettings(BudgetSettings settings) async {
    final current = getSettings();
    final updated = current.copyWith(budgetSettings: settings);
    await updateSettings(updated);
  }

  /// Update privacy settings
  Future<void> updatePrivacySettings(PrivacySettings settings) async {
    final current = getSettings();
    final updated = current.copyWith(privacySettings: settings);
    await updateSettings(updated);
  }

  /// Upgrade to Pro tier
  Future<void> upgradeToPro({DateTime? expiryDate}) async {
    final current = getSettings();
    final updated = current.copyWith(
      tier: UserTier.pro,
      tierExpiryDate: expiryDate,
    );
    await updateSettings(updated);
  }

  /// Upgrade to Lifetime tier
  Future<void> upgradeToLifetime() async {
    final current = getSettings();
    final updated = current.copyWith(
      tier: UserTier.lifetime,
      tierExpiryDate: null,
    );
    await updateSettings(updated);
  }

  /// Downgrade to Free tier
  Future<void> downgradeToFree() async {
    final current = getSettings();
    final updated = current.copyWith(tier: UserTier.free, tierExpiryDate: null);
    await updateSettings(updated);
  }

  /// Check and handle tier expiry
  Future<void> checkTierExpiry() async {
    final current = getSettings();
    if (current.isTierExpired) {
      await downgradeToFree();
    }
  }

  /// Increment app open count
  Future<void> incrementAppOpenCount() async {
    final current = getSettings();
    final updated = current.copyWith(appOpenCount: current.appOpenCount + 1);
    await updateSettings(updated);
  }

  /// Mark onboarding completed
  Future<void> completeOnboarding() async {
    final current = getSettings();
    final updated = current.copyWith(onboardingCompleted: true);
    await updateSettings(updated);
  }

  /// Update last backup date
  Future<void> updateLastBackupDate() async {
    final current = getSettings();
    final updated = current.copyWith(lastBackupDate: DateTime.now());
    await updateSettings(updated);
  }

  /// Add favorite category
  Future<void> addFavoriteCategory(String category) async {
    final current = getSettings();
    if (!current.favoriteCategories.contains(category)) {
      final updated = current.copyWith(
        favoriteCategories: [...current.favoriteCategories, category],
      );
      await updateSettings(updated);
    }
  }

  /// Remove favorite category
  Future<void> removeFavoriteCategory(String category) async {
    final current = getSettings();
    final updated = current.copyWith(
      favoriteCategories: current.favoriteCategories
          .where((c) => c != category)
          .toList(),
    );
    await updateSettings(updated);
  }

  /// Set custom setting
  Future<void> setCustomSetting(String key, dynamic value) async {
    final current = getSettings();
    final newCustom = Map<String, dynamic>.from(current.customSettings);
    newCustom[key] = value;
    final updated = current.copyWith(customSettings: newCustom);
    await updateSettings(updated);
  }

  /// Get custom setting
  T? getCustomSetting<T>(String key) {
    final settings = getSettings();
    return settings.customSettings[key] as T?;
  }

  /// Reset settings to default
  Future<void> resetToDefault() async {
    final defaultSettings = UserSettingsModel();
    await updateSettings(defaultSettings);
  }

  /// Log audit entry
  Future<void> _logAudit(
    Map<String, dynamic>? previous,
    Map<String, dynamic>? newState,
  ) async {
    final entry = AuditLogEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      action: AuditAction.settingsChange,
      entityType: 'settings',
      entityId: defaultSettingsId,
      previousState: previous,
      newState: newState,
    );
    await DatabaseService.auditLog.put(entry.id, entry);
  }
}

/// Repository for insights operations
class InsightRepository {
  Box get _box => DatabaseService.insights;

  /// Get all insights
  List<InsightModel> getAll() {
    return _box.values.whereType<InsightModel>().toList();
  }

  /// Get active insights (not dismissed, not expired)
  List<InsightModel> getActive() {
    return getAll().where((i) => i.isActive).toList()..sort((a, b) {
      // Sort by priority first, then by creation date
      final priorityCompare = b.priority.index.compareTo(a.priority.index);
      if (priorityCompare != 0) return priorityCompare;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  /// Get insights by type
  List<InsightModel> getByType(InsightType type) {
    return getAll().where((i) => i.type == type && i.isActive).toList();
  }

  /// Get insights by priority
  List<InsightModel> getByPriority(InsightPriority priority) {
    return getAll().where((i) => i.priority == priority && i.isActive).toList();
  }

  /// Get insight by ID
  InsightModel? getById(String id) {
    final data = _box.get(id);
    return data is InsightModel ? data : null;
  }

  /// Add new insight
  Future<void> add(InsightModel insight) async {
    await _box.put(insight.id, insight);
  }

  /// Dismiss insight
  Future<void> dismiss(String id) async {
    final insight = getById(id);
    if (insight != null) {
      await _box.put(id, insight.dismiss());
    }
  }

  /// Mark insight as actioned
  Future<void> markActioned(String id, InsightActionType actionType) async {
    final insight = getById(id);
    if (insight != null) {
      await _box.put(id, insight.markActioned(actionType));
    }
  }

  /// Delete insight
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Clear all dismissed insights
  Future<void> clearDismissed() async {
    final dismissed = getAll().where((i) => i.isDismissed).toList();
    for (final insight in dismissed) {
      await _box.delete(insight.id);
    }
  }

  /// Clear all expired insights
  Future<void> clearExpired() async {
    final expired = getAll().where((i) => i.isExpired).toList();
    for (final insight in expired) {
      await _box.delete(insight.id);
    }
  }

  /// Get total potential savings from active insights
  double getTotalPotentialSavings() {
    return getActive()
        .where((i) => i.potentialSavings != null)
        .fold(0.0, (sum, i) => sum + i.potentialSavings!);
  }
}

/// Repository for smart rules operations
class SmartRuleRepository {
  Box get _box => DatabaseService.rules;

  /// Get all rules
  List<SmartRule> getAll() {
    return _box.values.whereType<SmartRule>().toList();
  }

  /// Get enabled rules
  List<SmartRule> getEnabled() {
    return getAll().where((r) => r.isEnabled).toList();
  }

  /// Get rule by ID
  SmartRule? getById(String id) {
    final data = _box.get(id);
    return data is SmartRule ? data : null;
  }

  /// Add rule
  Future<void> add(SmartRule rule) async {
    await _box.put(rule.id, rule);
  }

  /// Update rule
  Future<void> update(SmartRule rule) async {
    await _box.put(rule.id, rule);
  }

  /// Delete rule
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Toggle rule enabled state
  Future<void> toggleEnabled(String id) async {
    final rule = getById(id);
    if (rule != null) {
      await _box.put(id, rule.copyWith(isEnabled: !rule.isEnabled));
    }
  }

  /// Mark rule as triggered
  Future<void> markTriggered(String id) async {
    final rule = getById(id);
    if (rule != null) {
      await _box.put(id, rule.triggered());
    }
  }
}

/// Repository for saved views operations
class SavedViewRepository {
  Box get _box => DatabaseService.savedViews;

  /// Get all saved views
  List<SavedView> getAll() {
    return _box.values.whereType<SavedView>().toList()
      ..sort((a, b) => b.usageCount.compareTo(a.usageCount));
  }

  /// Get view by ID
  SavedView? getById(String id) {
    final data = _box.get(id);
    return data is SavedView ? data : null;
  }

  /// Add view
  Future<void> add(SavedView view) async {
    await _box.put(view.id, view);
  }

  /// Update view
  Future<void> update(SavedView view) async {
    await _box.put(view.id, view);
  }

  /// Delete view
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Increment usage count
  Future<void> incrementUsage(String id) async {
    final view = getById(id);
    if (view != null) {
      await _box.put(id, view.incrementUsage());
    }
  }
}

/// Repository for audit log operations
class AuditLogRepository {
  Box get _box => DatabaseService.auditLog;

  /// Get all entries
  List<AuditLogEntry> getAll() {
    return _box.values.whereType<AuditLogEntry>().toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get entries for specific entity
  List<AuditLogEntry> getForEntity(String entityType, String entityId) {
    return getAll()
        .where((e) => e.entityType == entityType && e.entityId == entityId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get entries by action type
  List<AuditLogEntry> getByAction(AuditAction action) {
    return getAll().where((e) => e.action == action).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get entries in date range
  List<AuditLogEntry> getInDateRange(DateTime start, DateTime end) {
    return getAll()
        .where((e) => e.timestamp.isAfter(start) && e.timestamp.isBefore(end))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Add entry
  Future<void> add(AuditLogEntry entry) async {
    await _box.put(entry.id, entry);
  }

  /// Clear old entries (older than specified days)
  Future<void> clearOld({int daysOld = 90}) async {
    final cutoff = DateTime.now().subtract(Duration(days: daysOld));
    final old = _box.values.where((e) => e.timestamp.isBefore(cutoff)).toList();
    for (final entry in old) {
      await _box.delete(entry.id);
    }
  }

  /// Export as list
  List<Map<String, dynamic>> export() {
    return getAll()
        .map(
          (e) => {
            'id': e.id,
            'action': e.action.name,
            'entityType': e.entityType,
            'entityId': e.entityId,
            'entityName': e.entityName,
            'timestamp': e.timestamp.toIso8601String(),
            'previousState': e.previousState,
            'newState': e.newState,
            'notes': e.notes,
          },
        )
        .toList();
  }
}
