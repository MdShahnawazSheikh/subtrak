import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:subtrak/app/controllers/bill_controller.dart';
import 'package:subtrak/app/data/models/bill_model.dart';
import 'package:subtrak/app/services/notification_services.dart';

class AddBillScreen extends StatefulWidget {
  final BillModel? editBill; // ✅ Add this

  const AddBillScreen({super.key, this.editBill});

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController amountCtrl = TextEditingController();
  final RxString recurrence = 'Monthly'.obs;
  final Rx<DateTime?> dueDate = Rx(null);

  @override
  void initState() {
    super.initState();

    if (widget.editBill != null) {
      titleCtrl.text = widget.editBill!.title;
      amountCtrl.text = widget.editBill!.amount.toString();
      recurrence.value = widget.editBill!.recurrence;
      dueDate.value = widget.editBill!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Subscription")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: "Service Name",
                prefixIcon: Icon(Icons.subscriptions),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount (₹)",
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<String>(
                value: recurrence.value,
                items: const [
                  DropdownMenuItem(value: "Daily", child: Text("Daily")),
                  DropdownMenuItem(value: "Weekly", child: Text("Weekly")),
                  DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                  DropdownMenuItem(value: "Yearly", child: Text("Yearly")),
                ],
                onChanged: (val) {
                  if (val != null) recurrence.value = val;
                },
                decoration: const InputDecoration(
                  labelText: "Repeat",
                  prefixIcon: Icon(Icons.repeat),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => ListTile(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dueDate.value = picked;
                  }
                },
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  dueDate.value != null
                      ? 'Due on: ${dueDate.value!.toLocal().toString().split(" ")[0]}'
                      : 'Select Due Date',
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              /*    onPressed: () {
                final controller = Get.find<BillController>();

                final newBill = BillModel(
                  id:
                      widget.editBill?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleCtrl.text.trim(),
                  amount: double.tryParse(amountCtrl.text.trim()) ?? 0,
                  recurrence: recurrence.value,
                  dueDate: dueDate.value ?? DateTime.now(),
                );

                if (widget.editBill != null) {
                  controller.removeBill(widget.editBill!.id); // remove old bill
                }

                controller.addBill(newBill); // add new/updated
                Get.back();
              }, */
              onPressed: () async {
                final controller = Get.find<BillController>();

                // Get platform-specific plugin
                final plugin =
                    NotificationService.flutterLocalNotificationsPlugin;
                final androidPlugin = plugin
                    .resolvePlatformSpecificImplementation<
                      AndroidFlutterLocalNotificationsPlugin
                    >();

                // Check & request exact alarm permission (Android 12+)
                if (androidPlugin != null && Platform.isAndroid) {
                  final plugin =
                      NotificationService.flutterLocalNotificationsPlugin;
                  final androidPlugin = plugin
                      .resolvePlatformSpecificImplementation<
                        AndroidFlutterLocalNotificationsPlugin
                      >();

                  final isExactAlarmAllowed = await androidPlugin
                      ?.requestExactAlarmsPermission();

                  if (isExactAlarmAllowed != true) {
                    Get.snackbar(
                      'Permission Required',
                      'Exact alarm permission is required to schedule reminders.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                }

                // Cancel old reminder if editing
                if (widget.editBill != null) {
                  controller.removeBill(widget.editBill!.id);
                  await NotificationService.cancelReminder(
                    int.parse(widget.editBill!.id),
                  );
                }

                // Generate safe 32-bit notification ID
                int notificationId = DateTime.now().millisecondsSinceEpoch
                    .remainder(100000);

                // Create the new bill
                final newBill = BillModel(
                  id: notificationId.toString(),
                  title: titleCtrl.text.trim(),
                  amount: double.tryParse(amountCtrl.text.trim()) ?? 0,
                  recurrence: recurrence.value,
                  dueDate: dueDate.value ?? DateTime.now(),
                );

                // Save bill and schedule reminder
                controller.addBill(newBill);
                await NotificationService.scheduleBillReminder(
                  id: notificationId,
                  title: newBill.title,
                  dueDate: newBill.dueDate,
                );

                Get.back();
              },

              icon: const Icon(Icons.save),
              label: const Text("Save"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
