// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_template_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionTemplateAdapter extends TypeAdapter<SubscriptionTemplate> {
  @override
  final int typeId = 3;

  @override
  SubscriptionTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionTemplate(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      suggestedAmount: fields[3] as double?,
      currencyCode: fields[4] as String,
      recurrenceType: fields[5] as String,
      category: fields[6] as String,
      iconName: fields[7] as String,
      colorHex: fields[8] as String,
      websiteUrl: fields[9] as String?,
      cancellationUrl: fields[10] as String?,
      aliases: (fields[11] as List).cast<String>(),
      isPopular: fields[12] as bool,
      usageCount: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionTemplate obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.suggestedAmount)
      ..writeByte(4)
      ..write(obj.currencyCode)
      ..writeByte(5)
      ..write(obj.recurrenceType)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.iconName)
      ..writeByte(8)
      ..write(obj.colorHex)
      ..writeByte(9)
      ..write(obj.websiteUrl)
      ..writeByte(10)
      ..write(obj.cancellationUrl)
      ..writeByte(11)
      ..write(obj.aliases)
      ..writeByte(12)
      ..write(obj.isPopular)
      ..writeByte(13)
      ..write(obj.usageCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
