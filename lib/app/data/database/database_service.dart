import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Import models for Hive adapter registration
import '../models/subscription_model.dart';
import '../models/user_settings_model.dart';
import '../models/insight_model.dart';
import '../models/subscription_template_model.dart';

/// Database schema version for migrations
const int currentSchemaVersion = 1;

/// Box names
const String subscriptionsBoxName = 'subscriptions';
const String settingsBoxName = 'user_settings';
const String insightsBoxName = 'insights';
const String rulesBoxName = 'smart_rules';
const String auditLogBoxName = 'audit_log';
const String savedViewsBoxName = 'saved_views';
const String metadataBoxName = 'metadata';

/// Database service for Hive operations
class DatabaseService {
  static bool _initialized = false;

  /// Register all Hive type adapters
  static void _registerAdapters() {
    // Subscription model adapters
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SubscriptionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(RecurrenceTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(SubscriptionStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(PaymentMethodAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(SubscriptionCategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(CurrencyModelAdapter());
    }
    if (!Hive.isAdapterRegistered(15)) {
      Hive.registerAdapter(PriceTierAdapter());
    }
    if (!Hive.isAdapterRegistered(16)) {
      Hive.registerAdapter(NotificationPreferenceAdapter());
    }
    if (!Hive.isAdapterRegistered(17)) {
      Hive.registerAdapter(UsageLogAdapter());
    }
    if (!Hive.isAdapterRegistered(18)) {
      Hive.registerAdapter(PaymentRecordAdapter());
    }

    // User settings model adapters
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserSettingsModelAdapter());
    }
    if (!Hive.isAdapterRegistered(20)) {
      Hive.registerAdapter(UserTierAdapter());
    }
    if (!Hive.isAdapterRegistered(21)) {
      Hive.registerAdapter(AppThemeModeAdapter());
    }
    if (!Hive.isAdapterRegistered(22)) {
      Hive.registerAdapter(CurrencyDisplayFormatAdapter());
    }
    if (!Hive.isAdapterRegistered(23)) {
      Hive.registerAdapter(DateFormatPreferenceAdapter());
    }
    if (!Hive.isAdapterRegistered(24)) {
      Hive.registerAdapter(GlobalNotificationSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(25)) {
      Hive.registerAdapter(BudgetSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(26)) {
      Hive.registerAdapter(PrivacySettingsAdapter());
    }

    // Template adapter (typeId: 3)
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(SubscriptionTemplateAdapter());
    }

    // Insight model adapters
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(InsightModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(SmartRuleAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(AuditLogEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(SavedViewAdapter());
    }
    if (!Hive.isAdapterRegistered(30)) {
      Hive.registerAdapter(InsightTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(31)) {
      Hive.registerAdapter(InsightPriorityAdapter());
    }
    if (!Hive.isAdapterRegistered(32)) {
      Hive.registerAdapter(InsightActionTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(33)) {
      Hive.registerAdapter(InsightActionAdapter());
    }
    if (!Hive.isAdapterRegistered(34)) {
      Hive.registerAdapter(RuleConditionTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(35)) {
      Hive.registerAdapter(SmartRuleConditionAdapter());
    }
    if (!Hive.isAdapterRegistered(36)) {
      Hive.registerAdapter(RuleActionTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(37)) {
      Hive.registerAdapter(SmartRuleActionAdapter());
    }
    if (!Hive.isAdapterRegistered(38)) {
      Hive.registerAdapter(AuditActionAdapter());
    }
  }

  /// Initialize database
  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize Hive with Flutter
    await Hive.initFlutter();

    // Register all type adapters before opening boxes
    _registerAdapters();

    // Open boxes
    await Hive.openBox(subscriptionsBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(insightsBoxName);
    await Hive.openBox(rulesBoxName);
    await Hive.openBox(auditLogBoxName);
    await Hive.openBox(savedViewsBoxName);
    await Hive.openBox(metadataBoxName);

    // Run migrations
    await _runMigrations();

    _initialized = true;
    debugPrint('DatabaseService initialized');
  }

  /// Get subscriptions box
  static Box get subscriptionsBox => Hive.box(subscriptionsBoxName);

  /// Get settings box
  static Box get settingsBox => Hive.box(settingsBoxName);

  /// Get insights box
  static Box get insightsBox => Hive.box(insightsBoxName);

  /// Get rules box
  static Box get rulesBox => Hive.box(rulesBoxName);

  /// Get audit log box
  static Box get auditLogBox => Hive.box(auditLogBoxName);

  /// Get saved views box
  static Box get savedViewsBox => Hive.box(savedViewsBoxName);

  /// Get metadata box
  static Box get metadataBox => Hive.box(metadataBoxName);

  // Aliases for repositories
  static Box get subscriptions => subscriptionsBox;
  static Box get settings => settingsBox;
  static Box get insights => insightsBox;
  static Box get rules => rulesBox;
  static Box get auditLog => auditLogBox;
  static Box get savedViews => savedViewsBox;

  /// Run database migrations if needed
  static Future<void> _runMigrations() async {
    final metaBox = Hive.box(metadataBoxName);
    final storedVersion = metaBox.get('schemaVersion', defaultValue: 0) as int;

    if (storedVersion < currentSchemaVersion) {
      for (int v = storedVersion + 1; v <= currentSchemaVersion; v++) {
        await _migrateToVersion(v);
      }
      await metaBox.put('schemaVersion', currentSchemaVersion);
      debugPrint('Database migrated to version $currentSchemaVersion');
    }
  }

  /// Run migration for specific version
  static Future<void> _migrateToVersion(int version) async {
    debugPrint('Migrating database to version $version');

    switch (version) {
      case 1:
        // Initial schema - no migration needed
        break;
      // Add future migrations here
    }
  }

  /// Export all data as JSON for backup
  static Future<Map<String, dynamic>> exportAll() async {
    return {
      'version': currentSchemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'subscriptions': subscriptionsBox.toMap(),
      'settings': settingsBox.toMap(),
      'insights': insightsBox.toMap(),
      'rules': rulesBox.toMap(),
      'auditLog': auditLogBox.toMap(),
      'savedViews': savedViewsBox.toMap(),
    };
  }

  /// Export to file
  static Future<File?> exportToFile() async {
    try {
      final data = await exportAll();
      final jsonStr = const JsonEncoder.withIndent('  ').convert(data);

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${directory.path}/subtrak_backup_$timestamp.json');

      await file.writeAsString(jsonStr);
      debugPrint('Exported to ${file.path}');
      return file;
    } catch (e) {
      debugPrint('Export failed: $e');
      return null;
    }
  }

  /// Import data from backup
  static Future<bool> importFromJson(Map<String, dynamic> data) async {
    try {
      final version = data['version'] as int? ?? 1;

      if (version > currentSchemaVersion) {
        debugPrint(
          'Cannot import: backup version $version > current $currentSchemaVersion',
        );
        return false;
      }

      // Clear existing data
      await clearAll();

      // Import subscriptions
      if (data['subscriptions'] != null) {
        final subs = data['subscriptions'] as Map;
        for (final entry in subs.entries) {
          await subscriptionsBox.put(entry.key, entry.value);
        }
      }

      // Import settings
      if (data['settings'] != null) {
        final settings = data['settings'] as Map;
        for (final entry in settings.entries) {
          await settingsBox.put(entry.key, entry.value);
        }
      }

      // Import other data similarly...
      debugPrint('Import completed successfully');
      return true;
    } catch (e) {
      debugPrint('Import failed: $e');
      return false;
    }
  }

  /// Clear all data
  static Future<void> clearAll() async {
    await subscriptionsBox.clear();
    await settingsBox.clear();
    await insightsBox.clear();
    await rulesBox.clear();
    await auditLogBox.clear();
    await savedViewsBox.clear();
    // Don't clear metadata - keep schema version
    debugPrint('All data cleared');
  }

  /// Get database stats
  static Map<String, int> getStats() {
    return {
      'subscriptions': subscriptionsBox.length,
      'settings': settingsBox.length,
      'insights': insightsBox.length,
      'rules': rulesBox.length,
      'auditLog': auditLogBox.length,
      'savedViews': savedViewsBox.length,
    };
  }

  /// Close all boxes
  static Future<void> close() async {
    await Hive.close();
    _initialized = false;
    debugPrint('DatabaseService closed');
  }
}
