import 'package:hive/hive.dart';

part 'bill_model.g.dart';

@HiveType(typeId: 0)
class BillModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String recurrence;

  @HiveField(4)
  final DateTime dueDate;

  BillModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.recurrence,
    required this.dueDate,
  });
}
