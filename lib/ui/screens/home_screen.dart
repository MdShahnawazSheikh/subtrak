import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../app/data/models/subscription_model.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/controllers/settings_controller.dart';
import '../../app/services/ocr_service.dart';
import '../widgets/brand_logo_widget.dart';
import 'subscription_detail_screen.dart';
import 'add_subscription_screen.dart';
import 'insights_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import 'analytics_dashboard_screen.dart';
import 'budget_goals_screen.dart';
import 'smart_insights_screen.dart';
import 'export_reports_screen.dart';
import 'family_sharing_screen.dart';
import 'price_alerts_screen.dart';
import 'subscription_comparison_screen.dart';
import 'cancellation_manager_screen.dart';
import 'usage_tracking_screen.dart';

// iOS-inspired color palette
class _HomeColors {
  static const primary = Color(0xFF007AFF);
  static const secondary = Color(0xFF5856D6);
  static const accent = Color(0xFF34C759);
  static const warning = Color(0xFFFF9500);
  static const error = Color(0xFFFF3B30);
  static const pink = Color(0xFFFF2D92);
  static const teal = Color(0xFF5AC8FA);
  static const purple = Color(0xFFAF52DE);

  // Stat card colors
  static const activeGreen = Color(0xFF30D158);
  static const pausedOrange = Color(0xFFFF9F0A);
  static const trialPurple = Color(0xFFBF5AF2);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final SubscriptionController _controller = Get.find();
  final SettingsController _settingsController = Get.find();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(context),
          const CalendarScreen(),
          const InsightsScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _buildIOSBottomNav(context),
      floatingActionButton: _buildModernFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // iOS-style large title app bar
        _buildIOSAppBar(context, isDark),

