// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GlobalNotificationSettingsAdapter
    extends TypeAdapter<GlobalNotificationSettings> {
  @override
  final int typeId = 24;

  @override
  GlobalNotificationSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GlobalNotificationSettings(
      enabled: fields[0] as bool,
      quietHoursEnabled: fields[1] as bool,
      quietHoursStart: fields[2] as int,
      quietHoursEnd: fields[3] as int,
      defaultReminderDays: (fields[4] as List).cast<int>(),
      vibrationEnabled: fields[5] as bool,
      soundEnabled: fields[6] as bool,
      customSoundPath: fields[7] as String?,
      showPreview: fields[8] as bool,
      billReminders: fields[9] as bool,
      insightAlerts: fields[10] as bool,
      priceChangeAlerts: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GlobalNotificationSettings obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.enabled)
      ..writeByte(1)
      ..write(obj.quietHoursEnabled)
      ..writeByte(2)
      ..write(obj.quietHoursStart)
      ..writeByte(3)
      ..write(obj.quietHoursEnd)
      ..writeByte(4)
      ..write(obj.defaultReminderDays)
      ..writeByte(5)
      ..write(obj.vibrationEnabled)
      ..writeByte(6)
      ..write(obj.soundEnabled)
      ..writeByte(7)
      ..write(obj.customSoundPath)
      ..writeByte(8)
      ..write(obj.showPreview)
      ..writeByte(9)
      ..write(obj.billReminders)
      ..writeByte(10)
      ..write(obj.insightAlerts)
      ..writeByte(11)
      ..write(obj.priceChangeAlerts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlobalNotificationSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BudgetSettingsAdapter extends TypeAdapter<BudgetSettings> {
  @override
  final int typeId = 25;

  @override
  BudgetSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetSettings(
      monthlyBudget: fields[0] as double?,
      yearlyBudget: fields[1] as double?,
      alertOnThreshold: fields[2] as bool,
      thresholdPercent: fields[3] as double,
      categoryBudgets: (fields[4] as Map).cast<String, double>(),
      alertsEnabled: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BudgetSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.monthlyBudget)
      ..writeByte(1)
      ..write(obj.yearlyBudget)
      ..writeByte(2)
      ..write(obj.alertOnThreshold)
      ..writeByte(3)
      ..write(obj.thresholdPercent)
      ..writeByte(4)
      ..write(obj.categoryBudgets)
      ..writeByte(5)
      ..write(obj.alertsEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrivacySettingsAdapter extends TypeAdapter<PrivacySettings> {
  @override
  final int typeId = 26;

  @override
  PrivacySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrivacySettings(
      biometricLockEnabled: fields[0] as bool,
      hideAmountsInNotifications: fields[1] as bool,
      obscureAmountsOnScreen: fields[2] as bool,
      analyticsEnabled: fields[3] as bool,
      crashReportingEnabled: fields[4] as bool,
      localEncryptionEnabled: fields[5] as bool,
      autoLockTimeoutSeconds: fields[6] as int,
      cloudBackupEnabled: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PrivacySettings obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.biometricLockEnabled)
      ..writeByte(1)
      ..write(obj.hideAmountsInNotifications)
      ..writeByte(2)
      ..write(obj.obscureAmountsOnScreen)
      ..writeByte(3)
      ..write(obj.analyticsEnabled)
      ..writeByte(4)
      ..write(obj.crashReportingEnabled)
      ..writeByte(5)
      ..write(obj.localEncryptionEnabled)
      ..writeByte(6)
      ..write(obj.autoLockTimeoutSeconds)
      ..writeByte(7)
      ..write(obj.cloudBackupEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrivacySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserSettingsModelAdapter extends TypeAdapter<UserSettingsModel> {
  @override
  final int typeId = 2;

  @override
  UserSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettingsModel(
      id: fields[0] as String?,
      defaultCurrencyCode: fields[1] as String,
      themeMode: fields[2] as AppThemeMode,
      selectedThemeIndex: fields[25] == null ? 0 : fields[25] as int,
      accentColorHex: fields[3] as String?,
      notificationSettings: fields[4] as GlobalNotificationSettings,
      budgetSettings: fields[5] as BudgetSettings,
      privacySettings: fields[6] as PrivacySettings,
      tier: fields[7] as UserTier,
      tierExpiryDate: fields[8] as DateTime?,
      currencyDisplayFormat: fields[9] as CurrencyDisplayFormat,
      dateFormatPreference: fields[10] as DateFormatPreference,
      timezone: fields[11] as String?,
      hapticFeedbackEnabled: fields[12] as bool,
      animationsEnabled: fields[13] as bool,
      compactModeEnabled: fields[14] as bool,
      showCentsEnabled: fields[15] as bool,
      defaultPaymentMethod: fields[16] as String?,
      favoriteCategories: (fields[17] as List).cast<String>(),
      customSettings: (fields[18] as Map).cast<String, dynamic>(),
      onboardingCompleted: fields[19] as bool,
      createdAt: fields[20] as DateTime?,
      updatedAt: fields[21] as DateTime?,
      appOpenCount: fields[22] as int,
      lastBackupDate: fields[23] as DateTime?,
      debugModeEnabled: fields[24] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettingsModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.defaultCurrencyCode)
      ..writeByte(2)
      ..write(obj.themeMode)
      ..writeByte(3)
      ..write(obj.accentColorHex)
      ..writeByte(4)
      ..write(obj.notificationSettings)
      ..writeByte(5)
      ..write(obj.budgetSettings)
      ..writeByte(6)
      ..write(obj.privacySettings)
      ..writeByte(7)
      ..write(obj.tier)
      ..writeByte(8)
      ..write(obj.tierExpiryDate)
      ..writeByte(9)
      ..write(obj.currencyDisplayFormat)
      ..writeByte(10)
      ..write(obj.dateFormatPreference)
      ..writeByte(11)
      ..write(obj.timezone)
      ..writeByte(12)
      ..write(obj.hapticFeedbackEnabled)
      ..writeByte(13)
      ..write(obj.animationsEnabled)
      ..writeByte(14)
      ..write(obj.compactModeEnabled)
      ..writeByte(15)
      ..write(obj.showCentsEnabled)
      ..writeByte(16)
      ..write(obj.defaultPaymentMethod)
      ..writeByte(17)
      ..write(obj.favoriteCategories)
      ..writeByte(18)
      ..write(obj.customSettings)
      ..writeByte(19)
      ..write(obj.onboardingCompleted)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt)
      ..writeByte(22)
      ..write(obj.appOpenCount)
      ..writeByte(23)
      ..write(obj.lastBackupDate)
      ..writeByte(24)
      ..write(obj.debugModeEnabled)
      ..writeByte(25)
      ..write(obj.selectedThemeIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserTierAdapter extends TypeAdapter<UserTier> {
  @override
  final int typeId = 20;

  @override
  UserTier read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserTier.free;
      case 1:
        return UserTier.pro;
      case 2:
        return UserTier.lifetime;
      default:
        return UserTier.free;
    }
  }

  @override
  void write(BinaryWriter writer, UserTier obj) {
    switch (obj) {
      case UserTier.free:
        writer.writeByte(0);
        break;
      case UserTier.pro:
        writer.writeByte(1);
        break;
      case UserTier.lifetime:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppThemeModeAdapter extends TypeAdapter<AppThemeMode> {
  @override
  final int typeId = 21;

  @override
  AppThemeMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppThemeMode.system;
      case 1:
        return AppThemeMode.light;
      case 2:
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemeMode obj) {
    switch (obj) {
      case AppThemeMode.system:
        writer.writeByte(0);
        break;
      case AppThemeMode.light:
        writer.writeByte(1);
        break;
      case AppThemeMode.dark:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrencyDisplayFormatAdapter extends TypeAdapter<CurrencyDisplayFormat> {
  @override
  final int typeId = 22;

  @override
  CurrencyDisplayFormat read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CurrencyDisplayFormat.symbolFirst;
      case 1:
        return CurrencyDisplayFormat.symbolLast;
      case 2:
        return CurrencyDisplayFormat.codeFirst;
      case 3:
        return CurrencyDisplayFormat.codeLast;
      default:
        return CurrencyDisplayFormat.symbolFirst;
    }
  }

  @override
  void write(BinaryWriter writer, CurrencyDisplayFormat obj) {
    switch (obj) {
      case CurrencyDisplayFormat.symbolFirst:
        writer.writeByte(0);
        break;
      case CurrencyDisplayFormat.symbolLast:
        writer.writeByte(1);
        break;
      case CurrencyDisplayFormat.codeFirst:
        writer.writeByte(2);
        break;
      case CurrencyDisplayFormat.codeLast:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyDisplayFormatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DateFormatPreferenceAdapter extends TypeAdapter<DateFormatPreference> {
  @override
  final int typeId = 23;

  @override
  DateFormatPreference read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DateFormatPreference.ddMMyyyy;
      case 1:
        return DateFormatPreference.mmDdYyyy;
      case 2:
        return DateFormatPreference.yyyyMmDd;
      case 3:
        return DateFormatPreference.relative;
      default:
        return DateFormatPreference.ddMMyyyy;
    }
  }

  @override
  void write(BinaryWriter writer, DateFormatPreference obj) {
    switch (obj) {
      case DateFormatPreference.ddMMyyyy:
        writer.writeByte(0);
        break;
      case DateFormatPreference.mmDdYyyy:
        writer.writeByte(1);
        break;
      case DateFormatPreference.yyyyMmDd:
        writer.writeByte(2);
        break;
      case DateFormatPreference.relative:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateFormatPreferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
