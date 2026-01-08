import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/data/models/insight_model.dart';
import '../../app/controllers/subscription_controller.dart';
import '../widgets/insight_card.dart';

/// Categories for filtering insights
enum InsightCategory { savings, alerts }

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen>
    with SingleTickerProviderStateMixin {
  final SubscriptionController _controller = Get.find();
  late TabController _tabController;
  InsightType? _filterType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Insights'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Savings'),
            Tab(text: 'Alerts'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              HapticFeedback.lightImpact();
              _controller.refreshInsights();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInsightsList(context, null),
          _buildInsightsList(context, InsightCategory.savings),
          _buildInsightsList(context, InsightCategory.alerts),
        ],
      ),
    );
  }

  Widget _buildInsightsList(BuildContext context, InsightCategory? category) {
    return Obx(() {
      var insights = _controller.insights.toList();

      // Filter by category
      if (category != null) {
        insights = insights.where((i) {
          switch (category) {
            case InsightCategory.savings:
              return [
                InsightType.costSaving,
                InsightType.annualProjection,
                InsightType.unusedSubscription,
                InsightType.duplicateService,
              ].contains(i.type);
            case InsightCategory.alerts:
              return [
                InsightType.priceIncrease,
                InsightType.trialEnding,
                InsightType.budgetWarning,
                InsightType.paymentUpcoming,
                InsightType.regretDetection,
              ].contains(i.type);
          }
        }).toList();
      }

      // Filter by type if selected
      if (_filterType != null) {
        insights = insights.where((i) => i.type == _filterType).toList();
      }

      // Sort by priority
      insights.sort((a, b) {
        final priorityOrder = {
          InsightPriority.critical: 0,
          InsightPriority.high: 1,
          InsightPriority.medium: 2,
          InsightPriority.low: 3,
        };
        return (priorityOrder[a.priority] ?? 3).compareTo(
          priorityOrder[b.priority] ?? 3,
        );
      });

      if (insights.isEmpty) {
        return _buildEmptyState(context, category);
      }

      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Summary header
          SliverToBoxAdapter(child: _buildSummaryHeader(context, insights)),
          // Filter chips
          SliverToBoxAdapter(child: _buildFilterChips(context, insights)),
          // Insights list
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final insight = insights[index];
              return InsightCard(
                insight: insight,
                onTap: () => _showInsightDetail(context, insight),
                onDismiss: () => _dismissInsight(insight),
                onAction: insight.actions.isNotEmpty
                    ? () => _executeAction(insight)
                    : null,
              );
            }, childCount: insights.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      );
    });
  }

  Widget _buildEmptyState(BuildContext context, InsightCategory? category) {
    String title;
    String subtitle;

    switch (category) {
      case InsightCategory.savings:
        title = 'No Savings Insights';
        subtitle = 'We\'ll find opportunities to save you money.';
        break;
      case InsightCategory.alerts:
        title = 'No Alerts';
        subtitle = 'All your subscriptions are in good shape!';
        break;
      case null:
        title = 'No Insights Yet';
        subtitle = 'Add some subscriptions to get personalized insights.';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(
    BuildContext context,
    List<InsightModel> insights,
  ) {
    final theme = Theme.of(context);

    final totalSavings = insights.fold<double>(
      0,
      (sum, i) => sum + (i.potentialSavings ?? 0),
    );

    final criticalCount = insights
        .where((i) => i.priority == InsightPriority.critical)
        .length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C4DFF).withValues(alpha: 0.1),
            const Color(0xFF00BFA6).withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Potential Savings',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${totalSavings.toStringAsFixed(0)}/mo',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00BFA6),
                  ),
                ),
              ],
            ),
          ),
          if (criticalCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$criticalCount Critical',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, List<InsightModel> insights) {
    final types = insights.map((i) => i.type).toSet().toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _filterType == null,
            onSelected: (_) => setState(() => _filterType = null),
          ),
          const SizedBox(width: 8),
          ...types.map(
            (type) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_getTypeLabel(type)),
                selected: _filterType == type,
                onSelected: (_) => setState(() => _filterType = type),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInsightDetail(BuildContext context, InsightModel insight) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.hintColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Priority badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getPriorityColor(
                    insight.priority,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  insight.priority.name.toUpperCase(),
                  style: TextStyle(
                    color: _getPriorityColor(insight.priority),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                insight.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              // Description
              Text(
                insight.description,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              if (insight.potentialSavings != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFA6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.savings_outlined,
                        color: Color(0xFF00BFA6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Potential Savings',
                              style: TextStyle(
                                color: Color(0xFF00BFA6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '₹${insight.potentialSavings!.toStringAsFixed(0)}/month',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF00BFA6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              // Action buttons
              if (insight.actions.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Get.back();
                      _executeAction(insight);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_getActionLabel(insight.actions.first.type)),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                    _dismissInsight(insight);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Dismiss'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _dismissInsight(InsightModel insight) {
    _controller.dismissInsight(insight.id);
    Get.snackbar(
      'Dismissed',
      'Insight has been dismissed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _executeAction(InsightModel insight) {
    if (insight.actions.isEmpty) return;

    final action = insight.actions.first;
    switch (action.type) {
      case InsightActionType.cancel:
        if (action.subscriptionId != null) {
          _controller.deleteSubscription(action.subscriptionId!);
        }
        break;
      case InsightActionType.pause:
        if (action.subscriptionId != null) {
          _controller.pauseSubscription(action.subscriptionId!);
        }
        break;
      case InsightActionType.review:
        if (action.subscriptionId != null) {
          final sub = _controller.getById(action.subscriptionId!);
          if (sub != null) {
            Get.toNamed('/subscription/${sub.id}');
          }
        }
        break;
      case InsightActionType.remind:
        Get.snackbar('Reminder Set', 'We\'ll remind you about this');
        break;
      case InsightActionType.dismiss:
        _dismissInsight(insight);
        break;
      case InsightActionType.downgrade:
      case InsightActionType.negotiate:
      case InsightActionType.viewDetails:
      case InsightActionType.logUsage:
        // Handle other actions
        break;
    }
  }

  Color _getPriorityColor(InsightPriority priority) {
    switch (priority) {
      case InsightPriority.critical:
        return Colors.red;
      case InsightPriority.high:
        return Colors.orange;
      case InsightPriority.medium:
        return const Color(0xFF7C4DFF);
      case InsightPriority.low:
        return Colors.grey;
    }
  }

  String _getTypeLabel(InsightType type) {
    switch (type) {
      case InsightType.costSaving:
        return 'Savings';
      case InsightType.unusedSubscription:
        return 'Unused';
      case InsightType.priceIncrease:
        return 'Price Hike';
      case InsightType.trialEnding:
        return 'Trial Ending';
      case InsightType.duplicateService:
        return 'Duplicate';
      case InsightType.budgetWarning:
        return 'Budget';
      case InsightType.paymentUpcoming:
        return 'Upcoming';
      case InsightType.regretDetection:
        return 'Regret Risk';
      case InsightType.spendDrift:
        return 'Spend Drift';
      case InsightType.categorySpike:
        return 'Category Spike';
      case InsightType.monthlySummary:
        return 'Summary';
      case InsightType.annualProjection:
        return 'Annual';
      case InsightType.worthItScore:
        return 'Worth It';
      case InsightType.behavioralNudge:
        return 'Tip';
    }
  }

  String _getActionLabel(InsightActionType actionType) {
    switch (actionType) {
      case InsightActionType.cancel:
        return 'Cancel Subscription';
      case InsightActionType.pause:
        return 'Pause Subscription';
      case InsightActionType.review:
        return 'Review Details';
      case InsightActionType.downgrade:
        return 'Downgrade Plan';
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
