import 'package:hive/hive.dart';

part 'user_settings_model.g.dart';

/// Tier levels for monetization
@HiveType(typeId: 20)
enum UserTier {
  @HiveField(0)
  free,
  @HiveField(1)
  pro,
  @HiveField(2)
  lifetime,
}

/// App theme mode
@HiveType(typeId: 21)
enum AppThemeMode {
  @HiveField(0)
  system,
  @HiveField(1)
  light,
  @HiveField(2)
  dark,
}

/// Currency display format
@HiveType(typeId: 22)
enum CurrencyDisplayFormat {
  @HiveField(0)
  symbolFirst,
  @HiveField(1)
  symbolLast,
  @HiveField(2)
  codeFirst,
  @HiveField(3)
  codeLast,
}

/// Date format preference
@HiveType(typeId: 23)
enum DateFormatPreference {
  @HiveField(0)
  ddMMyyyy,
  @HiveField(1)
  mmDdYyyy,
  @HiveField(2)
  yyyyMmDd,
  @HiveField(3)
  relative,
}

/// Notification global settings
@HiveType(typeId: 24)
class GlobalNotificationSettings {
  @HiveField(0)
  final bool enabled;

  @HiveField(1)
  final bool quietHoursEnabled;

  @HiveField(2)
  final int quietHoursStart; // Hour in 24h format

  @HiveField(3)
  final int quietHoursEnd;

  @HiveField(4)
  final List<int> defaultReminderDays;

  @HiveField(5)
  final bool vibrationEnabled;

  @HiveField(6)
  final bool soundEnabled;

  @HiveField(7)
  final String? customSoundPath;

  @HiveField(8)
  final bool showPreview;

  @HiveField(9)
  final bool billReminders;

  @HiveField(10)
  final bool insightAlerts;

  @HiveField(11)
  final bool priceChangeAlerts;

  const GlobalNotificationSettings({
    this.enabled = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart = 22,
    this.quietHoursEnd = 8,
    this.defaultReminderDays = const [7, 3, 1],
    this.vibrationEnabled = true,
    this.soundEnabled = true,
    this.customSoundPath,
    this.showPreview = true,
    this.billReminders = true,
    this.insightAlerts = true,
    this.priceChangeAlerts = true,
  });

  /// Get quiet hours start as formatted string
  String get quietHoursStartFormatted =>
      '${quietHoursStart.toString().padLeft(2, '0')}:00';

  /// Get quiet hours end as formatted string
  String get quietHoursEndFormatted =>
      '${quietHoursEnd.toString().padLeft(2, '0')}:00';

  GlobalNotificationSettings copyWith({
    bool? enabled,
    bool? quietHoursEnabled,
    int? quietHoursStart,
    int? quietHoursEnd,
    List<int>? defaultReminderDays,
    bool? vibrationEnabled,
    bool? soundEnabled,
    String? customSoundPath,
    bool? showPreview,
    bool? billReminders,
    bool? insightAlerts,
    bool? priceChangeAlerts,
  }) {
    return GlobalNotificationSettings(
      enabled: enabled ?? this.enabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      defaultReminderDays: defaultReminderDays ?? this.defaultReminderDays,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      customSoundPath: customSoundPath ?? this.customSoundPath,
      showPreview: showPreview ?? this.showPreview,
      billReminders: billReminders ?? this.billReminders,
      insightAlerts: insightAlerts ?? this.insightAlerts,
      priceChangeAlerts: priceChangeAlerts ?? this.priceChangeAlerts,
    );
  }
}

/// Budget threshold settings
@HiveType(typeId: 25)
class BudgetSettings {
  @HiveField(0)
  final double? monthlyBudget;

  @HiveField(1)
  final double? yearlyBudget;

  @HiveField(2)
  final bool alertOnThreshold;

  @HiveField(3)
  final double thresholdPercent; // Alert when spending reaches this % of budget

  @HiveField(4)
  final Map<String, double> categoryBudgets; // Category name -> budget

  @HiveField(5)
  final bool alertsEnabled;

  const BudgetSettings({
    this.monthlyBudget,
    this.yearlyBudget,
    this.alertOnThreshold = true,
    this.thresholdPercent = 80.0,
    this.categoryBudgets = const {},
    this.alertsEnabled = true,
  });

