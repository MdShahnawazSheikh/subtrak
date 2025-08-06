import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/bill_controller.dart';
import '../../app/data/models/bill_model.dart';
import '../screens/add_bill_screen.dart';

class BillTile extends StatelessWidget {
  final BillModel bill;

  const BillTile({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bill.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Due on ${bill.dueDate.toString().split(" ")[0]}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${bill.amount.toInt()}",
                style: theme.textTheme.titleMedium,
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  final controller = Get.find<BillController>();
                  if (value == 'edit') {
                    Get.to(() => AddBillScreen(editBill: bill));
                  } else if (value == 'delete') {
                    controller.removeBill(bill.id);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text("Edit")),
                  const PopupMenuItem(value: 'delete', child: Text("Delete")),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