        // Premium spend card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: _buildSpendCard(context, isDark),
          ),
        ),

        // Quick stats row
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: _buildQuickStats(context, isDark),
          ),
        ),

        // Smart insights banner
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: _buildInsightsBanner(context, isDark),
          ),
        ),

        // Upcoming bills section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: _buildSectionHeader(
              context,
              'Upcoming Bills',
              'See All',
              () => setState(() => _selectedIndex = 1),
            ),
          ),
        ),

        // Upcoming bills list
        _buildUpcomingBillsList(context, isDark),

        // All subscriptions section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: _buildAllSubscriptionsHeader(context),
          ),
        ),

        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildSearchBar(context, isDark),
          ),
        ),

        // All subscriptions list
        _buildAllSubscriptionsList(context, isDark),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  Widget _buildIOSAppBar(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 70,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor.withValues(alpha: 0.9)
          : theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
      surfaceTintColor: Colors.transparent,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
            title: Text(
              'SubTrak',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            background: Container(color: theme.scaffoldBackgroundColor),
          ),
        ),
      ),
      actions: [
        _buildAppBarAction(
          context,
          Icons.auto_awesome_rounded,
          () => Get.to(() => const SmartInsightsScreen()),
        ),
        _buildMoreMenu(context),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTierBadge(BuildContext context, bool isDark) {
    return Obx(() {
      final tier = _settingsController.settings.value?.tier;
      final tierName = tier?.name.toUpperCase() ?? 'FREE';
      final isLifetime = tierName == 'LIFETIME';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          gradient: isLifetime
              ? const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                )
              : null,
          color: isLifetime
              ? null
              : _HomeColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          tierName,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: isLifetime ? Colors.white : _HomeColors.primary,
            letterSpacing: 0.8,
          ),
        ),
      );
    });
  }

  Widget _buildAppBarAction(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 22,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildMoreMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.more_horiz_rounded,
          size: 22,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: _handleMenuAction,
      itemBuilder: (context) => [
        _buildMenuItem(
          'analytics',
          Icons.analytics_rounded,
          'Analytics',
          _HomeColors.secondary,
        ),
        _buildMenuItem(
          'budget',
          Icons.savings_rounded,
          'Budget & Goals',
          _HomeColors.warning,
        ),
        _buildMenuItem(
          'insights',
          Icons.psychology_rounded,
          'AI Insights',
          _HomeColors.accent,
        ),
        _buildMenuItem(
          'export',
          Icons.download_rounded,
          'Export Reports',
          _HomeColors.primary,
        ),
        _buildMenuItem(
          'family',
          Icons.people_rounded,
          'Family Sharing',
          _HomeColors.pink,
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          'price-alerts',
          Icons.notifications_active_rounded,
          'Price Alerts',
          _HomeColors.teal,
        ),
        _buildMenuItem(
          'compare',
          Icons.compare_arrows_rounded,
          'Compare',
          _HomeColors.purple,
        ),
        _buildMenuItem(
          'renewals',
          Icons.event_repeat_rounded,
          'Renewals',
          _HomeColors.warning,
        ),
        _buildMenuItem(
          'usage',
          Icons.bar_chart_rounded,
          'Usage',
          _HomeColors.primary,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String title,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'analytics':
        Get.to(() => const AnalyticsDashboardScreen());
        break;
      case 'budget':
        Get.to(() => const BudgetGoalsScreen());
        break;
      case 'insights':
        Get.to(() => const SmartInsightsScreen());
        break;
      case 'export':
        Get.to(() => const ExportReportsScreen());
        break;
      case 'family':
        Get.to(() => const FamilySharingScreen());
        break;
      case 'price-alerts':
        Get.to(() => const PriceAlertsScreen());
        break;
      case 'compare':
        Get.to(() => const SubscriptionComparisonScreen());
        break;
      case 'renewals':
        Get.to(() => const CancellationManagerScreen());
        break;
      case 'usage':
        Get.to(() => const UsageTrackingScreen());
        break;
    }
  }

  Widget _buildSpendCard(BuildContext context, bool isDark) {
    return Obx(() {
      final summary = _controller.summary.value;
      final budgetLimit =
          _settingsController.settings.value?.budget.monthlyLimit;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1C1C1E), Color(0xFF2C2C2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                  'Monthly Spend',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _HomeColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_down_rounded,
                        size: 14,
                        color: _HomeColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '12%',
                        style: TextStyle(
                          color: _HomeColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${summary.totalMonthly.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.5,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Yearly',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${summary.totalYearly.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (budgetLimit != null && budgetLimit > 0) ...[
              const SizedBox(height: 20),
              _buildBudgetProgress(summary.totalMonthly, budgetLimit),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildBudgetProgress(double current, double limit) {
    final percent = (current / limit * 100).clamp(0, 100);
    final isOver = current > limit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Budget',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
            Text(
              '${percent.toStringAsFixed(0)}% of ₹${limit.toStringAsFixed(0)}',
              style: TextStyle(
                color: isOver
                    ? _HomeColors.error
                    : Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation(
              isOver
                  ? _HomeColors.error
                  : percent > 80
                  ? _HomeColors.warning
                  : _HomeColors.accent,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isDark) {
    return Obx(() {
      final stats = _controller.subscriptionStats;

      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              stats['active'] ?? 0,
              'Active',
              Icons.check_circle_rounded,
              _HomeColors.activeGreen,
              isDark,
              () => _filterByStatus(SubscriptionStatus.active),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              stats['paused'] ?? 0,
              'Paused',
              Icons.pause_circle_rounded,
              _HomeColors.pausedOrange,
              isDark,
              () => _filterByStatus(SubscriptionStatus.paused),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              stats['trials'] ?? 0,
              'Trials',
              Icons.hourglass_top_rounded,
              _HomeColors.trialPurple,
              isDark,
              () => _filterByStatus(SubscriptionStatus.trial),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(
    BuildContext context,
    int count,
    String label,
    IconData icon,
    Color color,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsBanner(BuildContext context, bool isDark) {
    return Obx(() {
      final insights = _controller.insights;
      if (insights.isEmpty) return const SizedBox.shrink();

      final potentialSavings = _controller.summary.value.potentialSavings;

      return GestureDetector(
        onTap: () => Get.to(() => const SmartInsightsScreen()),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _HomeColors.accent.withValues(alpha: 0.15),
                _HomeColors.teal.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _HomeColors.accent.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _HomeColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: _HomeColors.accent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${insights.length} Smart Insights',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Save up to ₹${potentialSavings.toStringAsFixed(0)}/mo',
                      style: const TextStyle(
                        color: _HomeColors.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _HomeColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      size: 16,
                      color: _HomeColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${insights.length}',
                      style: const TextStyle(
                        color: _HomeColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
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

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String actionText,
    VoidCallback onAction,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionText,
            style: const TextStyle(
              color: _HomeColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingBillsList(BuildContext context, bool isDark) {
    return Obx(() {
      final upcoming = _controller.upcomingSubscriptions;

      if (upcoming.isEmpty) {
        return SliverToBoxAdapter(
          child: _buildEmptyState(
            context,
            Icons.event_available_rounded,
            'No Upcoming Bills',
            'Add subscriptions to see upcoming payments',
            isDark,
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final sub = upcoming[index];
          return _buildSubscriptionTile(context, sub, isDark, compact: true);
        }, childCount: upcoming.take(5).length),
      );
    });
  }

  Widget _buildAllSubscriptionsHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Text(
            'All Subscriptions (${_controller.filteredSubscriptions.length})',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        _buildSortButton(context, isDark),
      ],
    );
  }

  Widget _buildSortButton(BuildContext context, bool isDark) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.sort_rounded,
          size: 20,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (value) => _controller.setSortBy(value),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'name', child: Text('Name')),
        const PopupMenuItem(value: 'amount', child: Text('Amount')),
        const PopupMenuItem(value: 'nextBilling', child: Text('Next Billing')),
        const PopupMenuItem(value: 'dateAdded', child: Text('Date Added')),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        onChanged: _controller.setSearchQuery,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: 'Search subscriptions...',
          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? Colors.white38 : Colors.black38,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAllSubscriptionsList(BuildContext context, bool isDark) {
    return Obx(() {
      final subs = _controller.filteredSubscriptions;

      if (subs.isEmpty) {
        return SliverToBoxAdapter(
          child: _buildEmptyState(
            context,
            Icons.subscriptions_rounded,
            'No Subscriptions Yet',
            'Add your first subscription to start tracking',
            isDark,
            action: FilledButton.icon(
              onPressed: _addSubscription,
              style: FilledButton.styleFrom(
                backgroundColor: _HomeColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Add Subscription'),
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final sub = subs[index];
          return _buildSubscriptionTile(context, sub, isDark);
        }, childCount: subs.length),
      );
    });
  }

  Widget _buildSubscriptionTile(
    BuildContext context,
    SubscriptionModel sub,
    bool isDark, {
    bool compact = false,
  }) {
    final daysUntil = sub.nextBillingDate.difference(DateTime.now()).inDays;
    final color = sub.color ?? _HomeColors.primary;

    return GestureDetector(
      onTap: () => _openDetail(sub),
      onLongPress: () => _showQuickActions(sub),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isDark
              ? null
              : Border.all(color: Colors.black.withValues(alpha: 0.06)),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Logo / Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: sub.iconName != null && sub.iconName!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: BrandLogoWidget(
                        name: sub.name,
                        iconName: sub.iconName,
                        color: color,
                        size: 48,
                        borderRadius: 14,
                      ),
                    )
                  : Center(
                      child: Text(
                        sub.name.isNotEmpty ? sub.name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: _darkenColor(color),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    compact
                        ? (daysUntil == 0
                              ? 'Due today'
                              : daysUntil == 1
                              ? 'Due tomorrow'
                              : 'Due in $daysUntil days')
                        : _getRecurrenceText(sub.recurrenceType),
                    style: TextStyle(
                      color: compact && daysUntil <= 3
                          ? _HomeColors.warning
                          : (isDark ? Colors.white54 : Colors.black45),
                      fontSize: 13,
                      fontWeight: compact && daysUntil <= 3
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              '₹${sub.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool isDark, {
    Widget? action,
  }) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 56, color: isDark ? Colors.white24 : Colors.black26),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
          if (action != null) ...[const SizedBox(height: 20), action],
        ],
      ),
    );
  }

  Widget _buildIOSBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1C1C1E).withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    0,
                    Icons.home_rounded,
                    Icons.home_outlined,
                    'Home',
                    isDark,
                  ),
                  _buildNavItem(
                    1,
                    Icons.calendar_month_rounded,
                    Icons.calendar_month_outlined,
                    'Calendar',
                    isDark,
                  ),
                  const SizedBox(width: 56), // FAB space
                  _buildNavItem(
                    2,
                    Icons.lightbulb_rounded,
                    Icons.lightbulb_outline,
                    'Insights',
                    isDark,
                  ),
                  _buildNavItem(
                    3,
                    Icons.settings_rounded,
                    Icons.settings_outlined,
                    'Settings',
                    isDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData icon,
    String label,
    bool isDark,
  ) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? _HomeColors.primary
                  : (isDark ? Colors.white54 : Colors.black45),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? _HomeColors.primary
                    : (isDark ? Colors.white54 : Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernFAB(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_HomeColors.primary, Color(0xFF5856D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _HomeColors.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _showAddOptions,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  void _showAddOptions() {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // Options
            _buildAddOption(
              Icons.edit_rounded,
              'Add Manually',
              'Fill in subscription details',
              _HomeColors.primary,
              isDark,
              () {
                Get.back();
                _addSubscription();
              },
            ),
            const SizedBox(height: 12),
            _buildAddOption(
              Icons.document_scanner_rounded,
              'Scan Screenshot',
              'Extract details from image',
              _HomeColors.secondary,
              isDark,
              () {
                Get.back();
                OcrService.showOcrDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOption(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(SubscriptionModel sub) {
    Get.to(
      () => SubscriptionDetailScreen(subscription: sub),
      transition: Transition.cupertino,
    );
  }

  void _addSubscription() {
    HapticFeedback.mediumImpact();
    Get.to(
      () => const AddSubscriptionScreen(),
      transition: Transition.downToUp,
      fullscreenDialog: true,
    );
  }

  void _filterByStatus(SubscriptionStatus status) {
    _controller.setStatusFilter(status);
  }

  void _showQuickActions(SubscriptionModel sub) {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = sub.color ?? _HomeColors.primary;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          sub.name.isNotEmpty ? sub.name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sub.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            '₹${sub.amount.toStringAsFixed(0)} / ${_getRecurrenceText(sub.recurrenceType)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.08),
                height: 1,
              ),
              // Actions
              _buildQuickAction(Icons.edit_rounded, 'Edit', isDark, () {
                Get.back();
                Get.to(() => AddSubscriptionScreen(editSubscription: sub));
              }),
              if (sub.status == SubscriptionStatus.active)
                _buildQuickAction(
                  Icons.pause_circle_rounded,
                  'Pause',
                  isDark,
                  () {
                    Get.back();
                    _controller.pauseSubscription(sub.id);
                  },
                )
              else if (sub.status == SubscriptionStatus.paused)
                _buildQuickAction(
                  Icons.play_circle_rounded,
                  'Resume',
                  isDark,
                  () {
                    Get.back();
                    _controller.resumeSubscription(sub.id);
                  },
                ),
              _buildQuickAction(Icons.copy_rounded, 'Duplicate', isDark, () {
                Get.back();
                _controller.duplicateSubscription(sub.id);
              }),
              _buildQuickAction(Icons.delete_rounded, 'Delete', isDark, () {
                Get.back();
                _confirmDelete(sub);
              }, isDestructive: true),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String label,
    bool isDark,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? _HomeColors.error
        : (isDark ? Colors.white : Colors.black87);

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  void _confirmDelete(SubscriptionModel sub) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Subscription',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          'Are you sure you want to delete "${sub.name}"?',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _controller.deleteSubscription(sub.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: _HomeColors.error),
            ),
          ),
        ],
      ),
    );
  }

  // Darken a color for better contrast on light backgrounds
  Color _darkenColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * 0.6).clamp(0.0, 1.0)).toColor();
  }

  String _getRecurrenceText(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.biWeekly:
        return 'Bi-weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
      case RecurrenceType.biMonthly:
        return 'Bi-monthly';
      case RecurrenceType.quarterly:
        return 'Quarterly';
      case RecurrenceType.semiAnnual:
        return 'Semi-annual';
      case RecurrenceType.annual:
        return 'Yearly';
      case RecurrenceType.custom:
        return 'Custom';
      case RecurrenceType.oneTime:
        return 'One-time';
    }
  }
}
