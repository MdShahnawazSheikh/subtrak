import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'premium_components.dart';

/// Premium spend summary card for dashboard
class SpendSummaryCard extends StatelessWidget {
  final double totalMonthly;
  final double totalYearly;
  final double? budgetLimit;
  final double? previousMonthTotal;
  final String currency;
  final VoidCallback? onTap;

  const SpendSummaryCard({
    super.key,
    required this.totalMonthly,
    required this.totalYearly,
    this.budgetLimit,
    this.previousMonthTotal,
    this.currency = '₹',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate budget percentage if limit set
    final budgetPercent = budgetLimit != null && budgetLimit! > 0
        ? (totalMonthly / budgetLimit!) * 100
        : null;

    // Calculate month-over-month change
    final monthChange = previousMonthTotal != null && previousMonthTotal! > 0
        ? ((totalMonthly - previousMonthTotal!) / previousMonthTotal!) * 100
        : null;

    return GradientCard(
      colors: const [Color(0xFF1A1A2E), Color(0xFF16213E)],
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Spend',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (monthChange != null)
                _buildChangeIndicator(monthChange, theme),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedAmount(
                amount: totalMonthly,
                prefix: currency,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Yearly',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    '$currency${totalYearly.toStringAsFixed(0)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (budgetLimit != null && budgetPercent != null) ...[
            const SizedBox(height: 20),
            _buildBudgetProgress(budgetPercent, budgetLimit!, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildChangeIndicator(double change, ThemeData theme) {
    final isPositive = change >= 0;
    final color = isPositive ? Colors.red[300] : const Color(0xFF00BFA6);
    final icon = isPositive
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color!.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '${change.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetProgress(double percent, double limit, ThemeData theme) {
    final isOver = percent > 100;
    final displayPercent = percent.clamp(0, 100);
    final barColor = isOver
        ? Colors.red
        : percent > 80
        ? Colors.orange
        : const Color(0xFF00BFA6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Budget',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
            ),
            Text(
              '${percent.toStringAsFixed(0)}% of $currency${limit.toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isOver ? Colors.red[300] : Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              height: 6,
              width: (displayPercent / 100) * (Get.width - 80),
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: barColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isOver) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 14,
                color: Colors.red[300],
              ),
              const SizedBox(width: 4),
              Text(
                'Over budget by $currency${(totalMonthly - limit).toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[300],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Category breakdown widget
class CategoryBreakdown extends StatelessWidget {
  final Map<String, double> categorySpend;
  final String currency;
  final VoidCallback? onTap;

  const CategoryBreakdown({
    super.key,
    required this.categorySpend,
    this.currency = '₹',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (categorySpend.isEmpty) return const SizedBox.shrink();

    // Sort by spend descending
    final sorted = categorySpend.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = sorted.fold<double>(0, (sum, e) => sum + e.value);
    final topCategories = sorted.take(4).toList();

    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'By Category',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...topCategories.map((entry) {
            final percent = (entry.value / total) * 100;
            return _buildCategoryRow(
              context,
              entry.key,
              entry.value,
              percent,
              _getCategoryColor(entry.key),
            );
          }),
          if (sorted.length > 4) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                '+${sorted.length - 4} more categories',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    String name,
    double amount,
    double percent,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    name.capitalizeFirst ?? name,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              Text(
                '$currency${amount.toStringAsFixed(0)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent / 100,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'streaming':
        return const Color(0xFFE50914);
      case 'music':
        return const Color(0xFF1DB954);
      case 'gaming':
        return const Color(0xFF107C10);
      case 'productivity':
        return const Color(0xFF0078D4);
      case 'cloud':
        return const Color(0xFF00A4EF);
      case 'fitness':
        return const Color(0xFFFF6B6B);
      case 'news':
        return const Color(0xFF333333);
      case 'education':
        return const Color(0xFF9B59B6);
      case 'food':
        return const Color(0xFFFF6B35);
      case 'finance':
        return const Color(0xFF2E7D32);
      case 'utilities':
        return const Color(0xFF795548);
      case 'telecom':
        return const Color(0xFF00BCD4);
      case 'software':
        return const Color(0xFF607D8B);
      default:
        return const Color(0xFF7C4DFF);
    }
  }
}

/// Upcoming bills preview
class UpcomingBillsPreview extends StatelessWidget {
  final List<UpcomingBillItem> items;
  final String currency;
  final VoidCallback? onViewAll;

  const UpcomingBillsPreview({
    super.key,
    required this.items,
    this.currency = '₹',
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (items.isEmpty) return const SizedBox.shrink();

    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onViewAll != null)
                TextButton(onPressed: onViewAll, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 12),
          ...items.take(3).map((item) => _buildBillRow(context, item)),
        ],
      ),
    );
  }

  Widget _buildBillRow(BuildContext context, UpcomingBillItem item) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                item.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: item.color,
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
                  item.name,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.dueText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: item.isUrgent
                        ? Colors.orange
                        : theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    fontWeight: item.isUrgent ? FontWeight.w500 : null,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$currency${item.amount.toStringAsFixed(0)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Upcoming bill item model
class UpcomingBillItem {
  final String id;
  final String name;
  final double amount;
  final String dueText;
  final Color color;
  final bool isUrgent;

  const UpcomingBillItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueText,
    required this.color,
    this.isUrgent = false,
  });
}

/// Quick stats row
class QuickStatsRow extends StatelessWidget {
  final int activeCount;
  final int pausedCount;
  final int trialsCount;
  final VoidCallback? onActiveTap;
  final VoidCallback? onPausedTap;
  final VoidCallback? onTrialsTap;

  const QuickStatsRow({
    super.key,
    required this.activeCount,
    required this.pausedCount,
    required this.trialsCount,
    this.onActiveTap,
    this.onPausedTap,
    this.onTrialsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              label: 'Active',
              count: activeCount,
              color: const Color(0xFF00BFA6),
              icon: Icons.check_circle_outline,
              onTap: onActiveTap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              label: 'Paused',
              count: pausedCount,
              color: Colors.orange,
              icon: Icons.pause_circle_outline,
              onTap: onPausedTap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              label: 'Trials',
              count: trialsCount,
              color: const Color(0xFF7C4DFF),
              icon: Icons.access_time,
              onTap: onTrialsTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required int count,
    required Color color,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.grey.withOpacity(0.15),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