  /// Alias for monthlyBudget for SettingsScreen compatibility
  double? get monthlyLimit => monthlyBudget;

  /// Alias for thresholdPercent
  double get warningThreshold => thresholdPercent;

  BudgetSettings copyWith({
    double? monthlyBudget,
    double? yearlyBudget,
    bool? alertOnThreshold,
    double? thresholdPercent,
    Map<String, double>? categoryBudgets,
    bool? alertsEnabled,
  }) {
    return BudgetSettings(
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      yearlyBudget: yearlyBudget ?? this.yearlyBudget,
      alertOnThreshold: alertOnThreshold ?? this.alertOnThreshold,
      thresholdPercent: thresholdPercent ?? this.thresholdPercent,
      categoryBudgets: categoryBudgets ?? this.categoryBudgets,
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
    );
  }
}

/// Privacy settings
@HiveType(typeId: 26)
class PrivacySettings {
  @HiveField(0)
  final bool biometricLockEnabled;

  @HiveField(1)
  final bool hideAmountsInNotifications;

  @HiveField(2)
  final bool obscureAmountsOnScreen;

  @HiveField(3)
  final bool analyticsEnabled;

  @HiveField(4)
  final bool crashReportingEnabled;

  @HiveField(5)
  final bool localEncryptionEnabled;

  @HiveField(6)
  final int autoLockTimeoutSeconds;

  @HiveField(7)
  final bool cloudBackupEnabled;

  const PrivacySettings({
    this.biometricLockEnabled = false,
    this.hideAmountsInNotifications = false,
    this.obscureAmountsOnScreen = false,
    this.analyticsEnabled = false,
    this.crashReportingEnabled = false,
    this.localEncryptionEnabled = false,
    this.autoLockTimeoutSeconds = 300,
    this.cloudBackupEnabled = false,
  });

  /// Alias for biometricLockEnabled
  bool get biometricLock => biometricLockEnabled;

  /// Alias for cloudBackupEnabled
  bool get cloudBackup => cloudBackupEnabled;

  PrivacySettings copyWith({
    bool? biometricLockEnabled,
    bool? hideAmountsInNotifications,
    bool? obscureAmountsOnScreen,
    bool? analyticsEnabled,
    bool? crashReportingEnabled,
    bool? localEncryptionEnabled,
    int? autoLockTimeoutSeconds,
    bool? cloudBackupEnabled,
  }) {
    return PrivacySettings(
      biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
      hideAmountsInNotifications:
          hideAmountsInNotifications ?? this.hideAmountsInNotifications,
      obscureAmountsOnScreen:
          obscureAmountsOnScreen ?? this.obscureAmountsOnScreen,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashReportingEnabled:
          crashReportingEnabled ?? this.crashReportingEnabled,
      localEncryptionEnabled:
          localEncryptionEnabled ?? this.localEncryptionEnabled,
      autoLockTimeoutSeconds:
          autoLockTimeoutSeconds ?? this.autoLockTimeoutSeconds,
      cloudBackupEnabled: cloudBackupEnabled ?? this.cloudBackupEnabled,
    );
  }
}

