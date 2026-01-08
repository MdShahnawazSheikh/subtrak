import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../app/controllers/subscription_controller.dart';
import '../../app/controllers/settings_controller.dart';

/// Budget Goals Screen with Gamification Elements
class BudgetGoalsScreen extends StatefulWidget {
  const BudgetGoalsScreen({super.key});

  @override
  State<BudgetGoalsScreen> createState() => _BudgetGoalsScreenState();
}

class _BudgetGoalsScreenState extends State<BudgetGoalsScreen>
    with TickerProviderStateMixin {
  final SubscriptionController _controller = Get.find();
  final SettingsController _settingsController = Get.find();
  late AnimationController _celebrationController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _progressController.dispose();
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
          SliverToBoxAdapter(child: _buildBudgetOverview(context)),
          SliverToBoxAdapter(child: _buildStreakCard(context)),
          SliverToBoxAdapter(child: _buildAchievementsSection(context)),
          SliverToBoxAdapter(child: _buildMilestonesSection(context)),
          SliverToBoxAdapter(child: _buildChallengesSection(context)),
          SliverToBoxAdapter(child: _buildLeaderboardSection(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Budget & Goals',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF6B6B).withOpacity(0.3),
                const Color(0xFFFFE66D).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.settings_outlined, size: 20),
          ),
          onPressed: () => _showBudgetSettings(context),
        ),
      ],
    );
  }

  Widget _buildBudgetOverview(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final budgetLimit =
          _settingsController.settings.value?.budget.monthlyLimit ?? 0;
      final currentSpend = _controller.summary.value.totalMonthly;
      final progress = budgetLimit > 0
          ? (currentSpend / budgetLimit).clamp(0.0, 1.2)
          : 0.0;
      final remaining = (budgetLimit - currentSpend).clamp(
        0.0,
        double.infinity,
      );
      final isOverBudget = currentSpend > budgetLimit && budgetLimit > 0;
      final isUnderBudget = currentSpend < budgetLimit * 0.8 && budgetLimit > 0;

      return Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isOverBudget
                ? [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)]
                : isUnderBudget
                ? [const Color(0xFF00BFA6), const Color(0xFF00D4AA)]
                : [const Color(0xFF7C4DFF), const Color(0xFF9C7DFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color:
                  (isOverBudget
                          ? const Color(0xFFFF6B6B)
                          : isUnderBudget
                          ? const Color(0xFF00BFA6)
                          : const Color(0xFF7C4DFF))
                      .withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: CustomPaint(
                  painter: _PatternPainter(
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isOverBudget
                                ? 'Over Budget! 😰'
                                : isUnderBudget
                                ? 'Great Savings! 🎉'
                                : 'On Track 💪',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Monthly Budget',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isOverBudget
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Circular progress
                  SizedBox(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: _CircularBudgetPainter(
                                  progress:
                                      progress.clamp(0.0, 1.0) *
                                      _progressController.value,
                                  color: Colors.white,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.2,
                                  ),
                                  strokeWidth: 14,
                                ),
                              );
                            },
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${currentSpend.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              budgetLimit > 0
                                  ? 'of ₹${budgetLimit.toStringAsFixed(0)}'
                                  : 'No limit set',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Remaining budget
                  if (budgetLimit > 0)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildBudgetMetric(
                            label: isOverBudget ? 'Over by' : 'Remaining',
                            value:
                                '₹${(isOverBudget ? currentSpend - budgetLimit : remaining).toStringAsFixed(0)}',
                            icon: isOverBudget
                                ? Icons.arrow_upward
                                : Icons.account_balance_wallet,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          _buildBudgetMetric(
                            label: 'Daily Avg',
                            value:
                                '₹${(currentSpend / DateTime.now().day).toStringAsFixed(0)}',
                            icon: Icons.calendar_today,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          _buildBudgetMetric(
                            label: 'Projected',
                            value:
                                '₹${((currentSpend / DateTime.now().day) * 30).toStringAsFixed(0)}',
                            icon: Icons.trending_flat,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBudgetMetric({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Calculate streak (days under budget)
    final streak = 12; // This would be calculated from history

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9500), Color(0xFFFF5E3A)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF9500).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text('🔥', style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streak Day Streak!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep staying under budget to continue your streak',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9500).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Color(0xFFFF9500),
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  'Best: 24',
                  style: TextStyle(
                    color: const Color(0xFFFF9500),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final achievements = [
      _Achievement(
        icon: '🎯',
        title: 'Budget Master',
        description: 'Stay under budget for 30 days',
        progress: 0.4,
        isUnlocked: false,
        xp: 500,
      ),
      _Achievement(
        icon: '💰',
        title: 'Super Saver',
        description: 'Save ₹5,000 in a month',
        progress: 1.0,
        isUnlocked: true,
        xp: 250,
      ),
      _Achievement(
        icon: '🏆',
        title: 'Subscription Pro',
        description: 'Track 10+ subscriptions',
        progress: 0.8,
        isUnlocked: false,
        xp: 300,
      ),
      _Achievement(
        icon: '⚡',
        title: 'Quick Optimizer',
        description: 'Cancel an unused subscription',
        progress: 1.0,
        isUnlocked: true,
        xp: 100,
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Achievements',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C4DFF), Color(0xFF9C7DFF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      const Text(
                        '850 XP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return _buildAchievementCard(context, achievement);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(BuildContext context, _Achievement achievement) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: achievement.isUnlocked
            ? Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.5),
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: achievement.isUnlocked
                ? const Color(0xFFFFD700).withOpacity(0.2)
                : Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: achievement.isUnlocked
                  ? const Color(0xFFFFD700).withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: TextStyle(
                  fontSize: 26,
                  color: achievement.isUnlocked ? null : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            achievement.title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: achievement.isUnlocked ? null : theme.hintColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          if (!achievement.isUnlocked)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: achievement.progress,
                backgroundColor: const Color(0xFF7C4DFF).withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF7C4DFF)),
                minHeight: 6,
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFFFD700),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '+${achievement.xp} XP',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMilestonesSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final milestones = [
      _Milestone(
        title: 'First ₹1,000 Saved',
        targetValue: 1000,
        currentValue: 850,
        icon: Icons.savings,
        color: const Color(0xFF00BFA6),
      ),
      _Milestone(
        title: 'Cancel 3 Unused',
        targetValue: 3,
        currentValue: 1,
        icon: Icons.cancel,
        color: const Color(0xFFFF6B6B),
      ),
      _Milestone(
        title: 'Track for 30 Days',
        targetValue: 30,
        currentValue: 18,
        icon: Icons.calendar_month,
        color: const Color(0xFF7C4DFF),
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Milestones',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...milestones.map((m) => _buildMilestoneItem(context, m)),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem(BuildContext context, _Milestone milestone) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = (milestone.currentValue / milestone.targetValue).clamp(
      0.0,
      1.0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: milestone.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(milestone.icon, color: milestone.color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      milestone.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${milestone.currentValue.toInt()}/${milestone.targetValue.toInt()}',
                      style: TextStyle(
                        color: milestone.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: milestone.color.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation(milestone.color),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Challenges',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.timer, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '3 days left',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667EEA).withOpacity(0.9),
                  const Color(0xFF764BA2).withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.flash_on,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No New Subscriptions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Don\'t add any new subscriptions this week',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: 0.71,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                          minHeight: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.stars, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '+200 XP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
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

  Widget _buildLeaderboardSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final leaderboard = [
      _LeaderboardEntry(rank: 1, name: 'You', xp: 2450, isCurrentUser: true),
      _LeaderboardEntry(
        rank: 2,
        name: 'SavvySam',
        xp: 2380,
        isCurrentUser: false,
      ),
      _LeaderboardEntry(
        rank: 3,
        name: 'BudgetPro',
        xp: 2190,
        isCurrentUser: false,
      ),
      _LeaderboardEntry(
        rank: 4,
        name: 'MoneyWise',
        xp: 1980,
        isCurrentUser: false,
      ),
      _LeaderboardEntry(
        rank: 5,
        name: 'ThriftKing',
        xp: 1840,
        isCurrentUser: false,
      ),
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(24),
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
                'Leaderboard',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: Color(0xFFFFD700),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '#1',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...leaderboard.map((entry) => _buildLeaderboardItem(context, entry)),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(BuildContext context, _LeaderboardEntry entry) {
    final theme = Theme.of(context);

    Color getRankColor(int rank) {
      switch (rank) {
        case 1:
          return const Color(0xFFFFD700);
        case 2:
          return const Color(0xFFC0C0C0);
        case 3:
          return const Color(0xFFCD7F32);
        default:
          return theme.hintColor;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? const Color(0xFF7C4DFF).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: entry.isCurrentUser
            ? Border.all(color: const Color(0xFF7C4DFF).withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: getRankColor(entry.rank).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: entry.rank <= 3
                  ? Icon(
                      Icons.emoji_events,
                      color: getRankColor(entry.rank),
                      size: 18,
                    )
                  : Text(
                      '#${entry.rank}',
                      style: TextStyle(
                        color: getRankColor(entry.rank),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              entry.name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: entry.isCurrentUser
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: entry.isCurrentUser ? const Color(0xFF7C4DFF) : null,
              ),
            ),
          ),
          Text(
            '${entry.xp} XP',
            style: TextStyle(
              color: entry.isCurrentUser
                  ? const Color(0xFF7C4DFF)
                  : theme.hintColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showBudgetSettings(BuildContext context) {
    // TODO: Implement budget settings bottom sheet
    Get.snackbar(
      'Coming Soon',
      'Budget settings will be available soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Data classes
class _Achievement {
  final String icon;
  final String title;
  final String description;
  final double progress;
  final bool isUnlocked;
  final int xp;

  const _Achievement({
    required this.icon,
    required this.title,
    required this.description,
    required this.progress,
    required this.isUnlocked,
    required this.xp,
  });
}

class _Milestone {
  final String title;
  final double targetValue;
  final double currentValue;
  final IconData icon;
  final Color color;

  const _Milestone({
    required this.title,
    required this.targetValue,
    required this.currentValue,
    required this.icon,
    required this.color,
  });
}

class _LeaderboardEntry {
  final int rank;
  final String name;
  final int xp;
  final bool isCurrentUser;

  const _LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.xp,
    required this.isCurrentUser,
  });
}

// Custom painters
class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 30.0;
    for (var i = 0.0; i < size.width + size.height; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(0, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CircularBudgetPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularBudgetPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
