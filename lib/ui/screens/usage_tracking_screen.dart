import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/data/models/subscription_model.dart';
import '../widgets/modern_ui_components.dart';

/// Usage Tracking Screen - Modern Redesign
class UsageTrackingScreen extends StatefulWidget {
  const UsageTrackingScreen({super.key});

  @override
  State<UsageTrackingScreen> createState() => _UsageTrackingScreenState();
}

class _UsageTrackingScreenState extends State<UsageTrackingScreen> {
  final SubscriptionController _controller = Get.find();
  String _selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildUsageSummary(context)),
          SliverToBoxAdapter(child: _buildPeriodSelector(context)),
          SliverToBoxAdapter(child: _buildUsageBreakdown(context)),
          SliverToBoxAdapter(child: _buildUnderutilized(context)),
          SliverToBoxAdapter(child: _buildUsageTips(context)),
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
        'Usage Tracking',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.tune_rounded),
          onPressed: () => _openSettings(context),
        ),
      ],
    );
  }

  Widget _buildUsageSummary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AccentCard(
        accentColor: AppColors.primary,
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
                    Icons.bar_chart_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Usage',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '72%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.greenAccent,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '+8%',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
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
                  child: _UsageStat(
                    label: 'Active',
                    value: '6',
                    subtext: 'regularly used',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _UsageStat(
                    label: 'Low Usage',
                    value: '2',
                    subtext: 'review needed',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _UsageStat(
                    label: 'Unused',
                    value: '1',
                    subtext: 'consider canceling',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final periods = ['Last 7 Days', 'This Month', 'Last 3 Months'];

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: periods.length,
        itemBuilder: (context, index) {
          final period = periods[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ModernChip(
              label: period,
              selected: period == _selectedPeriod,
              onTap: () => setState(() => _selectedPeriod = period),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUsageBreakdown(BuildContext context) {
    return Obx(() {
      final subs = _controller.filteredSubscriptions
          .where((s) => s.status == SubscriptionStatus.active)
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModernSectionHeader(
            title: 'Subscription Usage',
            subtitle: 'Based on your activity',
          ),
          ModernCard(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _UsageTile(
                  name: 'Netflix',
                  usage: 0.92,
                  sessions: 28,
                  trend: 'up',
                  color: const Color(0xFFE50914),
                ),
                const ModernDivider(),
                _UsageTile(
                  name: 'Spotify',
                  usage: 0.85,
                  sessions: 45,
                  trend: 'up',
                  color: const Color(0xFF1DB954),
                ),
                const ModernDivider(),
                _UsageTile(
                  name: 'YouTube Premium',
                  usage: 0.68,
                  sessions: 22,
                  trend: 'stable',
                  color: const Color(0xFFFF0000),
                ),
                const ModernDivider(),
                _UsageTile(
                  name: 'Adobe CC',
                  usage: 0.45,
                  sessions: 8,
                  trend: 'down',
                  color: const Color(0xFFFF0000),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildUnderutilized(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(
          title: 'Underutilized',
          subtitle: 'Consider reviewing these',
        ),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              _UnderutilizedCard(
                name: 'Medium',
                usage: 15,
                price: 399,
                color: Color(0xFF000000),
              ),
              _UnderutilizedCard(
                name: 'LinkedIn Premium',
                usage: 8,
                price: 1599,
                color: Color(0xFF0A66C2),
              ),
              _UnderutilizedCard(
                name: 'Notion',
                usage: 22,
                price: 0,
                color: Color(0xFF000000),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUsageTips(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(title: 'Usage Tips'),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: const [
              _TipItem(
                icon: Icons.timer_outlined,
                title: 'Set usage reminders',
                subtitle:
                    'Get notified to use subscriptions you\'re paying for',
              ),
              ModernDivider(padding: EdgeInsets.symmetric(vertical: 12)),
              _TipItem(
                icon: Icons.analytics_outlined,
                title: 'Track screen time',
                subtitle: 'Connect with your device\'s screen time data',
              ),
              ModernDivider(padding: EdgeInsets.symmetric(vertical: 12)),
              _TipItem(
                icon: Icons.calendar_month_rounded,
                title: 'Monthly usage review',
                subtitle: 'Review your usage at the end of each month',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openSettings(BuildContext context) {
    HapticFeedback.lightImpact();
  }
}

// Helper widgets
class _UsageStat extends StatelessWidget {
  final String label;
  final String value;
  final String subtext;

  const _UsageStat({
    required this.label,
    required this.value,
    required this.subtext,
  });

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
        Text(
          subtext,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _UsageTile extends StatelessWidget {
  final String name;
  final double usage;
  final int sessions;
  final String trend;
  final Color color;

  const _UsageTile({
    required this.name,
    required this.usage,
    required this.sessions,
    required this.trend,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final usagePercent = (usage * 100).toInt();

    final trendIcon = trend == 'up'
        ? Icons.trending_up_rounded
        : trend == 'down'
        ? Icons.trending_down_rounded
        : Icons.trending_flat_rounded;

    final trendColor = trend == 'up'
        ? AppColors.success
        : trend == 'down'
        ? AppColors.error
        : AppColors.slate400;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(trendIcon, color: trendColor, size: 16),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ModernProgressBar(
                        progress: usage,
                        color: usage > 0.6
                            ? AppColors.success
                            : usage > 0.3
                            ? AppColors.warning
                            : AppColors.error,
                        height: 5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$usagePercent%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UnderutilizedCard extends StatelessWidget {
  final String name;
  final int usage;
  final int price;
  final Color color;

  const _UnderutilizedCard({
    required this.name,
    required this.usage,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$usage%',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            price > 0 ? '₹$price/mo' : 'Free',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
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
