import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/data/models/subscription_model.dart';
import '../widgets/modern_ui_components.dart';

/// Price Alerts Screen - Modern Redesign
class PriceAlertsScreen extends StatefulWidget {
  const PriceAlertsScreen({super.key});

  @override
  State<PriceAlertsScreen> createState() => _PriceAlertsScreenState();
}

class _PriceAlertsScreenState extends State<PriceAlertsScreen> {
  final SubscriptionController _controller = Get.find();
  bool _alertsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildAlertsSummary(context)),
          SliverToBoxAdapter(child: _buildRecentAlerts(context)),
          SliverToBoxAdapter(child: _buildMonitoredSubscriptions(context)),
          SliverToBoxAdapter(child: _buildAlertSettings(context)),
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
        'Price Alerts',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_alert_outlined),
          onPressed: () => _addAlert(context),
        ),
      ],
    );
  }

  Widget _buildAlertsSummary(BuildContext context) {
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
                    Icons.notifications_active_rounded,
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
                        'Price Monitoring',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _alertsEnabled ? 'Active' : 'Paused',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _alertsEnabled,
                  onChanged: (v) => setState(() => _alertsEnabled = v),
                  activeColor: Colors.white,
                  activeTrackColor: Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _AlertStat(label: 'Monitored', value: '8'),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _AlertStat(label: 'Triggered', value: '2'),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _AlertStat(label: 'Saved', value: '₹320'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAlerts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(
          title: 'Recent Alerts',
          subtitle: 'Price changes detected',
        ),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _AlertTile(
                name: 'Netflix',
                type: 'Price Increase',
                change: '+₹50/mo',
                isIncrease: true,
                date: 'Today',
                onTap: () {},
              ),
              const ModernDivider(),
              _AlertTile(
                name: 'Spotify',
                type: 'Discount Available',
                change: '-₹30/mo',
                isIncrease: false,
                date: 'Yesterday',
                onTap: () {},
              ),
              const ModernDivider(),
              _AlertTile(
                name: 'YouTube Premium',
                type: 'Price Increase',
                change: '+₹20/mo',
                isIncrease: true,
                date: '3 days ago',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonitoredSubscriptions(BuildContext context) {
    return Obx(() {
      final subs = _controller.filteredSubscriptions
          .where((s) => s.status == SubscriptionStatus.active)
          .take(4)
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernSectionHeader(
            title: 'Monitored',
            actionText: 'Edit',
            onAction: () => _editMonitored(context),
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: subs.length + 1,
              itemBuilder: (context, index) {
                if (index == subs.length) {
                  return _AddMonitorCard(onTap: () => _addMonitored(context));
                }
                final sub = subs[index];
                return _MonitoredCard(
                  name: sub.name,
                  price: '₹${sub.amount.toStringAsFixed(0)}',
                  color: sub.color ?? AppColors.primary,
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAlertSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(title: 'Alert Settings'),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ToggleTile(
                icon: Icons.trending_up_rounded,
                title: 'Price Increases',
                subtitle: 'Alert when prices go up',
                value: true,
                onChanged: (v) {},
              ),
              const ModernDivider(),
              ToggleTile(
                icon: Icons.trending_down_rounded,
                title: 'Discounts',
                subtitle: 'Alert when deals are available',
                value: true,
                onChanged: (v) {},
              ),
              const ModernDivider(),
              ToggleTile(
                icon: Icons.new_releases_rounded,
                title: 'New Plans',
                subtitle: 'Alert for new subscription tiers',
                value: false,
                onChanged: (v) {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addAlert(BuildContext context) {
    HapticFeedback.mediumImpact();
    Get.snackbar(
      'Add Alert',
      'Set up a new price alert',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _editMonitored(BuildContext context) {
    HapticFeedback.lightImpact();
  }

  void _addMonitored(BuildContext context) {
    HapticFeedback.lightImpact();
    Get.snackbar(
      'Add Subscription',
      'Choose a subscription to monitor',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Helper widgets
class _AlertStat extends StatelessWidget {
  final String label;
  final String value;

  const _AlertStat({required this.label, required this.value});

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
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AlertTile extends StatelessWidget {
  final String name;
  final String type;
  final String change;
  final bool isIncrease;
  final String date;
  final VoidCallback onTap;

  const _AlertTile({
    required this.name,
    required this.type,
    required this.change,
    required this.isIncrease,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isIncrease ? AppColors.error : AppColors.success)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isIncrease
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: isIncrease ? AppColors.error : AppColors.success,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    type,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  change,
                  style: TextStyle(
                    color: isIncrease ? AppColors.error : AppColors.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  date,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MonitoredCard extends StatelessWidget {
  final String name;
  final String price;
  final Color color;

  const _MonitoredCard({
    required this.name,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.slate200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0] : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            name,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            price,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddMonitorCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddMonitorCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate800 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: AppColors.primary, size: 28),
            const SizedBox(height: 4),
            Text(
              'Add',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
