// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyModelAdapter extends TypeAdapter<CurrencyModel> {
  @override
  final int typeId = 14;

  @override
  CurrencyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyModel(
      code: fields[0] as String,
      symbol: fields[1] as String,
      name: fields[2] as String,
      exchangeRateToBase: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.exchangeRateToBase);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriceTierAdapter extends TypeAdapter<PriceTier> {
  @override
  final int typeId = 15;

  @override
  PriceTier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceTier(
      amount: fields[0] as double,
      startDate: fields[1] as DateTime,
      endDate: fields[2] as DateTime?,
      note: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PriceTier obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceTierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationPreferenceAdapter
    extends TypeAdapter<NotificationPreference> {
  @override
  final int typeId = 16;

  @override
  NotificationPreference read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationPreference(
      enabled: fields[0] as bool,
      daysBefore: (fields[1] as List).cast<int>(),
      criticalAlert: fields[2] as bool,
      snoozeMinutes: fields[3] as int?,
      silentMode: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationPreference obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.enabled)
      ..writeByte(1)
      ..write(obj.daysBefore)
      ..writeByte(2)
      ..write(obj.criticalAlert)
      ..writeByte(3)
      ..write(obj.snoozeMinutes)
      ..writeByte(4)
      ..write(obj.silentMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UsageLogAdapter extends TypeAdapter<UsageLog> {
  @override
  final int typeId = 17;

  @override
  UsageLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsageLog(
      date: fields[0] as DateTime,
      usageMinutes: fields[1] as int,
      note: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UsageLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.usageMinutes)
      ..writeByte(2)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsageLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentRecordAdapter extends TypeAdapter<PaymentRecord> {
  @override
  final int typeId = 18;

  @override
  PaymentRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentRecord(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      amount: fields[2] as double,
      successful: fields[3] as bool,
      failureReason: fields[4] as String?,
      transactionId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.successful)
      ..writeByte(4)
      ..write(obj.failureReason)
      ..writeByte(5)
      ..write(obj.transactionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionModelAdapter extends TypeAdapter<SubscriptionModel> {
  @override
  final int typeId = 1;

  @override
  SubscriptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      amount: fields[3] as double,
      currencyCode: fields[4] as String,
      recurrenceType: fields[5] as RecurrenceType,
      customRecurrenceDays: fields[6] as int?,
      startDate: fields[7] as DateTime,
      nextBillingDate: fields[8] as DateTime,
      endDate: fields[9] as DateTime?,
      status: fields[10] as SubscriptionStatus,
      category: fields[11] as SubscriptionCategory,
      paymentMethod: fields[12] as PaymentMethod,
      paymentMethodDetails: fields[13] as String?,
      iconName: fields[14] as String?,
      colorHex: fields[15] as String?,
      websiteUrl: fields[16] as String?,
      cancellationUrl: fields[17] as String?,
      isTrial: fields[18] as bool,
      trialEndDate: fields[19] as DateTime?,
      gracePeriodDays: fields[20] as int?,
      priceHistory: (fields[21] as List).cast<PriceTier>(),
      usageLogs: (fields[22] as List).cast<UsageLog>(),
      paymentHistory: (fields[23] as List).cast<PaymentRecord>(),
      notificationPreference: fields[24] as NotificationPreference,
      tags: (fields[25] as List).cast<String>(),
      notes: fields[26] as String?,
      isPaused: fields[27] as bool,
      pausedAt: fields[28] as DateTime?,
      resumeAt: fields[29] as DateTime?,
      createdAt: fields[30] as DateTime?,
      updatedAt: fields[31] as DateTime?,
      isArchived: fields[32] as bool,
      linkedSubscriptionId: fields[33] as String?,
      autoRenew: fields[34] as bool,
      timezone: fields[35] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionModel obj) {
    writer
      ..writeByte(36)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.currencyCode)
      ..writeByte(5)
      ..write(obj.recurrenceType)
      ..writeByte(6)
      ..write(obj.customRecurrenceDays)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.nextBillingDate)
      ..writeByte(9)
      ..write(obj.endDate)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.category)
      ..writeByte(12)
      ..write(obj.paymentMethod)
      ..writeByte(13)
      ..write(obj.paymentMethodDetails)
      ..writeByte(14)
      ..write(obj.iconName)
      ..writeByte(15)
      ..write(obj.colorHex)
      ..writeByte(16)
      ..write(obj.websiteUrl)
      ..writeByte(17)
      ..write(obj.cancellationUrl)
      ..writeByte(18)
      ..write(obj.isTrial)
      ..writeByte(19)
      ..write(obj.trialEndDate)
      ..writeByte(20)
      ..write(obj.gracePeriodDays)
      ..writeByte(21)
      ..write(obj.priceHistory)
      ..writeByte(22)
      ..write(obj.usageLogs)
      ..writeByte(23)
      ..write(obj.paymentHistory)
      ..writeByte(24)
      ..write(obj.notificationPreference)
      ..writeByte(25)
      ..write(obj.tags)
      ..writeByte(26)
      ..write(obj.notes)
      ..writeByte(27)
      ..write(obj.isPaused)
      ..writeByte(28)
      ..write(obj.pausedAt)
      ..writeByte(29)
      ..write(obj.resumeAt)
      ..writeByte(30)
      ..write(obj.createdAt)
      ..writeByte(31)
      ..write(obj.updatedAt)
      ..writeByte(32)
      ..write(obj.isArchived)
      ..writeByte(33)
      ..write(obj.linkedSubscriptionId)
      ..writeByte(34)
      ..write(obj.autoRenew)
      ..writeByte(35)
      ..write(obj.timezone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceTypeAdapter extends TypeAdapter<RecurrenceType> {
  @override
  final int typeId = 10;

  @override
  RecurrenceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurrenceType.daily;
      case 1:
        return RecurrenceType.weekly;
      case 2:
        return RecurrenceType.biWeekly;
      case 3:
        return RecurrenceType.monthly;
      case 4:
        return RecurrenceType.biMonthly;
      case 5:
        return RecurrenceType.quarterly;
      case 6:
        return RecurrenceType.semiAnnual;
      case 7:
        return RecurrenceType.annual;
      case 8:
        return RecurrenceType.custom;
      case 9:
        return RecurrenceType.oneTime;
      default:
        return RecurrenceType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RecurrenceType obj) {
    switch (obj) {
      case RecurrenceType.daily:
        writer.writeByte(0);
        break;
      case RecurrenceType.weekly:
        writer.writeByte(1);
        break;
      case RecurrenceType.biWeekly:
        writer.writeByte(2);
        break;
      case RecurrenceType.monthly:
        writer.writeByte(3);
        break;
      case RecurrenceType.biMonthly:
        writer.writeByte(4);
        break;
      case RecurrenceType.quarterly:
        writer.writeByte(5);
        break;
      case RecurrenceType.semiAnnual:
        writer.writeByte(6);
        break;
      case RecurrenceType.annual:
        writer.writeByte(7);
        break;
      case RecurrenceType.custom:
        writer.writeByte(8);
        break;
      case RecurrenceType.oneTime:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionStatusAdapter extends TypeAdapter<SubscriptionStatus> {
  @override
  final int typeId = 11;

  @override
  SubscriptionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionStatus.active;
      case 1:
        return SubscriptionStatus.paused;
      case 2:
        return SubscriptionStatus.cancelled;
      case 3:
        return SubscriptionStatus.trial;
      case 4:
        return SubscriptionStatus.expired;
      case 5:
        return SubscriptionStatus.pendingCancellation;
      case 6:
        return SubscriptionStatus.paymentFailed;
      case 7:
        return SubscriptionStatus.gracePeriod;
      default:
        return SubscriptionStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionStatus obj) {
    switch (obj) {
      case SubscriptionStatus.active:
        writer.writeByte(0);
        break;
      case SubscriptionStatus.paused:
        writer.writeByte(1);
        break;
      case SubscriptionStatus.cancelled:
        writer.writeByte(2);
        break;
      case SubscriptionStatus.trial:
        writer.writeByte(3);
        break;
      case SubscriptionStatus.expired:
        writer.writeByte(4);
        break;
      case SubscriptionStatus.pendingCancellation:
        writer.writeByte(5);
        break;
      case SubscriptionStatus.paymentFailed:
        writer.writeByte(6);
        break;
      case SubscriptionStatus.gracePeriod:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentMethodAdapter extends TypeAdapter<PaymentMethod> {
  @override
  final int typeId = 12;

  @override
  PaymentMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentMethod.creditCard;
      case 1:
        return PaymentMethod.debitCard;
      case 2:
        return PaymentMethod.upi;
      case 3:
        return PaymentMethod.netBanking;
      case 4:
        return PaymentMethod.wallet;
      case 5:
        return PaymentMethod.autoPay;
      case 6:
        return PaymentMethod.manual;
      case 7:
        return PaymentMethod.other;
      default:
        return PaymentMethod.creditCard;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentMethod obj) {
    switch (obj) {
      case PaymentMethod.creditCard:
        writer.writeByte(0);
        break;
      case PaymentMethod.debitCard:
        writer.writeByte(1);
        break;
      case PaymentMethod.upi:
        writer.writeByte(2);
        break;
      case PaymentMethod.netBanking:
        writer.writeByte(3);
        break;
      case PaymentMethod.wallet:
        writer.writeByte(4);
        break;
      case PaymentMethod.autoPay:
        writer.writeByte(5);
        break;
      case PaymentMethod.manual:
        writer.writeByte(6);
        break;
      case PaymentMethod.other:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionCategoryAdapter extends TypeAdapter<SubscriptionCategory> {
  @override
  final int typeId = 13;

  @override
  SubscriptionCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionCategory.streaming;
      case 1:
        return SubscriptionCategory.music;
      case 2:
        return SubscriptionCategory.gaming;
      case 3:
        return SubscriptionCategory.productivity;
      case 4:
        return SubscriptionCategory.cloud;
      case 5:
        return SubscriptionCategory.news;
      case 6:
        return SubscriptionCategory.fitness;
      case 7:
        return SubscriptionCategory.education;
      case 8:
        return SubscriptionCategory.finance;
      case 9:
        return SubscriptionCategory.utilities;
      case 10:
        return SubscriptionCategory.shopping;
      case 11:
        return SubscriptionCategory.social;
      case 12:
        return SubscriptionCategory.food;
      case 13:
        return SubscriptionCategory.travel;
      case 14:
        return SubscriptionCategory.insurance;
      case 15:
        return SubscriptionCategory.telecom;
      case 16:
        return SubscriptionCategory.software;
      case 17:
        return SubscriptionCategory.other;
      default:
        return SubscriptionCategory.streaming;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionCategory obj) {
    switch (obj) {
      case SubscriptionCategory.streaming:
        writer.writeByte(0);
        break;
      case SubscriptionCategory.music:
        writer.writeByte(1);
        break;
      case SubscriptionCategory.gaming:
        writer.writeByte(2);
        break;
      case SubscriptionCategory.productivity:
        writer.writeByte(3);
        break;
      case SubscriptionCategory.cloud:
        writer.writeByte(4);
        break;
      case SubscriptionCategory.news:
        writer.writeByte(5);
        break;
      case SubscriptionCategory.fitness:
        writer.writeByte(6);
        break;
      case SubscriptionCategory.education:
        writer.writeByte(7);
        break;
      case SubscriptionCategory.finance:
        writer.writeByte(8);
        break;
      case SubscriptionCategory.utilities:
        writer.writeByte(9);
        break;
      case SubscriptionCategory.shopping:
        writer.writeByte(10);
        break;
      case SubscriptionCategory.social:
        writer.writeByte(11);
        break;
      case SubscriptionCategory.food:
        writer.writeByte(12);
        break;
      case SubscriptionCategory.travel:
        writer.writeByte(13);
        break;
      case SubscriptionCategory.insurance:
        writer.writeByte(14);
        break;
      case SubscriptionCategory.telecom:
        writer.writeByte(15);
        break;
      case SubscriptionCategory.software:
        writer.writeByte(16);
        break;
      case SubscriptionCategory.other:
        writer.writeByte(17);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
