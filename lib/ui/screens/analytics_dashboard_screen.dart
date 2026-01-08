import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../app/controllers/subscription_controller.dart';
import '../../app/data/models/subscription_model.dart';
import '../widgets/modern_ui_components.dart';

/// Analytics Dashboard Screen - Modern Redesign
class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  final SubscriptionController _controller = Get.find();
  String _selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildOverviewCard(context)),
          SliverToBoxAdapter(child: _buildPeriodSelector(context)),
          SliverToBoxAdapter(child: _buildSpendingChart(context)),
          SliverToBoxAdapter(child: _buildCategoryBreakdown(context)),
          SliverToBoxAdapter(child: _buildTrends(context)),
          SliverToBoxAdapter(child: _buildTopSubscriptions(context)),
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
        'Analytics',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.file_download_outlined),
          onPressed: () => _exportAnalytics(),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(BuildContext context) {
    return Obx(() {
      final summary = _controller.summary.value;
      final monthlyTotal = summary.totalMonthly;
      final yearlyTotal = monthlyTotal * 12;
      final activeCount = summary.activeCount;

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
                      Icons.analytics_rounded,
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
                          'Total Spending',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${monthlyTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
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
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: Colors.greenAccent,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '+2.3%',
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
                    child: _OverviewStat(
                      label: 'Monthly',
                      value: '₹${monthlyTotal.toStringAsFixed(0)}',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  Expanded(
                    child: _OverviewStat(
                      label: 'Yearly',
                      value: '₹${yearlyTotal.toStringAsFixed(0)}',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  Expanded(
                    child: _OverviewStat(
                      label: 'Active',
                      value: activeCount.toString(),
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

  Widget _buildPeriodSelector(BuildContext context) {
    final periods = ['This Week', 'This Month', 'This Year', 'All Time'];

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: periods.length,
        itemBuilder: (context, index) {
          final period = periods[index];
          final isSelected = period == _selectedPeriod;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ModernChip(
              label: period,
              selected: isSelected,
              onTap: () => setState(() => _selectedPeriod = period),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpendingChart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(
          title: 'Spending Trend',
          subtitle: 'Last 6 months',
        ),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 180,
                child: CustomPaint(
                  size: const Size(double.infinity, 180),
                  painter: _SpendingChartPainter(
                    isDark: isDark,
                    data: [2500, 2800, 2400, 3100, 2900, 3200],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan']
                    .map(
                      (m) => Text(
                        m,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final byCategory = _controller.spendByCategory;
      if (byCategory.isEmpty) return const SizedBox.shrink();

      final sortedCategories = byCategory.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final totalSpend = sortedCategories.fold<double>(
        0,
        (sum, e) => sum + e.value,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModernSectionHeader(
            title: 'By Category',
            subtitle: 'Where your money goes',
          ),
          ModernCard(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: sortedCategories.take(5).map((entry) {
                final percent = totalSpend > 0
                    ? (entry.value / totalSpend * 100)
                    : 0.0;
                final color = _getCategoryColor(entry.key);
                final isLast = entry == sortedCategories.take(5).last;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _formatCategoryName(entry.key.name),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            '${percent.toStringAsFixed(0)}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '₹${entry.value.toStringAsFixed(0)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast) const Divider(height: 1, indent: 24),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTrends(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(
          title: 'Insights',
          subtitle: 'Key trends in your spending',
        ),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _TrendCard(
                icon: Icons.trending_up,
                iconColor: AppColors.error,
                title: 'Spending Up',
                value: '+₹320',
                subtitle: 'vs last month',
              ),
              _TrendCard(
                icon: Icons.add_circle_outline,
                iconColor: AppColors.primary,
                title: 'New Subs',
                value: '+2',
                subtitle: 'this month',
              ),
              _TrendCard(
                icon: Icons.savings_outlined,
                iconColor: AppColors.success,
                title: 'Saved',
                value: '₹480',
                subtitle: 'by optimizing',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopSubscriptions(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final subs =
          _controller.filteredSubscriptions
              .where((s) => s.status == SubscriptionStatus.active)
              .toList()
            ..sort((a, b) => b.amount.compareTo(a.amount));

      if (subs.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModernSectionHeader(
            title: 'Top Spending',
            subtitle: 'Your most expensive subscriptions',
          ),
          ModernCard(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: subs.take(5).toList().asMap().entries.map((entry) {
                final index = entry.key;
                final sub = entry.value;
                final isLast = index == math.min(4, subs.length - 1);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: (sub.color ?? AppColors.primary)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                sub.name.isNotEmpty ? sub.name[0] : '?',
                                style: TextStyle(
                                  color: sub.color,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
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
                              overflow: TextOverflow.ellipsis,
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
                    if (!isLast) const Divider(height: 1, indent: 52),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

  void _exportAnalytics() {
    HapticFeedback.mediumImpact();
    Get.toNamed('/export');
  }

  String _formatCategoryName(String name) {
    return name
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .trim()
        .split(' ')
        .map(
          (w) => w.isNotEmpty
              ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  Color _getCategoryColor(SubscriptionCategory category) {
    switch (category) {
      case SubscriptionCategory.streaming:
        return const Color(0xFFFF6B6B);
      case SubscriptionCategory.productivity:
        return const Color(0xFF6366F1);
      case SubscriptionCategory.utilities:
        return const Color(0xFF10B981);
      case SubscriptionCategory.fitness:
        return const Color(0xFFF59E0B);
      case SubscriptionCategory.education:
        return const Color(0xFF3B82F6);
      case SubscriptionCategory.shopping:
        return const Color(0xFFEC4899);
      case SubscriptionCategory.finance:
        return const Color(0xFF14B8A6);
      case SubscriptionCategory.social:
        return const Color(0xFF8B5CF6);
      case SubscriptionCategory.news:
        return const Color(0xFF64748B);
      default:
        return const Color(0xFF94A3B8);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _OverviewStat extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewStat({required this.label, required this.value});

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
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const _TrendCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.slate200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingChartPainter extends CustomPainter {
  final bool isDark;
  final List<double> data;

  _SpendingChartPainter({required this.isDark, required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.reduce(math.max);
    final minValue = data.reduce(math.min);
    final range = maxValue - minValue;

    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.3),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedValue = range > 0 ? (data[i] - minValue) / range : 0.5;
      final y =
          size.height -
          (normalizedValue * size.height * 0.8) -
          size.height * 0.1;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw dots
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
