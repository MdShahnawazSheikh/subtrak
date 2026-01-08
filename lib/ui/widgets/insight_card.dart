import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/data/models/insight_model.dart';
import 'premium_components.dart';

/// Insight card with actionable design
class InsightCard extends StatelessWidget {
  final InsightModel insight;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;

  const InsightCard({
    super.key,
    required this.insight,
    this.onTap,
    this.onDismiss,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(insight.id),
      direction: onDismiss != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            gradient: _getBackgroundGradient(insight.type),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getAccentColor(insight.type).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getAccentColor(
                          insight.type,
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIcon(insight.type),
                        size: 22,
                        color: _getAccentColor(insight.type),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          PremiumBadge(
                            text: _getTypeLabel(insight.type),
                            color: _getAccentColor(insight.type),
                            small: true,
                          ),
                        ],
                      ),
                    ),
                    if (insight.priority == InsightPriority.critical) ...[
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.priority_high_rounded,
                          size: 18,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  insight.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.8,
                    ),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (insight.potentialSavings != null &&
                    insight.potentialSavings! > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFA6).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.savings_outlined,
                          size: 16,
                          color: Color(0xFF00BFA6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Save ₹${insight.potentialSavings!.toStringAsFixed(0)}/mo',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00BFA6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (insight.actions.isNotEmpty && onAction != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        onAction?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _getAccentColor(insight.type),
                        side: BorderSide(
                          color: _getAccentColor(
                            insight.type,
                          ).withValues(alpha: 0.5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(_getActionLabel(insight.actions.first)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getBackgroundGradient(InsightType type) {
    final color = _getAccentColor(type);
    return LinearGradient(
      colors: [color.withValues(alpha: 0.08), color.withValues(alpha: 0.02)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Color _getAccentColor(InsightType type) {
    switch (type) {
      case InsightType.unusedSubscription:
        return Colors.orange;
      case InsightType.priceIncrease:
        return Colors.red;
      case InsightType.duplicateService:
        return const Color(0xFF7C4DFF);
      case InsightType.trialEnding:
        return Colors.amber;
      case InsightType.budgetWarning:
        return Colors.red;
      case InsightType.regretDetection:
        return Colors.orange;
      case InsightType.costSaving:
        return const Color(0xFF00BFA6);
      case InsightType.spendDrift:
        return const Color(0xFFFF6B35);
      case InsightType.behavioralNudge:
        return const Color(0xFF2196F3);
      case InsightType.annualProjection:
        return const Color(0xFF00BFA6);
      case InsightType.categorySpike:
        return Colors.deepOrange;
      case InsightType.paymentUpcoming:
        return Colors.teal;
      case InsightType.monthlySummary:
        return Colors.blue;
      case InsightType.worthItScore:
        return Colors.purple;
    }
  }

  IconData _getIcon(InsightType type) {
    switch (type) {
      case InsightType.unusedSubscription:
        return Icons.hourglass_empty_rounded;
      case InsightType.priceIncrease:
        return Icons.trending_up_rounded;
      case InsightType.duplicateService:
        return Icons.content_copy_rounded;
      case InsightType.trialEnding:
        return Icons.timer_outlined;
      case InsightType.budgetWarning:
        return Icons.warning_amber_rounded;
      case InsightType.regretDetection:
        return Icons.sentiment_dissatisfied_outlined;
      case InsightType.costSaving:
        return Icons.savings_outlined;
      case InsightType.spendDrift:
        return Icons.show_chart_rounded;
      case InsightType.behavioralNudge:
        return Icons.lightbulb_outline_rounded;
      case InsightType.annualProjection:
        return Icons.calendar_month_outlined;
      case InsightType.categorySpike:
        return Icons.pie_chart_outline_rounded;
      case InsightType.paymentUpcoming:
        return Icons.event_repeat_rounded;
      case InsightType.monthlySummary:
        return Icons.summarize_outlined;
      case InsightType.worthItScore:
        return Icons.star_half_outlined;
    }
  }

  String _getTypeLabel(InsightType type) {
    switch (type) {
      case InsightType.unusedSubscription:
        return 'Unused';
      case InsightType.priceIncrease:
        return 'Price Hike';
      case InsightType.duplicateService:
        return 'Duplicate';
      case InsightType.trialEnding:
        return 'Trial Ending';
      case InsightType.budgetWarning:
        return 'Budget Alert';
      case InsightType.regretDetection:
        return 'Regret Risk';
      case InsightType.costSaving:
        return 'Save Money';
      case InsightType.spendDrift:
        return 'Spend Drift';
      case InsightType.behavioralNudge:
        return 'Tip';
      case InsightType.annualProjection:
        return 'Annual Plan';
      case InsightType.categorySpike:
        return 'Overspend';
      case InsightType.paymentUpcoming:
        return 'Payment Tip';
      case InsightType.monthlySummary:
        return 'Summary';
      case InsightType.worthItScore:
        return 'Worth It?';
    }
  }

  String _getActionLabel(InsightAction action) {
    // Use the label from the action itself, or derive from type
    if (action.label.isNotEmpty) {
      return action.label;
    }

    switch (action.type) {
      case InsightActionType.cancel:
        return 'Cancel Subscription';
      case InsightActionType.pause:
        return 'Pause Subscription';
      case InsightActionType.downgrade:
        return 'Downgrade Plan';
      case InsightActionType.review:
        return 'Review Details';
      case InsightActionType.negotiate:
        return 'Negotiate Price';
      case InsightActionType.remind:
        return 'Set Reminder';
      case InsightActionType.dismiss:
        return 'Dismiss';
      case InsightActionType.viewDetails:
        return 'View Details';
      case InsightActionType.logUsage:
        return 'Log Usage';
    }
  }
}

/// Mini insight badge for dashboard
class MiniInsightBadge extends StatelessWidget {
  final InsightType type;
  final int count;
  final VoidCallback? onTap;

  const MiniInsightBadge({
    super.key,
    required this.type,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor(type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getIcon(type), size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(InsightType type) {
    switch (type) {
      case InsightType.unusedSubscription:
        return Colors.orange;
      case InsightType.priceIncrease:
        return Colors.red;
      case InsightType.duplicateService:
        return const Color(0xFF7C4DFF);
      case InsightType.trialEnding:
        return Colors.amber;
      case InsightType.budgetWarning:
        return Colors.red;
      case InsightType.costSaving:
        return const Color(0xFF00BFA6);
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(InsightType type) {
    switch (type) {
      case InsightType.unusedSubscription:
        return Icons.hourglass_empty_rounded;
      case InsightType.priceIncrease:
        return Icons.trending_up_rounded;
      case InsightType.duplicateService:
        return Icons.content_copy_rounded;
      case InsightType.trialEnding:
        return Icons.timer_outlined;
      case InsightType.budgetWarning:
        return Icons.warning_amber_rounded;
      case InsightType.costSaving:
        return Icons.savings_outlined;
      default:
        return Icons.lightbulb_outline_rounded;
    }
  }
}

/// Insights summary bar for dashboard
class InsightsSummaryBar extends StatelessWidget {
  final List<InsightModel> insights;
  final VoidCallback? onViewAll;

  const InsightsSummaryBar({super.key, required this.insights, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get priority insights
    final criticalCount = insights
        .where((i) => i.priority == InsightPriority.critical)
        .length;
    final highCount = insights
        .where((i) => i.priority == InsightPriority.high)
        .length;

    return GestureDetector(
      onTap: onViewAll,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF7C4DFF).withValues(alpha: 0.1),
              const Color(0xFF00BFA6).withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF7C4DFF).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 22,
                    color: Color(0xFF7C4DFF),
                  ),
                  if (criticalCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${insights.length} Smart Insight${insights.length > 1 ? 's' : ''}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getSummaryText(criticalCount, highCount),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF7C4DFF)),
          ],
        ),
      ),
    );
  }

  String _getSummaryText(int critical, int high) {
    if (critical > 0 && high > 0) {
      return '$critical critical, $high high priority';
    } else if (critical > 0) {
      return '$critical critical action${critical > 1 ? 's' : ''} needed';
    } else if (high > 0) {
      return '$high high priority suggestion${high > 1 ? 's' : ''}';
    }
    return 'Tap to review recommendations';
  }
}
