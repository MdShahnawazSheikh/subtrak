import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../app/data/models/subscription_model.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/controllers/settings_controller.dart';
import '../widgets/premium_ui_components.dart';

/// Advanced Analytics Dashboard with enterprise-grade visualizations
class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with TickerProviderStateMixin {
  final SubscriptionController _controller = Get.find();
  final SettingsController _settingsController = Get.find();
  late TabController _tabController;
  late AnimationController _pulseController;

  String _selectedTimeframe = '1Y';
  final List<String> _timeframes = ['1M', '3M', '6M', '1Y', 'ALL'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0F) : Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildHealthScoreCard(context)),
          SliverToBoxAdapter(child: _buildTimeframeSelector(context)),
          SliverToBoxAdapter(child: _buildSpendingTrendChart(context)),
          SliverToBoxAdapter(child: _buildCategoryBreakdownPie(context)),
          SliverToBoxAdapter(child: _buildPredictionsCard(context)),
          SliverToBoxAdapter(child: _buildTopSpendingSubscriptions(context)),
          SliverToBoxAdapter(child: _buildROIAnalysis(context)),
          SliverToBoxAdapter(child: _buildBudgetProgressCard(context)),
          SliverToBoxAdapter(child: _buildYearlyProjection(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Analytics Dashboard',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7C4DFF).withOpacity(0.3),
                const Color(0xFF00BFA6).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () => _exportReport(context),
        ),
        IconButton(
          icon: const Icon(Icons.refresh_outlined),
          onPressed: () {
            HapticFeedback.lightImpact();
            _controller.refresh();
          },
        ),
      ],
    );
  }

  Widget _buildHealthScoreCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final healthScore = _calculateHealthScore();
      final healthColor = _getHealthColor(healthScore);

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              healthColor.withOpacity(0.2),
              healthColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: healthColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: healthColor.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: healthColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: healthColor.withOpacity(
                                        0.5 + _pulseController.value * 0.5,
                                      ),
                                      blurRadius:
                                          8 + _pulseController.value * 4,
                                      spreadRadius: _pulseController.value * 2,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Subscription Health Score',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getHealthLabel(healthScore),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildHealthScoreGauge(healthScore, healthColor),
              ],
            ),
            const SizedBox(height: 20),
            _buildHealthMetrics(context),
          ],
        ),
      );
    });
  }

  Widget _buildHealthScoreGauge(int score, Color color) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(100, 100),
            painter: _GaugePainter(score: score / 100, color: color),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  '/100',
                  style: TextStyle(fontSize: 12, color: color.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetrics(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final summary = _controller.summary.value;
      final stats = _controller.subscriptionStats;

      return Row(
        children: [
          _buildMetricItem(
            context,
            icon: Icons.trending_up,
            label: 'Monthly',
            value: '₹${summary.totalMonthly.toStringAsFixed(0)}',
            color: const Color(0xFF00BFA6),
          ),
          _buildMetricItem(
            context,
            icon: Icons.subscriptions,
            label: 'Active',
            value: '${stats['active'] ?? 0}',
            color: const Color(0xFF7C4DFF),
          ),
          _buildMetricItem(
            context,
            icon: Icons.savings,
            label: 'Savings',
            value: '₹${summary.potentialSavings.toStringAsFixed(0)}',
            color: const Color(0xFFFF6B6B),
          ),
          _buildMetricItem(
            context,
            icon: Icons.trending_down,
            label: 'Waste',
            value: '${_calculateWastePercentage().toStringAsFixed(0)}%',
            color: Colors.orange,
          ),
        ],
      );
    });
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: _timeframes.map((tf) {
          final isSelected = tf == _selectedTimeframe;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedTimeframe = tf);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    tf,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpendingTrendChart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spending Trend',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BFA6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 14,
                      color: Color(0xFF00BFA6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+12.5%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00BFA6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: _SpendingChartPainter(
                data: _generateSpendingData(),
                lineColor: const Color(0xFF7C4DFF),
                fillGradient: [
                  const Color(0xFF7C4DFF).withOpacity(0.3),
                  const Color(0xFF7C4DFF).withOpacity(0.0),
                ],
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _getChartLabels().map((label) {
              return Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdownPie(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final categorySpend = _controller.spendByCategory;
      if (categorySpend.isEmpty) return const SizedBox.shrink();

      final total = categorySpend.values.fold<double>(0, (a, b) => a + b);
      final sortedCategories = categorySpend.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CustomPaint(
                    painter: _PieChartPainter(
                      data: sortedCategories
                          .take(6)
                          .map((e) => e.value / total)
                          .toList(),
                      colors: _getCategoryColors(
                        sortedCategories.take(6).map((e) => e.key).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sortedCategories.take(5).map((entry) {
                      final percentage = (entry.value / total * 100);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _getCategoryColor(entry.key),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.key.name.capitalizeFirst ?? '',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPredictionsCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Predictions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Based on your spending patterns',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPredictionItem(
            icon: Icons.calendar_month,
            title: 'Next Month Estimate',
            value: '₹${_calculateNextMonthEstimate().toStringAsFixed(0)}',
            change: '+5.2%',
            isPositive: false,
          ),
          const SizedBox(height: 12),
          _buildPredictionItem(
            icon: Icons.trending_up,
            title: 'Yearly Projection',
            value: '₹${_calculateYearlyProjection().toStringAsFixed(0)}',
            change: 'Based on current trend',
            isPositive: true,
          ),
          const SizedBox(height: 12),
          _buildPredictionItem(
            icon: Icons.lightbulb,
            title: 'Potential Savings',
            value: '₹${_calculatePotentialSavings().toStringAsFixed(0)}/mo',
            change: 'If you optimize',
            isPositive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionItem({
    required IconData icon,
    required String title,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: isPositive ? const Color(0xFF00FF88) : Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSpendingSubscriptions(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final subs =
          _controller.subscriptions
              .where((s) => s.status == SubscriptionStatus.active)
              .toList()
            ..sort(
              (a, b) => b.monthlyEquivalent.compareTo(a.monthlyEquivalent),
            );

      if (subs.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Spending',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Monthly',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...subs.take(5).toList().asMap().entries.map((entry) {
              final index = entry.key;
              final sub = entry.value;
              final totalSpend = subs.fold<double>(
                0,
                (a, b) => a + b.monthlyEquivalent,
              );
              final percentage = (sub.monthlyEquivalent / totalSpend * 100);

              return _buildTopSpendingItem(
                context,
                rank: index + 1,
                name: sub.name,
                amount: sub.monthlyEquivalent,
                percentage: percentage,
                color: sub.color ?? theme.colorScheme.primary,
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildTopSpendingItem(
    BuildContext context, {
    required int rank,
    required String name,
    required double amount,
    required double percentage,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildROIAnalysis(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'ROI Analysis',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildROIItem(
            context,
            label: 'Cost per Day',
            value: '₹${_calculateCostPerDay().toStringAsFixed(1)}',
            icon: Icons.today,
          ),
          const Divider(height: 24),
          _buildROIItem(
            context,
            label: 'Cost per Service',
            value: '₹${_calculateCostPerService().toStringAsFixed(0)}/avg',
            icon: Icons.apps,
          ),
          const Divider(height: 24),
          _buildROIItem(
            context,
            label: 'Lifetime Value',
            value: '₹${_calculateLifetimeValue().toStringAsFixed(0)}',
            icon: Icons.all_inclusive,
          ),
        ],
      ),
    );
  }

  Widget _buildROIItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.hintColor),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetProgressCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final budgetLimit =
          _settingsController.settings.value?.budget.monthlyLimit ?? 0;
      final currentSpend = _controller.summary.value.totalMonthly;
      final progress = budgetLimit > 0
          ? (currentSpend / budgetLimit).clamp(0.0, 1.5)
          : 0.0;
      final isOverBudget = currentSpend > budgetLimit && budgetLimit > 0;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isOverBudget
              ? Border.all(color: Colors.red.withOpacity(0.5), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isOverBudget)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, size: 14, color: Colors.red),
                        SizedBox(width: 4),
                        Text(
                          'Over Budget',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${currentSpend.toStringAsFixed(0)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isOverBudget ? Colors.red : null,
                  ),
                ),
                Text(
                  budgetLimit > 0
                      ? 'of ₹${budgetLimit.toStringAsFixed(0)}'
                      : 'No budget set',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation(
                  isOverBudget ? Colors.red : const Color(0xFF00BFA6),
                ),
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              budgetLimit > 0
                  ? '${(progress * 100).toStringAsFixed(1)}% of monthly budget used'
                  : 'Set a budget to track your spending',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildYearlyProjection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final monthlySpend = _controller.summary.value.totalMonthly;
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
      final currentMonth = DateTime.now().month - 1;

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yearly Projection',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Estimated annual spend: ₹${(monthlySpend * 12).toStringAsFixed(0)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(12, (index) {
                  final isPast = index <= currentMonth;
                  final isCurrentMonth = index == currentMonth;
                  final height = isPast
                      ? 0.6 + (index / 12) * 0.4
                      : 0.3 + math.Random(index).nextDouble() * 0.3;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300 + index * 50),
                            height: 80 * height,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isPast
                                    ? [
                                        const Color(0xFF7C4DFF),
                                        const Color(0xFF00BFA6),
                                      ]
                                    : [
                                        Colors.grey.withOpacity(0.3),
                                        Colors.grey.withOpacity(0.2),
                                      ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                              border: isCurrentMonth
                                  ? Border.all(
                                      color: const Color(0xFF00BFA6),
                                      width: 2,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            months[index].substring(0, 1),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 9,
                              color: isCurrentMonth
                                  ? theme.colorScheme.primary
                                  : theme.hintColor,
                              fontWeight: isCurrentMonth
                                  ? FontWeight.w700
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper methods
  int _calculateHealthScore() {
    final subs = _controller.subscriptions;
    if (subs.isEmpty) return 100;

    int score = 100;

    // Deduct for unused subscriptions (based on usage if available)
    final unusedCount = subs
        .where(
          (s) => s.usageLogs.isEmpty && s.status == SubscriptionStatus.active,
        )
        .length;
    score -= (unusedCount * 5).clamp(0, 30);

    // Deduct for over budget
    final budgetLimit =
        _settingsController.settings.value?.budget.monthlyLimit ?? 0;
    final currentSpend = _controller.summary.value.totalMonthly;
    if (budgetLimit > 0 && currentSpend > budgetLimit) {
      final overBudgetPercent =
          ((currentSpend - budgetLimit) / budgetLimit * 100);
      score -= overBudgetPercent.toInt().clamp(0, 25);
    }

    // Deduct for payment failures
    final failedPayments = subs
        .where((s) => s.status == SubscriptionStatus.paymentFailed)
        .length;
    score -= (failedPayments * 10).clamp(0, 20);

    // Deduct for trials ending soon
    final expiringTrials = subs.where((s) => s.isTrialEndingSoon).length;
    score -= (expiringTrials * 3).clamp(0, 15);

    return score.clamp(0, 100);
  }

  Color _getHealthColor(int score) {
    if (score >= 80) return const Color(0xFF00BFA6);
    if (score >= 60) return const Color(0xFFFFB74D);
    if (score >= 40) return const Color(0xFFFF8A65);
    return const Color(0xFFE57373);
  }

  String _getHealthLabel(int score) {
    if (score >= 80) return 'Excellent! Your subscriptions are well managed.';
    if (score >= 60) return 'Good, but there\'s room for improvement.';
    if (score >= 40) return 'Needs attention. Review your subscriptions.';
    return 'Critical! Immediate action recommended.';
  }

  double _calculateWastePercentage() {
    final subs = _controller.subscriptions;
    if (subs.isEmpty) return 0;

    final unusedCount = subs
        .where(
          (s) => s.usageLogs.isEmpty && s.status == SubscriptionStatus.active,
        )
        .length;
    return (unusedCount / subs.length * 100);
  }

  List<double> _generateSpendingData() {
    // Generate sample data based on timeframe
    final points = switch (_selectedTimeframe) {
      '1M' => 30,
      '3M' => 12,
      '6M' => 24,
      '1Y' => 12,
      _ => 24,
    };

    final baseAmount = _controller.summary.value.totalMonthly;
    return List.generate(points, (i) {
      final variance = (math.Random(i).nextDouble() - 0.5) * 0.3;
      return baseAmount * (1 + variance) * (0.8 + i / points * 0.2);
    });
  }

  List<String> _getChartLabels() {
    return switch (_selectedTimeframe) {
      '1M' => ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
      '3M' => ['Month 1', 'Month 2', 'Month 3'],
      '6M' => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
      '1Y' => ['Q1', 'Q2', 'Q3', 'Q4'],
      _ => ['2024', '2025', '2026'],
    };
  }

  List<Color> _getCategoryColors(List<SubscriptionCategory> categories) {
    final colors = [
      const Color(0xFF7C4DFF),
      const Color(0xFF00BFA6),
      const Color(0xFFFF6B6B),
      const Color(0xFFFFB74D),
      const Color(0xFF4FC3F7),
      const Color(0xFF81C784),
    ];
    return categories
        .asMap()
        .entries
        .map((e) => colors[e.key % colors.length])
        .toList();
  }

  Color _getCategoryColor(SubscriptionCategory category) {
    final colorMap = {
      SubscriptionCategory.streaming: const Color(0xFFE50914),
      SubscriptionCategory.music: const Color(0xFF1DB954),
      SubscriptionCategory.gaming: const Color(0xFF107C10),
      SubscriptionCategory.productivity: const Color(0xFF0078D4),
      SubscriptionCategory.cloud: const Color(0xFF4285F4),
      SubscriptionCategory.fitness: const Color(0xFFFF3F6C),
      SubscriptionCategory.news: const Color(0xFF000000),
      SubscriptionCategory.education: const Color(0xFF0056D2),
      SubscriptionCategory.finance: const Color(0xFF00C853),
      SubscriptionCategory.utilities: const Color(0xFF607D8B),
      SubscriptionCategory.shopping: const Color(0xFFFF9800),
      SubscriptionCategory.social: const Color(0xFF1DA1F2),
      SubscriptionCategory.food: const Color(0xFFFC8019),
      SubscriptionCategory.travel: const Color(0xFF00BCD4),
      SubscriptionCategory.insurance: const Color(0xFF4CAF50),
      SubscriptionCategory.telecom: const Color(0xFFE40000),
      SubscriptionCategory.software: const Color(0xFF333333),
      SubscriptionCategory.other: const Color(0xFF9E9E9E),
    };
    return colorMap[category] ?? const Color(0xFF7C4DFF);
  }

  double _calculateNextMonthEstimate() {
    final current = _controller.summary.value.totalMonthly;
    return current * 1.05; // 5% growth estimate
  }

  double _calculateYearlyProjection() {
    return _controller.summary.value.totalMonthly * 12;
  }

  double _calculatePotentialSavings() {
    return _controller.summary.value.potentialSavings;
  }

  double _calculateCostPerDay() {
    return _controller.summary.value.totalMonthly / 30;
  }

  double _calculateCostPerService() {
    final count = _controller.subscriptionStats['active'] ?? 1;
    if (count == 0) return 0;
    return _controller.summary.value.totalMonthly / count;
  }

  double _calculateLifetimeValue() {
    // Estimate based on average subscription age
    return _controller.summary.value.totalYearly * 3; // 3 year estimate
  }

  void _exportReport(BuildContext context) {
    // TODO: Implement PDF export
    Get.snackbar(
      'Export Report',
      'Report export coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Custom painters
class _GaugePainter extends CustomPainter {
  final double score;
  final Color color;

  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Background arc
    final bgPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5,
      false,
      bgPaint,
    );

    // Progress arc
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [color.withOpacity(0.5), color],
        startAngle: -math.pi * 0.75,
        endAngle: math.pi * 0.75,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5 * score,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SpendingChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final List<Color> fillGradient;
  final bool isDark;

  _SpendingChartPainter({
    required this.data,
    required this.lineColor,
    required this.fillGradient,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.reduce(math.max);
    final minValue = data.reduce(math.min);
    final range = maxValue - minValue;

    final points = <Offset>[];
    for (var i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y =
          size.height -
          ((data[i] - minValue) / range * size.height * 0.8) -
          size.height * 0.1;
      points.add(Offset(x, y));
    }

    // Draw fill
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    for (final point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: fillGradient,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      linePath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(linePath, linePaint);

    // Draw dots
    final dotPaint = Paint()..color = lineColor;
    final dotOutlinePaint = Paint()
      ..color = isDark ? const Color(0xFF1F2937) : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (
      var i = 0;
      i < points.length;
      i += (points.length ~/ 5).clamp(1, points.length)
    ) {
      canvas.drawCircle(points[i], 5, dotPaint);
      canvas.drawCircle(points[i], 5, dotOutlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PieChartPainter extends CustomPainter {
  final List<double> data;
  final List<Color> colors;

  _PieChartPainter({required this.data, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    var startAngle = -math.pi / 2;
    for (var i = 0; i < data.length; i++) {
      final sweepAngle = data[i] * math.pi * 2;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center hole
    final holePaint = Paint()..color = const Color(0xFF1F2937);
    canvas.drawCircle(center, radius * 0.6, holePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
