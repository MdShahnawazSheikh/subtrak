import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/data/models/subscription_model.dart';
import '../widgets/modern_ui_components.dart';

/// Budget & Goals Screen - Modern Redesign
class BudgetGoalsScreen extends StatefulWidget {
  const BudgetGoalsScreen({super.key});

  @override
  State<BudgetGoalsScreen> createState() => _BudgetGoalsScreenState();
}

class _BudgetGoalsScreenState extends State<BudgetGoalsScreen> {
  final SubscriptionController _controller = Get.find();

  double _monthlyBudget = 5000;
  bool _alertsEnabled = true;
  int _alertThreshold = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildBudgetOverview(context)),
          SliverToBoxAdapter(child: _buildCategoryBudgets(context)),
          SliverToBoxAdapter(child: _buildSavingsGoals(context)),
          SliverToBoxAdapter(child: _buildBudgetSettings(context)),
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
        'Budget & Goals',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => _editBudget(context),
        ),
      ],
    );
  }

  Widget _buildBudgetOverview(BuildContext context) {
    return Obx(() {
      final summary = _controller.summary.value;
      final spent = summary.totalMonthly;
      final remaining = _monthlyBudget - spent;
      final percentage = spent / _monthlyBudget;
      final isOverBudget = remaining < 0;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: AccentCard(
          accentColor: isOverBudget ? AppColors.error : AppColors.success,
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
                    child: Icon(
                      isOverBudget
                          ? Icons.warning_rounded
                          : Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOverBudget ? 'Over Budget' : 'On Track',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Monthly budget: ₹${_monthlyBudget.toStringAsFixed(0)}',
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
              const SizedBox(height: 28),
              // Progress ring visualization
              Row(
                children: [
                  // Circular progress
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: percentage.clamp(0.0, 1.0),
                            strokeWidth: 8,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isOverBudget ? Colors.redAccent : Colors.white,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(percentage * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'used',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BudgetStatRow(
                          label: 'Spent',
                          value: '₹${spent.toStringAsFixed(0)}',
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        _BudgetStatRow(
                          label: remaining >= 0 ? 'Remaining' : 'Over by',
                          value: '₹${remaining.abs().toStringAsFixed(0)}',
                          color: remaining >= 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                        const SizedBox(height: 12),
                        _BudgetStatRow(
                          label: 'Daily limit',
                          value: '₹${(_monthlyBudget / 30).toStringAsFixed(0)}',
                          color: Colors.white70,
                        ),
                      ],
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

  Widget _buildCategoryBudgets(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final byCategory = _controller.spendByCategory;
      if (byCategory.isEmpty) return const SizedBox.shrink();

      final sortedCategories = byCategory.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernSectionHeader(
            title: 'Category Budgets',
            actionText: 'Set Limits',
            onAction: () => _setCategoryLimits(context),
          ),
          ModernCard(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: sortedCategories.take(4).map((entry) {
                final categoryBudget =
                    _monthlyBudget / 5; // Simple distribution
                final percentage = entry.value / categoryBudget;
                final isLast = entry == sortedCategories.take(4).last;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                                '₹${entry.value.toStringAsFixed(0)} / ₹${categoryBudget.toStringAsFixed(0)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: percentage > 1
                                      ? AppColors.error
                                      : theme.colorScheme.onSurface.withValues(
                                          alpha: 0.6,
                                        ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ModernProgressBar(
                            progress: percentage.clamp(0.0, 1.0),
                            color: percentage > 1
                                ? AppColors.error
                                : percentage > 0.8
                                ? AppColors.warning
                                : _getCategoryColor(entry.key),
                            height: 6,
                          ),
                        ],
                      ),
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

  Widget _buildSavingsGoals(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModernSectionHeader(
          title: 'Savings Goals',
          actionText: 'Add Goal',
          onAction: () => _addGoal(context),
        ),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _GoalCard(
                title: 'Reduce streaming',
                current: 1200,
                target: 500,
                icon: Icons.tv_rounded,
                color: AppColors.error,
              ),
              _GoalCard(
                title: 'Annual switch',
                current: 3200,
                target: 5000,
                icon: Icons.calendar_today_rounded,
                color: AppColors.success,
              ),
              _GoalCard(
                title: 'Cancel unused',
                current: 2,
                target: 3,
                icon: Icons.cancel_outlined,
                color: AppColors.warning,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(title: 'Settings'),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ActionTile(
                icon: Icons.attach_money_rounded,
                title: 'Monthly Budget',
                subtitle: '₹${_monthlyBudget.toStringAsFixed(0)}',
                onTap: () => _editBudget(context),
              ),
              const ModernDivider(),
              ToggleTile(
                icon: Icons.notifications_active_outlined,
                title: 'Budget Alerts',
                subtitle: 'Notify when approaching limit',
                value: _alertsEnabled,
                onChanged: (v) => setState(() => _alertsEnabled = v),
              ),
              const ModernDivider(),
              ActionTile(
                icon: Icons.percent_rounded,
                title: 'Alert Threshold',
                subtitle: '$_alertThreshold% of budget',
                onTap: () => _setAlertThreshold(context),
              ),
              const ModernDivider(),
              ActionTile(
                icon: Icons.sync_rounded,
                title: 'Reset Day',
                subtitle: '1st of each month',
                onTap: () => _setResetDay(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editBudget(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _BudgetEditSheet(
        currentBudget: _monthlyBudget,
        onSave: (value) {
          setState(() => _monthlyBudget = value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _setCategoryLimits(BuildContext context) {
    HapticFeedback.lightImpact();
    Get.snackbar(
      'Category Limits',
      'Set individual limits for each category',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _addGoal(BuildContext context) {
    HapticFeedback.lightImpact();
    Get.snackbar(
      'Add Goal',
      'Create a new savings goal',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _setAlertThreshold(BuildContext context) {
    HapticFeedback.lightImpact();
  }

  void _setResetDay(BuildContext context) {
    HapticFeedback.lightImpact();
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
      default:
        return const Color(0xFF94A3B8);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _BudgetStatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BudgetStatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final double current;
  final double target;
  final IconData icon;
  final Color color;

  const _GoalCard({
    required this.title,
    required this.current,
    required this.target,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = (current / target).clamp(0.0, 1.0);

    return Container(
      width: 160,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          ModernProgressBar(progress: progress, color: color, height: 4),
        ],
      ),
    );
  }
}

class _BudgetEditSheet extends StatefulWidget {
  final double currentBudget;
  final Function(double) onSave;

  const _BudgetEditSheet({required this.currentBudget, required this.onSave});

  @override
  State<_BudgetEditSheet> createState() => _BudgetEditSheetState();
}

class _BudgetEditSheetState extends State<_BudgetEditSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentBudget.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Set Monthly Budget',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '₹ ',
                hintText: 'Enter amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final value = double.tryParse(_controller.text);
                      if (value != null && value > 0) {
                        widget.onSave(value);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save'),
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
