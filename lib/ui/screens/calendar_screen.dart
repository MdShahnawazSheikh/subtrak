import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../app/data/models/subscription_model.dart';
import '../../app/controllers/subscription_controller.dart';
import '../widgets/premium_components.dart';
import '../widgets/subscription_card.dart';
import 'subscription_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  final SubscriptionController _controller = Get.find();

  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SubscriptionModel> _getEventsForDay(DateTime day) {
    return _controller.subscriptions.where((sub) {
      return isSameDay(sub.nextBillingDate, day);
    }).toList();
  }

  double _getSpendForDay(DateTime day) {
    final events = _getEventsForDay(day);
    return events.fold(0.0, (sum, sub) => sum + sub.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Calendar'),
            Tab(text: 'Timeline'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCalendarView(context), _buildTimelineView(context)],
      ),
    );
  }

  Widget _buildCalendarView(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Obx(() {
          _controller.subscriptions.length;

          return TableCalendar<SubscriptionModel>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
              ),
              holidayTextStyle: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
              ),
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
              markerSize: 6,
              markerMargin: const EdgeInsets.symmetric(horizontal: 1),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonDecoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              formatButtonTextStyle: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 12,
              ),
              titleTextStyle: theme.textTheme.titleMedium!,
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: theme.iconTheme.color,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: theme.iconTheme.color,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              HapticFeedback.lightImpact();
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;

                final spend = _getSpendForDay(date);
                return Positioned(
                  bottom: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '₹${spend.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
        const Divider(),
        Expanded(child: _buildDayDetails(context)),
      ],
    );
  }

  Widget _buildDayDetails(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDay = _selectedDay ?? DateTime.now();

    return Obx(() {
      final events = _getEventsForDay(selectedDay);
      final totalSpend = _getSpendForDay(selectedDay);

      if (events.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event_available_outlined,
                size: 48,
                color: theme.hintColor,
              ),
              const SizedBox(height: 16),
              Text(
                'No bills on ${DateFormat('MMMM d').format(selectedDay)}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, MMMM d').format(selectedDay),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${events.length} bill${events.length > 1 ? 's' : ''}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₹${totalSpend.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final sub = events[index];
                return SubscriptionCard(
                  subscription: sub,
                  compact: true,
                  onTap: () => Get.to(
                    () => SubscriptionDetailScreen(subscription: sub),
                    transition: Transition.cupertino,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTimelineView(BuildContext context) {
    return Obx(() {
      final upcoming = _controller.upcomingSubscriptions;

      if (upcoming.isEmpty) {
        return EmptyStateWidget(
          icon: Icons.timeline_outlined,
          title: 'No upcoming bills',
          subtitle: 'Add subscriptions to see your billing timeline',
        );
      }

      final Map<String, List<SubscriptionModel>> grouped = {};
      for (final sub in upcoming) {
        final key = DateFormat('yyyy-MM-dd').format(sub.nextBillingDate);
        grouped.putIfAbsent(key, () => []).add(sub);
      }

      final sortedKeys = grouped.keys.toList()..sort();

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: sortedKeys.length,
        itemBuilder: (context, index) {
          final dateKey = sortedKeys[index];
          final subs = grouped[dateKey]!;
          final date = DateTime.parse(dateKey);
          final totalSpend = subs.fold(0.0, (sum, s) => sum + s.amount);

          return _buildTimelineDay(context, date, subs, totalSpend, index == 0);
        },
      );
    });
  }

  Widget _buildTimelineDay(
    BuildContext context,
    DateTime date,
    List<SubscriptionModel> subs,
    double totalSpend,
    bool isFirst,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();
    final isToday = isSameDay(date, now);
    final isPast = date.isBefore(now);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isToday
                    ? theme.colorScheme.primary
                    : isPast
                    ? Colors.grey
                    : theme.colorScheme.primary.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isToday
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            Container(
              width: 2,
              height: 100,
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        _formatTimelineDate(date),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isToday ? theme.colorScheme.primary : null,
                        ),
                      ),
                      if (isToday) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'TODAY',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    '₹${totalSpend.toStringAsFixed(0)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...subs.map((sub) => _buildTimelineItem(context, sub)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = sub.color ?? theme.colorScheme.primary;

    return GestureDetector(
      onTap: () => Get.to(
        () => SubscriptionDetailScreen(subscription: sub),
        transition: Transition.cupertino,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.grey.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  sub.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                sub.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '₹${sub.amount.toStringAsFixed(0)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimelineDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (isSameDay(date, now)) {
      return 'Today';
    } else if (isSameDay(date, now.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    } else if (difference.inDays < 7 && difference.inDays > 0) {
      return DateFormat('EEEE').format(date);
    } else {
      return DateFormat('EEEE, MMM d').format(date);
    }
  }
}