/// Main user settings model
@HiveType(typeId: 2)
class UserSettingsModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String defaultCurrencyCode;

  @HiveField(2)
  final AppThemeMode themeMode;

  @HiveField(3)
  final String? accentColorHex;

  @HiveField(4)
  final GlobalNotificationSettings notificationSettings;

  @HiveField(5)
  final BudgetSettings budgetSettings;

  @HiveField(6)
  final PrivacySettings privacySettings;

  @HiveField(7)
  final UserTier tier;

  @HiveField(8)
  final DateTime? tierExpiryDate;

  @HiveField(9)
  final CurrencyDisplayFormat currencyDisplayFormat;

  @HiveField(10)
  final DateFormatPreference dateFormatPreference;

  @HiveField(11)
  final String? timezone;

  @HiveField(12)
  final bool hapticFeedbackEnabled;

  @HiveField(13)
  final bool animationsEnabled;

  @HiveField(14)
  final bool compactModeEnabled;

  @HiveField(15)
  final bool showCentsEnabled;

  @HiveField(16)
  final String? defaultPaymentMethod;

  @HiveField(17)
  final List<String> favoriteCategories;

  @HiveField(18)
  final Map<String, dynamic> customSettings;

  @HiveField(19)
  final bool onboardingCompleted;

  @HiveField(20)
  final DateTime createdAt;

  @HiveField(21)
  final DateTime updatedAt;

  @HiveField(22)
  final int appOpenCount;

  @HiveField(23)
  final DateTime? lastBackupDate;

  @HiveField(24)
  final bool debugModeEnabled;

  @HiveField(25, defaultValue: 0)
  final int selectedThemeIndex;

  UserSettingsModel({
    String? id,
    this.defaultCurrencyCode = 'INR',
    this.themeMode = AppThemeMode.system,
    this.selectedThemeIndex = 0,
    this.accentColorHex,
    this.notificationSettings = const GlobalNotificationSettings(),
    this.budgetSettings = const BudgetSettings(),
    this.privacySettings = const PrivacySettings(),
    this.tier = UserTier.free,
    this.tierExpiryDate,
    this.currencyDisplayFormat = CurrencyDisplayFormat.symbolFirst,
    this.dateFormatPreference = DateFormatPreference.ddMMyyyy,
    this.timezone,
    this.hapticFeedbackEnabled = true,
    this.animationsEnabled = true,
    this.compactModeEnabled = false,
    this.showCentsEnabled = true,
    this.defaultPaymentMethod,
    this.favoriteCategories = const [],
    this.customSettings = const {},
    this.onboardingCompleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.appOpenCount = 0,
    this.lastBackupDate,
    this.debugModeEnabled = false,
  }) : id = id ?? 'user_settings',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  bool get isPro => tier == UserTier.pro || tier == UserTier.lifetime;
  bool get isLifetime => tier == UserTier.lifetime;

  bool get isTierExpired {
    if (tier == UserTier.lifetime) return false;
    if (tier == UserTier.free) return false;
    if (tierExpiryDate == null) return true;
    return tierExpiryDate!.isBefore(DateTime.now());
  }

  /// Alias for defaultCurrencyCode
  String get defaultCurrency => defaultCurrencyCode;

  /// Alias for notificationSettings
  GlobalNotificationSettings get notifications => notificationSettings;

  /// Alias for budgetSettings
  BudgetSettings get budget => budgetSettings;

  /// Alias for privacySettings
  PrivacySettings get privacy => privacySettings;

  UserSettingsModel copyWith({
    String? id,
    String? defaultCurrencyCode,
    AppThemeMode? themeMode,
    int? selectedThemeIndex,
    String? accentColorHex,
    GlobalNotificationSettings? notificationSettings,
    BudgetSettings? budgetSettings,
    PrivacySettings? privacySettings,
    UserTier? tier,
    DateTime? tierExpiryDate,
    CurrencyDisplayFormat? currencyDisplayFormat,
    DateFormatPreference? dateFormatPreference,
    String? timezone,
    bool? hapticFeedbackEnabled,
    bool? animationsEnabled,
    bool? compactModeEnabled,
    bool? showCentsEnabled,
    String? defaultPaymentMethod,
    List<String>? favoriteCategories,
    Map<String, dynamic>? customSettings,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? appOpenCount,
    DateTime? lastBackupDate,
    bool? debugModeEnabled,
  }) {
    return UserSettingsModel(
      id: id ?? this.id,
      defaultCurrencyCode: defaultCurrencyCode ?? this.defaultCurrencyCode,
      themeMode: themeMode ?? this.themeMode,
      selectedThemeIndex: selectedThemeIndex ?? this.selectedThemeIndex,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      budgetSettings: budgetSettings ?? this.budgetSettings,
      privacySettings: privacySettings ?? this.privacySettings,
      tier: tier ?? this.tier,
      tierExpiryDate: tierExpiryDate ?? this.tierExpiryDate,
      currencyDisplayFormat:
          currencyDisplayFormat ?? this.currencyDisplayFormat,
      dateFormatPreference: dateFormatPreference ?? this.dateFormatPreference,
      timezone: timezone ?? this.timezone,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      compactModeEnabled: compactModeEnabled ?? this.compactModeEnabled,
      showCentsEnabled: showCentsEnabled ?? this.showCentsEnabled,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      customSettings: customSettings ?? this.customSettings,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      appOpenCount: appOpenCount ?? this.appOpenCount,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      debugModeEnabled: debugModeEnabled ?? this.debugModeEnabled,
    );
  }
}
