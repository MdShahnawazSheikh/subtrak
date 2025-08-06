// calendar_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:subtrak/app/controllers/bill_controller.dart';
import 'package:subtrak/app/data/models/bill_model.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<BillController>();
    final bills = controller.bills;

    final monthBills = bills
        .where(
          (bill) =>
              bill.dueDate.year == _focusedDay.year &&
              bill.dueDate.month == _focusedDay.month,
        )
        .toList();

    final total = monthBills.fold<double>(0, (sum, bill) => sum + bill.amount);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Calendar',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Monthly total: ₹${total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TableCalendar<BillModel>(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _showDayBillsModal(context, selectedDay);
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, _) {
                  final dayBills = bills
                      .where(
                        (b) =>
                            b.dueDate.year == date.year &&
                            b.dueDate.month == date.month &&
                            b.dueDate.day == date.day,
                      )
                      .toList();

                  if (dayBills.isEmpty) return null;

                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dayBills
                          .take(3)
                          .map(
                            (bill) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: bill.recurrence == 'Monthly'
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDayBillsModal(BuildContext context, DateTime date) {
    final controller = Get.find<BillController>();
    final billsOnDay = controller.bills
        .where(
          (bill) =>
              bill.dueDate.year == date.year &&
              bill.dueDate.month == date.month &&
              bill.dueDate.day == date.day,
        )
        .toList();

    if (billsOnDay.isEmpty) return;

    final total = billsOnDay.fold<double>(0, (sum, b) => sum + b.amount);

    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'TOTAL: ₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...billsOnDay.map(
              (b) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade900,
                  child: Icon(Icons.subscriptions, color: Colors.white),
                ),
                title: Text(b.title, style: TextStyle(color: Colors.white)),
                trailing: Text(
                  '₹${b.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat('EEE, MMM d').format(date),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
