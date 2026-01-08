import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/data/models/subscription_model.dart';
import '../../app/controllers/subscription_controller.dart';
import '../widgets/premium_components.dart';
import 'add_subscription_screen.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  final SubscriptionModel? subscription;

  const SubscriptionDetailScreen({super.key, this.subscription});

  @override
  State<SubscriptionDetailScreen> createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  final SubscriptionController _controller = Get.find();
  SubscriptionModel? _subscription;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  void _loadSubscription() {
    if (widget.subscription != null) {
      setState(() {
        _subscription = widget.subscription;
        _isLoading = false;
      });
    } else {
      // Get from route parameter
      final id = Get.parameters['id'];
      if (id != null) {
        final sub = _controller.getById(id);
        if (sub != null) {
          setState(() {
            _subscription = sub;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Subscription not found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'No subscription ID provided';
          _isLoading = false;
        });
      }
    }
  }

  void _refresh() {
    if (_subscription == null) return;
    final updated = _controller.getById(_subscription!.id);
    if (updated != null) {
      setState(() => _subscription = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    if (_error != null || _subscription == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(_error ?? 'Unknown error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final sub = _subscription!;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, sub),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, sub),
                const SizedBox(height: 24),
                _buildQuickActions(context, sub),
                const SizedBox(height: 24),
                _buildBillingSection(context, sub),
                const SizedBox(height: 24),
                _buildStatsSection(context, sub),
                if (sub.notes != null && sub.notes!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildNotesSection(context, sub),
                ],
                if (sub.paymentHistory.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildPaymentHistory(context, sub),
                ],
                if (sub.priceHistory.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildPriceHistory(context, sub),
                ],
                const SizedBox(height: 32),
                _buildDangerZone(context, sub),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);
    final color = sub.color ?? theme.colorScheme.primary;

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: color,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: () => _editSubscription(sub),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) => _handleMenuAction(value, sub),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'duplicate',
              child: ListTile(
                leading: Icon(Icons.content_copy_outlined),
                title: Text('Duplicate'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'share',
              child: ListTile(
                leading: Icon(Icons.share_outlined),
                title: Text('Share'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'archive',
              child: ListTile(
                leading: Icon(Icons.archive_outlined),
                title: Text('Archive'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _buildLogo(sub, color),
                const SizedBox(height: 16),
                Text(
                  sub.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                _buildStatusChip(sub),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(SubscriptionModel sub, Color fallbackColor) {
    // Use default logo with color since iconUrl is not in model
    return _buildDefaultLogo(sub, fallbackColor);
  }

  Widget _buildDefaultLogo(SubscriptionModel sub, Color color) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          sub.name.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(SubscriptionModel sub) {
    Color bgColor;
    String text;

    switch (sub.status) {
      case SubscriptionStatus.active:
        bgColor = Colors.white.withOpacity(0.2);
        text = '● Active';
        break;
      case SubscriptionStatus.paused:
        bgColor = Colors.orange.withOpacity(0.3);
        text = '⏸ Paused';
        break;
      case SubscriptionStatus.cancelled:
        bgColor = Colors.red.withOpacity(0.3);
        text = '✕ Cancelled';
        break;
      case SubscriptionStatus.trial:
        bgColor = Colors.purple.withOpacity(0.3);
        text = '⏱ Trial';
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.3);
        text = sub.status.name;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                sub.currency.symbol,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              AnimatedAmount(
                amount: sub.amount,
                prefix: '',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ ${_getRecurrenceText(sub.recurrenceType)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ],
          ),
          if (sub.description != null && sub.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              sub.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
          if (sub.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sub.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, SubscriptionModel sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              context,
              icon: sub.status == SubscriptionStatus.paused
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded,
              label: sub.status == SubscriptionStatus.paused
                  ? 'Resume'
                  : 'Pause',
              onTap: () => _togglePause(sub),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context,
              icon: Icons.check_rounded,
              label: 'Log Usage',
              onTap: () => _logUsage(sub),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context,
              icon: Icons.notifications_outlined,
              label: 'Remind',
              onTap: () => _setReminder(sub),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingSection(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Billing',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'Next billing',
              DateFormat('MMMM d, yyyy').format(sub.nextBillingDate),
              icon: Icons.event_outlined,
              highlight: sub.isOverdue,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              'Start date',
              DateFormat('MMMM d, yyyy').format(sub.startDate),
              icon: Icons.calendar_today_outlined,
            ),
            if (sub.endDate != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                context,
                'End date',
                DateFormat('MMMM d, yyyy').format(sub.endDate!),
                icon: Icons.event_busy_outlined,
              ),
            ],
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              'Recurrence',
              _getRecurrenceText(sub.recurrenceType),
              icon: Icons.today_outlined,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              'Payment method',
              sub.paymentMethod.name.capitalizeFirst ?? '',
              icon: Icons.payment_outlined,
            ),
            if (sub.isTrial) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                context,
                'Trial ends',
                sub.trialEndDate != null
                    ? DateFormat('MMMM d, yyyy').format(sub.trialEndDate!)
                    : 'Not set',
                icon: Icons.timer_outlined,
                highlight: sub.isTrialEndingSoon,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    bool highlight = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 18,
            color: highlight
                ? Colors.red
                : theme.textTheme.bodySmall?.color?.withOpacity(0.5),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: highlight ? Colors.red : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Daily Cost',
                    '${sub.currency.symbol}${sub.costPerDay.toStringAsFixed(2)}',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Monthly',
                    '${sub.currency.symbol}${sub.monthlyEquivalent.toStringAsFixed(0)}',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Yearly',
                    '${sub.currency.symbol}${sub.annualCost.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),
            if (sub.usageLogs.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Usage/Month',
                      '${sub.averageMonthlyUsage.toStringAsFixed(1)}x',
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Cost/Use',
                      sub.costPerUse > 0
                          ? '${sub.currency.symbol}${sub.costPerUse.toStringAsFixed(0)}'
                          : 'N/A',
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Worth It',
                      '${(sub.worthItScore * 100).toInt()}%',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notes',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () => _editNotes(sub),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(sub.notes!, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistory(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Payment History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...sub.paymentHistory.take(5).map((payment) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    payment.successful
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    size: 20,
                    color: payment.successful ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMM d, yyyy').format(payment.date),
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (!payment.successful)
                          Text(
                            'Failed',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${sub.currency.symbol}${payment.amount.toStringAsFixed(0)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPriceHistory(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Text(
                  'Price History',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if ((sub.priceIncreasePercent ?? 0) > 0) ...[
                  const SizedBox(width: 8),
                  PremiumBadge(
                    text: '+${sub.priceIncreasePercent!.toStringAsFixed(0)}%',
                    color: Colors.red,
                    small: true,
                  ),
                ],
              ],
            ),
          ),
          ...sub.priceHistory.map((tier) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    size: 20,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      DateFormat('MMM d, yyyy').format(tier.startDate),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '${sub.currency.symbol}${tier.amount.toStringAsFixed(0)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Danger Zone',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
          GlassCard(
            padding: const EdgeInsets.all(16),
            color: Colors.red.withOpacity(0.05),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.cancel_outlined, color: Colors.red),
                  title: const Text('Cancel Subscription'),
                  subtitle: const Text('Mark as cancelled'),
                  onTap: () => _cancelSubscription(sub),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Delete'),
                  subtitle: const Text('Permanently remove'),
                  onTap: () => _confirmDelete(sub),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Action handlers
  void _editSubscription(SubscriptionModel sub) {
    Get.to(
      () => AddSubscriptionScreen(editSubscription: sub),
      transition: Transition.rightToLeft,
    )?.then((_) => _refresh());
  }

  void _handleMenuAction(String action, SubscriptionModel sub) {
    switch (action) {
      case 'duplicate':
        _controller.duplicateSubscription(sub.id);
        Get.back();
        Get.snackbar('Success', 'Subscription duplicated');
        break;
      case 'share':
        _shareSubscription(sub);
        break;
      case 'archive':
        _controller.archiveSubscription(sub.id);
        Get.back();
        Get.snackbar('Success', 'Subscription archived');
        break;
    }
  }

  void _shareSubscription(SubscriptionModel sub) {
    final currencySymbol = sub.currency.symbol;
    final amount = '$currencySymbol${sub.amount.toStringAsFixed(2)}';
    final recurrence = sub.recurrenceType.name;
    final nextBilling = DateFormat.yMMMd().format(sub.nextBillingDate);

    final text =
        '''
📱 Subscription: ${sub.name}
💰 Amount: $amount/$recurrence
📅 Next billing: $nextBilling
📂 Category: ${sub.category.name}

Tracked with SubTrak - the smart subscription manager!
''';

    Share.share(text, subject: '${sub.name} Subscription Details');
  }

  void _togglePause(SubscriptionModel sub) {
    if (sub.status == SubscriptionStatus.paused) {
      _controller.resumeSubscription(sub.id);
    } else {
      _controller.pauseSubscription(sub.id);
    }
    _refresh();
  }

  void _logUsage(SubscriptionModel sub) {
    _controller.logUsage(sub.id, 30); // Default 30 minutes usage
    Get.snackbar('Usage Logged', 'Recorded usage for ${sub.name}');
    _refresh();
  }

  void _setReminder(SubscriptionModel sub) {
    final reminderOptions = [1, 2, 3, 5, 7, 14, 30];
    final selectedDays = List<int>.from(sub.notificationPreference.daysBefore);

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Set Reminders'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Notify me before billing date:'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: reminderOptions.map((days) {
                    final isSelected = selectedDays.contains(days);
                    return FilterChip(
                      label: Text('$days ${days == 1 ? 'day' : 'days'}'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedDays.add(days);
                          } else {
                            selectedDays.remove(days);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  selectedDays.sort();
                  final updated = sub.copyWith(
                    notificationPreference: NotificationPreference(
                      enabled: selectedDays.isNotEmpty,
                      daysBefore: selectedDays,
                    ),
                  );
                  _controller.updateSubscription(updated);
                  Get.back();
                  Get.snackbar(
                    'Reminders Updated',
                    'Your reminder preferences have been saved',
                  );
                  _refresh();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editNotes(SubscriptionModel sub) {
    final textController = TextEditingController(text: sub.notes);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Notes'),
        content: TextField(
          controller: textController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Add notes about this subscription...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final updated = sub.copyWith(notes: textController.text.trim());
              _controller.updateSubscription(updated);
              Get.back();
              Get.snackbar('Notes Saved', 'Your notes have been saved');
              _refresh();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _cancelSubscription(SubscriptionModel sub) {
    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Subscription'),
        content: const Text(
          'Are you sure you want to mark this subscription as cancelled?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('No')),
          TextButton(
            onPressed: () {
              final updated = sub.copyWith(
                status: SubscriptionStatus.cancelled,
              );
              _controller.updateSubscription(updated);
              Get.back();
              Get.snackbar(
                'Subscription Cancelled',
                '${sub.name} has been marked as cancelled',
              );
              _refresh();
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(SubscriptionModel sub) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Subscription'),
        content: Text('Are you sure you want to delete "${sub.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _controller.deleteSubscription(sub.id);
              Get.back(); // Close detail screen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getRecurrenceText(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.daily:
        return 'day';
      case RecurrenceType.weekly:
        return 'week';
      case RecurrenceType.biWeekly:
        return '2 weeks';
      case RecurrenceType.monthly:
        return 'month';
      case RecurrenceType.biMonthly:
        return '2 months';
      case RecurrenceType.quarterly:
        return 'quarter';
      case RecurrenceType.semiAnnual:
        return '6 months';
      case RecurrenceType.annual:
        return 'year';
      case RecurrenceType.custom:
        return 'custom';
      case RecurrenceType.oneTime:
        return 'one-time';
    }
  }
}
