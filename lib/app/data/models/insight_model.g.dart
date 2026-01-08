// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsightActionAdapter extends TypeAdapter<InsightAction> {
  @override
  final int typeId = 33;

  @override
  InsightAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsightAction(
      type: fields[0] as InsightActionType,
      label: fields[1] as String,
      subscriptionId: fields[2] as String?,
      url: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, InsightAction obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.subscriptionId)
      ..writeByte(3)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightModelAdapter extends TypeAdapter<InsightModel> {
  @override
  final int typeId = 4;

  @override
  InsightModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsightModel(
      id: fields[0] as String,
      type: fields[1] as InsightType,
      title: fields[2] as String,
      description: fields[3] as String,
      priority: fields[4] as InsightPriority,
      potentialSavings: fields[5] as double?,
      currencyCode: fields[6] as String?,
      relatedSubscriptionIds: (fields[7] as List).cast<String>(),
      actions: (fields[8] as List).cast<InsightAction>(),
      createdAt: fields[9] as DateTime?,
      expiresAt: fields[10] as DateTime?,
      isDismissed: fields[11] as bool,
      dismissedAt: fields[12] as DateTime?,
      isActioned: fields[13] as bool,
      actionedWith: fields[14] as InsightActionType?,
      iconName: fields[15] as String?,
      colorHex: fields[16] as String?,
      metadata: (fields[17] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, InsightModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.potentialSavings)
      ..writeByte(6)
      ..write(obj.currencyCode)
      ..writeByte(7)
      ..write(obj.relatedSubscriptionIds)
      ..writeByte(8)
      ..write(obj.actions)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.expiresAt)
      ..writeByte(11)
      ..write(obj.isDismissed)
      ..writeByte(12)
      ..write(obj.dismissedAt)
      ..writeByte(13)
      ..write(obj.isActioned)
      ..writeByte(14)
      ..write(obj.actionedWith)
      ..writeByte(15)
      ..write(obj.iconName)
      ..writeByte(16)
      ..write(obj.colorHex)
      ..writeByte(17)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmartRuleAdapter extends TypeAdapter<SmartRule> {
  @override
  final int typeId = 5;

  @override
  SmartRule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartRule(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      condition: fields[3] as SmartRuleCondition,
      action: fields[4] as SmartRuleAction,
      isEnabled: fields[5] as bool,
      createdAt: fields[6] as DateTime?,
      lastTriggeredAt: fields[7] as DateTime?,
      triggerCount: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SmartRule obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.condition)
      ..writeByte(4)
      ..write(obj.action)
      ..writeByte(5)
      ..write(obj.isEnabled)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.lastTriggeredAt)
      ..writeByte(8)
      ..write(obj.triggerCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartRuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmartRuleConditionAdapter extends TypeAdapter<SmartRuleCondition> {
  @override
  final int typeId = 35;

  @override
  SmartRuleCondition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartRuleCondition(
      type: fields[0] as RuleConditionType,
      subscriptionId: fields[1] as String?,
      subscriptionName: fields[2] as String?,
      category: fields[3] as String?,
      threshold: fields[4] as double?,
      days: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SmartRuleCondition obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.subscriptionId)
      ..writeByte(2)
      ..write(obj.subscriptionName)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.threshold)
      ..writeByte(5)
      ..write(obj.days);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartRuleConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmartRuleActionAdapter extends TypeAdapter<SmartRuleAction> {
  @override
  final int typeId = 37;

  @override
  SmartRuleAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartRuleAction(
      type: fields[0] as RuleActionType,
      message: fields[1] as String,
      priority: fields[2] as InsightPriority,
    );
  }

  @override
  void write(BinaryWriter writer, SmartRuleAction obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartRuleActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AuditLogEntryAdapter extends TypeAdapter<AuditLogEntry> {
  @override
  final int typeId = 6;

  @override
  AuditLogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuditLogEntry(
      id: fields[0] as String,
      action: fields[1] as AuditAction,
      entityType: fields[2] as String,
      entityId: fields[3] as String,
      entityName: fields[4] as String?,
      previousState: (fields[5] as Map?)?.cast<String, dynamic>(),
      newState: (fields[6] as Map?)?.cast<String, dynamic>(),
      timestamp: fields[7] as DateTime?,
      notes: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AuditLogEntry obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.action)
      ..writeByte(2)
      ..write(obj.entityType)
      ..writeByte(3)
      ..write(obj.entityId)
      ..writeByte(4)
      ..write(obj.entityName)
      ..writeByte(5)
      ..write(obj.previousState)
      ..writeByte(6)
      ..write(obj.newState)
      ..writeByte(7)
      ..write(obj.timestamp)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuditLogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SavedViewAdapter extends TypeAdapter<SavedView> {
  @override
  final int typeId = 7;

  @override
  SavedView read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedView(
      id: fields[0] as String,
      name: fields[1] as String,
      iconName: fields[2] as String?,
      filterTags: (fields[3] as List).cast<String>(),
      filterCategories: (fields[4] as List).cast<String>(),
      filterStatuses: (fields[5] as List).cast<String>(),
      sortBy: fields[6] as String?,
      sortAscending: fields[7] as bool,
      minAmount: fields[8] as double?,
      maxAmount: fields[9] as double?,
      showArchived: fields[10] as bool,
      createdAt: fields[11] as DateTime?,
      usageCount: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SavedView obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconName)
      ..writeByte(3)
      ..write(obj.filterTags)
      ..writeByte(4)
      ..write(obj.filterCategories)
      ..writeByte(5)
      ..write(obj.filterStatuses)
      ..writeByte(6)
      ..write(obj.sortBy)
      ..writeByte(7)
      ..write(obj.sortAscending)
      ..writeByte(8)
      ..write(obj.minAmount)
      ..writeByte(9)
      ..write(obj.maxAmount)
      ..writeByte(10)
      ..write(obj.showArchived)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.usageCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedViewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightTypeAdapter extends TypeAdapter<InsightType> {
  @override
  final int typeId = 30;

  @override
  InsightType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InsightType.costSaving;
      case 1:
        return InsightType.unusedSubscription;
      case 2:
        return InsightType.priceIncrease;
      case 3:
        return InsightType.trialEnding;
      case 4:
        return InsightType.duplicateService;
      case 5:
        return InsightType.budgetWarning;
      case 6:
        return InsightType.paymentUpcoming;
      case 7:
        return InsightType.regretDetection;
      case 8:
        return InsightType.spendDrift;
      case 9:
        return InsightType.categorySpike;
      case 10:
        return InsightType.monthlySummary;
      case 11:
        return InsightType.annualProjection;
      case 12:
        return InsightType.worthItScore;
      case 13:
        return InsightType.behavioralNudge;
      default:
        return InsightType.costSaving;
    }
  }

  @override
  void write(BinaryWriter writer, InsightType obj) {
    switch (obj) {
      case InsightType.costSaving:
        writer.writeByte(0);
        break;
      case InsightType.unusedSubscription:
        writer.writeByte(1);
        break;
      case InsightType.priceIncrease:
        writer.writeByte(2);
        break;
      case InsightType.trialEnding:
        writer.writeByte(3);
        break;
      case InsightType.duplicateService:
        writer.writeByte(4);
        break;
      case InsightType.budgetWarning:
        writer.writeByte(5);
        break;
      case InsightType.paymentUpcoming:
        writer.writeByte(6);
        break;
      case InsightType.regretDetection:
        writer.writeByte(7);
        break;
      case InsightType.spendDrift:
        writer.writeByte(8);
        break;
      case InsightType.categorySpike:
        writer.writeByte(9);
        break;
      case InsightType.monthlySummary:
        writer.writeByte(10);
        break;
      case InsightType.annualProjection:
        writer.writeByte(11);
        break;
      case InsightType.worthItScore:
        writer.writeByte(12);
        break;
      case InsightType.behavioralNudge:
        writer.writeByte(13);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightPriorityAdapter extends TypeAdapter<InsightPriority> {
  @override
  final int typeId = 31;

  @override
  InsightPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InsightPriority.low;
      case 1:
        return InsightPriority.medium;
      case 2:
        return InsightPriority.high;
      case 3:
        return InsightPriority.critical;
      default:
        return InsightPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, InsightPriority obj) {
    switch (obj) {
      case InsightPriority.low:
        writer.writeByte(0);
        break;
      case InsightPriority.medium:
        writer.writeByte(1);
        break;
      case InsightPriority.high:
        writer.writeByte(2);
        break;
      case InsightPriority.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightActionTypeAdapter extends TypeAdapter<InsightActionType> {
  @override
  final int typeId = 32;

  @override
  InsightActionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InsightActionType.cancel;
      case 1:
        return InsightActionType.pause;
      case 2:
        return InsightActionType.review;
      case 3:
        return InsightActionType.downgrade;
      case 4:
        return InsightActionType.negotiate;
      case 5:
        return InsightActionType.remind;
      case 6:
        return InsightActionType.dismiss;
      case 7:
        return InsightActionType.viewDetails;
      case 8:
        return InsightActionType.logUsage;
      default:
        return InsightActionType.cancel;
    }
  }

  @override
  void write(BinaryWriter writer, InsightActionType obj) {
    switch (obj) {
      case InsightActionType.cancel:
        writer.writeByte(0);
        break;
      case InsightActionType.pause:
        writer.writeByte(1);
        break;
      case InsightActionType.review:
        writer.writeByte(2);
        break;
      case InsightActionType.downgrade:
        writer.writeByte(3);
        break;
      case InsightActionType.negotiate:
        writer.writeByte(4);
        break;
      case InsightActionType.remind:
        writer.writeByte(5);
        break;
      case InsightActionType.dismiss:
        writer.writeByte(6);
        break;
      case InsightActionType.viewDetails:
        writer.writeByte(7);
        break;
      case InsightActionType.logUsage:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightActionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RuleConditionTypeAdapter extends TypeAdapter<RuleConditionType> {
  @override
  final int typeId = 34;

  @override
  RuleConditionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RuleConditionType.unusedForDays;
      case 1:
        return RuleConditionType.costExceeds;
      case 2:
        return RuleConditionType.categorySpendExceeds;
      case 3:
        return RuleConditionType.trialEndingSoon;
      case 4:
        return RuleConditionType.priceIncreased;
      case 5:
        return RuleConditionType.subscriptionAgeDays;
      case 6:
        return RuleConditionType.lowUsage;
      default:
        return RuleConditionType.unusedForDays;
    }
  }

  @override
  void write(BinaryWriter writer, RuleConditionType obj) {
    switch (obj) {
      case RuleConditionType.unusedForDays:
        writer.writeByte(0);
        break;
      case RuleConditionType.costExceeds:
        writer.writeByte(1);
        break;
      case RuleConditionType.categorySpendExceeds:
        writer.writeByte(2);
        break;
      case RuleConditionType.trialEndingSoon:
        writer.writeByte(3);
        break;
      case RuleConditionType.priceIncreased:
        writer.writeByte(4);
        break;
      case RuleConditionType.subscriptionAgeDays:
        writer.writeByte(5);
        break;
      case RuleConditionType.lowUsage:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuleConditionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RuleActionTypeAdapter extends TypeAdapter<RuleActionType> {
  @override
  final int typeId = 36;

  @override
  RuleActionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RuleActionType.sendAlert;
      case 1:
        return RuleActionType.createInsight;
      case 2:
        return RuleActionType.suggestCancel;
      case 3:
        return RuleActionType.suggestPause;
      case 4:
        return RuleActionType.logWarning;
      default:
        return RuleActionType.sendAlert;
    }
  }

  @override
  void write(BinaryWriter writer, RuleActionType obj) {
    switch (obj) {
      case RuleActionType.sendAlert:
        writer.writeByte(0);
        break;
      case RuleActionType.createInsight:
        writer.writeByte(1);
        break;
      case RuleActionType.suggestCancel:
        writer.writeByte(2);
        break;
      case RuleActionType.suggestPause:
        writer.writeByte(3);
        break;
      case RuleActionType.logWarning:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuleActionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AuditActionAdapter extends TypeAdapter<AuditAction> {
  @override
  final int typeId = 38;

  @override
  AuditAction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AuditAction.create;
      case 1:
        return AuditAction.update;
      case 2:
        return AuditAction.delete;
      case 3:
        return AuditAction.pause;
      case 4:
        return AuditAction.resume;
      case 5:
        return AuditAction.cancel;
      case 6:
        return AuditAction.archive;
      case 7:
        return AuditAction.restore;
      case 8:
        return AuditAction.import_;
      case 9:
        return AuditAction.export_;
      case 10:
        return AuditAction.backup;
      case 11:
        return AuditAction.settingsChange;
      default:
        return AuditAction.create;
    }
  }

  @override
  void write(BinaryWriter writer, AuditAction obj) {
    switch (obj) {
      case AuditAction.create:
        writer.writeByte(0);
        break;
      case AuditAction.update:
        writer.writeByte(1);
        break;
      case AuditAction.delete:
        writer.writeByte(2);
        break;
      case AuditAction.pause:
        writer.writeByte(3);
        break;
      case AuditAction.resume:
        writer.writeByte(4);
        break;
      case AuditAction.cancel:
        writer.writeByte(5);
        break;
      case AuditAction.archive:
        writer.writeByte(6);
        break;
      case AuditAction.restore:
        writer.writeByte(7);
        break;
      case AuditAction.import_:
        writer.writeByte(8);
        break;
      case AuditAction.export_:
        writer.writeByte(9);
        break;
      case AuditAction.backup:
        writer.writeByte(10);
        break;
      case AuditAction.settingsChange:
        writer.writeByte(11);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuditActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
