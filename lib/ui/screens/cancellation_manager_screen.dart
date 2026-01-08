import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/data/models/subscription_model.dart';
import '../widgets/modern_ui_components.dart';

/// Cancellation & Renewal Manager Screen - Modern Redesign
class CancellationManagerScreen extends StatefulWidget {
  const CancellationManagerScreen({super.key});

  @override
  State<CancellationManagerScreen> createState() =>
      _CancellationManagerScreenState();
}

class _CancellationManagerScreenState extends State<CancellationManagerScreen> {
  final SubscriptionController _controller = Get.find();
  int _selectedTab = 0; // 0 = Upcoming, 1 = Cancelled

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildRenewalSummary(context)),
          SliverToBoxAdapter(child: _buildTabSelector(context)),
          SliverToBoxAdapter(
            child: _selectedTab == 0
                ? _buildUpcomingRenewals(context)
                : _buildCancelledSubscriptions(context),
          ),
          SliverToBoxAdapter(child: _buildCancellationTips(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Renewals & Cancellations',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildRenewalSummary(BuildContext context) {
    return Obx(() {
      final subs = _controller.filteredSubscriptions;
      final upcoming = subs
          .where(
            (s) =>
                s.status == SubscriptionStatus.active &&
                s.nextBillingDate.difference(DateTime.now()).inDays <= 30,
          )
          .length;
      final thisMonth = subs
          .where(
            (s) =>
                s.status == SubscriptionStatus.active &&
                s.nextBillingDate.month == DateTime.now().month,
          )
          .fold<double>(0, (sum, s) => sum + s.amount);

      return Padding(
        padding: const EdgeInsets.all(16),
        child: AccentCard(
          accentColor: AppColors.warning,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.event_repeat_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Upcoming Renewals',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$upcoming renewing in the next 30 days',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _SummaryStat(
                      label: 'This Month',
                      value: '₹${thisMonth.toStringAsFixed(0)}',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  Expanded(
                    child: _SummaryStat(
                      label: 'Renewing Soon',
                      value: upcoming.toString(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTabSelector(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate800 : AppColors.slate100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _TabButton(
                label: 'Upcoming',
                isSelected: _selectedTab == 0,
                onTap: () => setState(() => _selectedTab = 0),
              ),
            ),
            Expanded(
              child: _TabButton(
                label: 'Cancelled',
                isSelected: _selectedTab == 1,
                onTap: () => setState(() => _selectedTab = 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingRenewals(BuildContext context) {
    return Obx(() {
      final subs =
          _controller.filteredSubscriptions
              .where((s) => s.status == SubscriptionStatus.active)
              .toList()
            ..sort((a, b) => a.nextBillingDate.compareTo(b.nextBillingDate));

      if (subs.isEmpty) {
        return const ModernEmptyState(
          icon: Icons.event_available_rounded,
          title: 'No upcoming renewals',
          subtitle: 'All your subscriptions are up to date',
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModernSectionHeader(
            title: 'Renewal Schedule',
            subtitle: 'Sorted by next billing date',
          ),
          ModernCard(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: subs.take(5).map((sub) {
                final daysUntil = sub.nextBillingDate
                    .difference(DateTime.now())
                    .inDays;
                final isLast = sub == subs.take(5).last;
                return Column(
                  children: [
                    _RenewalTile(
                      subscription: sub,
                      daysUntil: daysUntil,
                      onCancel: () => _showCancelDialog(context, sub),
                    ),
                    if (!isLast) const ModernDivider(),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCancelledSubscriptions(BuildContext context) {
    return Obx(() {
      final cancelled = _controller.filteredSubscriptions
          .where((s) => s.status == SubscriptionStatus.cancelled)
          .toList();

      if (cancelled.isEmpty) {
        return const ModernEmptyState(
          icon: Icons.cancel_outlined,
          title: 'No cancelled subscriptions',
          subtitle: 'Cancelled subscriptions will appear here',
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModernSectionHeader(title: 'Cancelled'),
          ModernCard(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: cancelled.map((sub) {
                final isLast = sub == cancelled.last;
                return Column(
                  children: [
                    _CancelledTile(
                      subscription: sub,
                      onReactivate: () => _reactivate(sub),
                    ),
                    if (!isLast) const ModernDivider(),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCancellationTips(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(title: 'Tips', subtitle: 'Before you cancel'),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: const [
              _TipItem(
                icon: Icons.pause_circle_outline_rounded,
                title: 'Consider pausing',
                subtitle: 'Some services let you pause instead of cancel',
              ),
              ModernDivider(padding: EdgeInsets.symmetric(vertical: 12)),
              _TipItem(
                icon: Icons.discount_outlined,
                title: 'Check for discounts',
                subtitle: 'Contact support for retention offers',
              ),
              ModernDivider(padding: EdgeInsets.symmetric(vertical: 12)),
              _TipItem(
                icon: Icons.download_outlined,
                title: 'Export your data',
                subtitle: 'Download content before cancelling',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context, SubscriptionModel sub) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Subscription?'),
        content: Text(
          'Are you sure you want to cancel ${sub.name}? You can still use it until ${_formatDate(sub.nextBillingDate)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelSubscription(sub);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _cancelSubscription(SubscriptionModel sub) {
    HapticFeedback.mediumImpact();
    Get.snackbar(
      'Subscription Cancelled',
      '${sub.name} will be cancelled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _reactivate(SubscriptionModel sub) {
    HapticFeedback.mediumImpact();
    Get.snackbar(
      'Reactivate',
      'Would you like to reactivate ${sub.name}?',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.slate700 : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _RenewalTile extends StatelessWidget {
  final SubscriptionModel subscription;
  final int daysUntil;
  final VoidCallback onCancel;

  const _RenewalTile({
    required this.subscription,
    required this.daysUntil,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUrgent = daysUntil <= 3;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (subscription.color ?? AppColors.primary).withValues(
                alpha: 0.15,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                subscription.name.isNotEmpty ? subscription.name[0] : '?',
                style: TextStyle(
                  color: subscription.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '₹${subscription.amount.toStringAsFixed(0)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      ' • ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    Text(
                      daysUntil == 0
                          ? 'Today'
                          : daysUntil == 1
                          ? 'Tomorrow'
                          : 'In $daysUntil days',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isUrgent ? AppColors.error : AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _CancelledTile extends StatelessWidget {
  final SubscriptionModel subscription;
  final VoidCallback onReactivate;

  const _CancelledTile({
    required this.subscription,
    required this.onReactivate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.slate300.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                subscription.name.isNotEmpty ? subscription.name[0] : '?',
                style: TextStyle(
                  color: AppColors.slate500,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.lineThrough,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Cancelled',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onReactivate,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Reactivate'),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TipItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
