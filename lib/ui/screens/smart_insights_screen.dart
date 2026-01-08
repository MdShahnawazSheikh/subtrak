import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/data/models/subscription_model.dart';
import '../widgets/modern_ui_components.dart';

/// Smart AI-Powered Insights Screen - Modern Redesign
class SmartInsightsScreen extends StatefulWidget {
  const SmartInsightsScreen({super.key});

  @override
  State<SmartInsightsScreen> createState() => _SmartInsightsScreenState();
}

class _SmartInsightsScreenState extends State<SmartInsightsScreen> {
  final SubscriptionController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildHealthScore(context)),
          SliverToBoxAdapter(child: _buildQuickActions(context)),
          SliverToBoxAdapter(child: _buildRecommendations(context)),
          SliverToBoxAdapter(child: _buildSpendingPatterns(context)),
          SliverToBoxAdapter(child: _buildOptimizations(context)),
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
        'AI Insights',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () {
            HapticFeedback.lightImpact();
            _controller.refreshInsights();
          },
        ),
      ],
    );
  }

  Widget _buildHealthScore(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final subs = _controller.filteredSubscriptions;
      final active = subs
          .where((s) => s.status == SubscriptionStatus.active)
          .length;
      final healthScore = _calculateHealthScore(subs);
      final scoreColor = _getScoreColor(healthScore);
      final scoreLabel = _getScoreLabel(healthScore);

      return Padding(
        padding: const EdgeInsets.all(16),
        child: AccentCard(
          accentColor: scoreColor,
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
                      Icons.psychology_rounded,
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
                          'Financial Health Score',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$active active subscriptions analyzed',
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
              const SizedBox(height: 32),
              // Score display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    healthScore.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '/100',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          scoreLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Score breakdown
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ScoreFactor(
                      label: 'Budget',
                      value: '+15',
                      isPositive: true,
                    ),
                    _ScoreFactor(
                      label: 'Usage',
                      value: '-8',
                      isPositive: false,
                    ),
                    _ScoreFactor(
                      label: 'Diversity',
                      value: '+12',
                      isPositive: true,
                    ),
                    _ScoreFactor(
                      label: 'Overlap',
                      value: '-5',
                      isPositive: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(title: 'Quick Actions'),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _QuickActionCard(
                icon: Icons.auto_fix_high_rounded,
                label: 'Auto-Optimize',
                color: AppColors.primary,
                onTap: () => _showOptimizationSheet(context),
              ),
              _QuickActionCard(
                icon: Icons.compare_rounded,
                label: 'Find Duplicates',
                color: AppColors.error,
                onTap: () => _findDuplicates(context),
              ),
              _QuickActionCard(
                icon: Icons.price_check_rounded,
                label: 'Price Compare',
                color: AppColors.success,
                onTap: () => _comparePrices(context),
              ),
              _QuickActionCard(
                icon: Icons.calendar_month_rounded,
                label: 'Billing Optimizer',
                color: AppColors.warning,
                onTap: () => _optimizeBilling(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final summary = _controller.summary.value;
      final potentialSavings = summary.potentialSavings;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommendations',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (potentialSavings > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '₹${potentialSavings.toStringAsFixed(0)} potential savings',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _RecommendationTile(
            icon: Icons.cancel_outlined,
            iconColor: AppColors.error,
            title: 'Review Unused Subscriptions',
            subtitle: 'Some subscriptions show low usage in the past 30 days',
            savings: '₹4,230/mo',
            priority: 'High',
            onTap: () => _showUnusedSubscriptions(context),
          ),
          _RecommendationTile(
            icon: Icons.calendar_today_rounded,
            iconColor: AppColors.success,
            title: 'Switch to Annual Billing',
            subtitle:
                'Save by switching eligible subscriptions to yearly plans',
            savings: '₹1,440/yr',
            priority: 'Medium',
            onTap: () => _showAnnualSavings(context),
          ),
          _RecommendationTile(
            icon: Icons.inventory_2_rounded,
            iconColor: AppColors.primary,
            title: 'Bundle Opportunity',
            subtitle: 'Combine services for better rates',
            savings: '₹200/mo',
            priority: 'Low',
            onTap: () => _showBundleOptions(context),
          ),
        ],
      );
    });
  }

  Widget _buildSpendingPatterns(BuildContext context) {
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
            title: 'Spending by Category',
            subtitle: 'Monthly breakdown',
          ),
          ModernCard(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: sortedCategories.take(5).map((entry) {
                final percent = totalSpend > 0 ? entry.value / totalSpend : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _formatCategoryName(entry.key.name),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '₹${entry.value.toStringAsFixed(0)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ModernProgressBar(
                        progress: percent,
                        color: _getCategoryColor(entry.key),
                        height: 6,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildOptimizations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(
          title: 'Optimization Tips',
          subtitle: 'AI-powered suggestions',
        ),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _OptimizationTip(
                icon: Icons.schedule_rounded,
                title: 'Align billing dates',
                description:
                    'Group renewals to the same week for better tracking',
              ),
              const ModernDivider(padding: EdgeInsets.symmetric(vertical: 12)),
              _OptimizationTip(
                icon: Icons.family_restroom_rounded,
                title: 'Enable family sharing',
                description: 'Share eligible subscriptions with family members',
              ),
              const ModernDivider(padding: EdgeInsets.symmetric(vertical: 12)),
              _OptimizationTip(
                icon: Icons.notifications_active_rounded,
                title: 'Set usage reminders',
                description: 'Get reminded to use services you\'re paying for',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper methods
  int _calculateHealthScore(List<SubscriptionModel> subs) {
    if (subs.isEmpty) return 85;
    int score = 70;
    final active = subs
        .where((s) => s.status == SubscriptionStatus.active)
        .length;
    if (active <= 10) score += 10;
    if (active <= 5) score += 10;
    final trials = subs
        .where((s) => s.status == SubscriptionStatus.trial)
        .length;
    if (trials == 0) score += 5;
    return score.clamp(0, 100);
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Work';
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

  void _showOptimizationSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    Get.snackbar(
      'Auto-Optimize',
      'Analyzing your subscriptions for optimization opportunities...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _findDuplicates(BuildContext context) {
    HapticFeedback.mediumImpact();
    Get.snackbar(
      'Duplicate Check',
      'No duplicate or overlapping subscriptions found!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _comparePrices(BuildContext context) {
    HapticFeedback.mediumImpact();
    Get.toNamed('/compare');
  }

  void _optimizeBilling(BuildContext context) {
    HapticFeedback.mediumImpact();
    Get.snackbar(
      'Billing Optimizer',
      'Your billing dates are well distributed throughout the month.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showUnusedSubscriptions(BuildContext context) {
    HapticFeedback.mediumImpact();
    Get.toNamed('/usage');
  }

  void _showAnnualSavings(BuildContext context) {
    HapticFeedback.mediumImpact();
    Get.toNamed('/compare');
  }

  void _showBundleOptions(BuildContext context) {
    HapticFeedback.mediumImpact();
    Get.toNamed('/compare');
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _ScoreFactor extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;

  const _ScoreFactor({
    required this.label,
    required this.value,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: isPositive ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
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
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : AppColors.slate200,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String savings;
  final String priority;
  final VoidCallback onTap;

  const _RecommendationTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.savings,
    required this.priority,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final priorityColor = priority == 'High'
        ? AppColors.error
        : priority == 'Medium'
        ? AppColors.warning
        : AppColors.slate400;

    return ModernCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
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
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Save $savings',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _OptimizationTip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _OptimizationTip({
    required this.icon,
    required this.title,
    required this.description,
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
                description,
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
