import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/data/models/subscription_model.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/controllers/settings_controller.dart';
import '../../app/services/ocr_service.dart';
import '../widgets/premium_components.dart';
import '../widgets/subscription_card.dart';
import '../widgets/spend_summary_card.dart'
    hide QuickStatsRow, CategoryBreakdown;
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final SubscriptionController _subscriptionController = Get.find();
  final SettingsController _settingsController = Get.find();
  late AnimationController _fabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
      bottomNavigationBar: _buildBottomNav(context, isDark),
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Obx(() {
            final summary = _subscriptionController.summary.value;
            final budgetLimit =
                _settingsController.settings.value?.budget.monthlyLimit;

            return SpendSummaryCard(
              totalMonthly: summary.totalMonthly,
              totalYearly: summary.totalYearly,
              budgetLimit: budgetLimit,
              previousMonthTotal: null, // TODO: Track historical data
              currency: _settingsController.formatAmount(0).substring(0, 1),
            );
          }),
        ),
        SliverToBoxAdapter(
          child: Obx(() {
            final stats = _subscriptionController.subscriptionStats;
            return QuickStatsRow(
              activeCount: stats['active'] ?? 0,
              pausedCount: stats['paused'] ?? 0,
              trialsCount: stats['trials'] ?? 0,
              onActiveTap: () => _filterByStatus(SubscriptionStatus.active),
              onPausedTap: () => _filterByStatus(SubscriptionStatus.paused),
              onTrialsTap: () => _filterByStatus(SubscriptionStatus.trial),
            );
          }),
        ),
        // Insights summary
        SliverToBoxAdapter(
          child: Obx(() {
            final insights = _subscriptionController.insights;
            if (insights.isEmpty) return const SizedBox.shrink();

            return InsightsSummaryBar(
              insights: insights,
              onViewAll: () => setState(() => _selectedIndex = 2),
            );
          }),
        ),
        // Upcoming bills section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 16, top: 24),
            child: SectionHeader(
              title: 'Upcoming Bills',
              actionText: 'See All',
              onAction: () => setState(() => _selectedIndex = 1),
            ),
          ),
        ),
        Obx(() {
          final upcoming = _subscriptionController.upcomingSubscriptions;
          if (upcoming.isEmpty) {
            return SliverToBoxAdapter(
              child: EmptyStateWidget(
                icon: Icons.event_available_outlined,
                title: 'No upcoming bills',
                subtitle: 'Add a subscription to see upcoming payments',
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final sub = upcoming[index];
              return SubscriptionCard(
                subscription: sub,
                compact: true,
                onTap: () => _openDetail(sub),
                onLongPress: () => _showQuickActions(sub),
              );
            }, childCount: upcoming.take(5).length),
          );
        }),
        // Category breakdown
        SliverToBoxAdapter(
          child: Obx(() {
            final byCategory = _subscriptionController.spendByCategory;
            if (byCategory.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: CategoryBreakdown(
                categorySpend: byCategory.map(
                  (key, value) => MapEntry(key.name, value),
                ),
                currency: _settingsController.formatAmount(0).substring(0, 1),
              ),
            );
          }),
        ),
        // All subscriptions section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 16,
              top: 24,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    'All Subscriptions (${_subscriptionController.filteredSubscriptions.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildSortButton(context),
              ],
            ),
          ),
        ),
        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildSearchBar(context),
          ),
        ),
        Obx(() {
          final subs = _subscriptionController.filteredSubscriptions;
          if (subs.isEmpty) {
            return SliverToBoxAdapter(
              child: EmptyStateWidget(
                icon: Icons.subscriptions_outlined,
                title: 'No subscriptions yet',
                subtitle: 'Add your first subscription to start tracking',
                action: FilledButton.icon(
                  onPressed: _addSubscription,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Subscription'),
                ),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final sub = subs[index];
              return SubscriptionCard(
                subscription: sub,
                onTap: () => _openDetail(sub),
                onLongPress: () => _showQuickActions(sub),
              );
            }, childCount: subs.length),
          );
        }),
        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 110,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Row(
          children: [
            Text(
              'SubTrak',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Obx(() {
                final tier = _settingsController.settings.value?.tier;
                return Text(
                  tier?.name.toUpperCase() ?? 'FREE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.5,
                  ),
                );
              }),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.05),
                theme.scaffoldBackgroundColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.auto_awesome),
          tooltip: 'AI Insights',
          onPressed: () => Get.to(() => const SmartInsightsScreen()),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
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
              case 'notifications':
                _openNotifications();
                break;
            }
          },
          itemBuilder: (context) => [
            _buildPopupMenuItem(
              'analytics',
              Icons.analytics,
              'Analytics Dashboard',
              const Color(0xFF7C4DFF),
            ),
            _buildPopupMenuItem(
              'budget',
              Icons.savings,
              'Budget & Goals',
              const Color(0xFFFF9500),
            ),
            _buildPopupMenuItem(
              'insights',
              Icons.psychology,
              'AI Insights',
              const Color(0xFF00BFA6),
            ),
            _buildPopupMenuItem(
              'export',
              Icons.description,
              'Reports & Export',
              const Color(0xFF667EEA),
            ),
            _buildPopupMenuItem(
              'family',
              Icons.family_restroom,
              'Family Sharing',
              const Color(0xFFFF6B6B),
            ),
            const PopupMenuDivider(),
            _buildPopupMenuItem(
              'price-alerts',
              Icons.price_change,
              'Price Alerts & Deals',
              const Color(0xFF00BFA6),
            ),
            _buildPopupMenuItem(
              'compare',
              Icons.compare_arrows,
              'Compare & Alternatives',
              const Color(0xFF764BA2),
            ),
            _buildPopupMenuItem(
              'renewals',
              Icons.event_repeat,
              'Renewals & Cancel',
              const Color(0xFFFF8E53),
            ),
            _buildPopupMenuItem(
              'usage',
              Icons.bar_chart,
              'Usage Tracking',
              const Color(0xFF667EEA),
            ),
            const PopupMenuDivider(),
            _buildPopupMenuItem(
              'notifications',
              Icons.notifications_outlined,
              'Notifications',
              Colors.grey,
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
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
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: _subscriptionController.setSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search subscriptions...',
          prefixIcon: Icon(Icons.search, color: theme.hintColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.sort),
      tooltip: 'Sort',
      onSelected: (value) {
        _subscriptionController.setSortBy(value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'name', child: Text('Name')),
        const PopupMenuItem(value: 'amount', child: Text('Amount')),
        const PopupMenuItem(value: 'nextBilling', child: Text('Next Billing')),
        const PopupMenuItem(value: 'dateAdded', child: Text('Date Added')),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(
                1,
                Icons.calendar_month_outlined,
                Icons.calendar_month,
                'Calendar',
              ),
              const SizedBox(width: 56), // Space for FAB
              _buildNavItem(
                2,
                Icons.lightbulb_outline,
                Icons.lightbulb,
                'Insights',
              ),
              _buildNavItem(
                3,
                Icons.settings_outlined,
                Icons.settings,
                'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? theme.colorScheme.primary : theme.hintColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? theme.colorScheme.primary : theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _showAddOptions,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  void _showAddOptions() {
    HapticFeedback.mediumImpact();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Add Manually'),
              subtitle: const Text('Fill in subscription details'),
              onTap: () {
                Get.back();
                _addSubscription();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_search),
              title: const Text('Scan Screenshot'),
              subtitle: const Text('Extract details from image'),
              onTap: () {
                Get.back();
                _scanScreenshot();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _scanScreenshot() {
    OcrService.showOcrDialog(context);
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

  void _openNotifications() {
    HapticFeedback.lightImpact();
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed('/settings'),
                    child: const Text('Settings'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                final upcoming = _subscriptionController.upcomingSubscriptions;
                if (upcoming.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: Theme.of(context).hintColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No upcoming bills',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You\'re all caught up!',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: upcoming.length,
                  itemBuilder: (context, index) {
                    final sub = upcoming[index];
                    final daysUntil = sub.nextBillingDate
                        .difference(DateTime.now())
                        .inDays;
                    final isUrgent = daysUntil <= 3;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: isUrgent
                          ? Theme.of(
                              context,
                            ).colorScheme.errorContainer.withValues(alpha: 0.3)
                          : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _parseColor(sub.colorHex),
                          child: Text(
                            sub.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(sub.name),
                        subtitle: Text(
                          daysUntil == 0
                              ? 'Due today'
                              : daysUntil == 1
                              ? 'Due tomorrow'
                              : 'Due in $daysUntil days',
                          style: TextStyle(
                            color: isUrgent
                                ? Theme.of(context).colorScheme.error
                                : null,
                            fontWeight: isUrgent ? FontWeight.w600 : null,
                          ),
                        ),
                        trailing: Text(
                          '${sub.currency.symbol}${sub.amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Get.back();
                          _openDetail(sub);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null) return Theme.of(context).colorScheme.primary;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Theme.of(context).colorScheme.primary;
    }
  }

  void _filterByStatus(SubscriptionStatus status) {
    _subscriptionController.setStatusFilter(status);
  }

  void _showQuickActions(SubscriptionModel sub) {
    HapticFeedback.mediumImpact();
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            (sub.color ?? Theme.of(context).colorScheme.primary)
                                .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          sub.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color:
                                sub.color ??
                                Theme.of(context).colorScheme.primary,
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
                            sub.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${sub.currency.symbol}${sub.amount.toStringAsFixed(0)} / ${_getRecurrenceText(sub.recurrenceType)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              _buildQuickActionTile(Icons.edit_outlined, 'Edit', () {
                Get.back();
                Get.to(() => AddSubscriptionScreen(editSubscription: sub));
              }),
              if (sub.status == SubscriptionStatus.active)
                _buildQuickActionTile(Icons.pause_circle_outline, 'Pause', () {
                  Get.back();
                  _subscriptionController.pauseSubscription(sub.id);
                })
              else if (sub.status == SubscriptionStatus.paused)
                _buildQuickActionTile(Icons.play_circle_outline, 'Resume', () {
                  Get.back();
                  _subscriptionController.resumeSubscription(sub.id);
                }),
              _buildQuickActionTile(
                Icons.notifications_outlined,
                'Notification Settings',
                () {
                  Get.back();
                  _showNotificationSettings(sub);
                },
              ),
              _buildQuickActionTile(
                Icons.content_copy_outlined,
                'Duplicate',
                () {
                  Get.back();
                  _subscriptionController.duplicateSubscription(sub.id);
                },
              ),
              _buildQuickActionTile(Icons.delete_outline, 'Delete', () {
                Get.back();
                _confirmDelete(sub);
              }, color: Colors.red),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  void _confirmDelete(SubscriptionModel sub) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Subscription'),
        content: Text('Are you sure you want to delete "${sub.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _subscriptionController.deleteSubscription(sub.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(SubscriptionModel sub) {
    final reminderOptions = [1, 2, 3, 5, 7, 14, 30];
    final selectedDays = List<int>.from(sub.notificationPreference.daysBefore);
    var notificationsEnabled = sub.notificationPreference.enabled;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('${sub.name} Reminders'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text('Enable Reminders'),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                if (notificationsEnabled) ...[
                  const SizedBox(height: 16),
                  const Text('Notify me before billing date:'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: reminderOptions.map((days) {
                      final isSelected = selectedDays.contains(days);
                      return FilterChip(
                        label: Text('$days ${days == 1 ? 'day' : 'days'}'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedDays.add(days);
                            } else {
                              selectedDays.remove(days);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  selectedDays.sort();
                  final updated = sub.copyWith(
                    notificationPreference: NotificationPreference(
                      enabled: notificationsEnabled && selectedDays.isNotEmpty,
                      daysBefore: selectedDays,
                    ),
                  );
                  _subscriptionController.updateSubscription(updated);
                  Get.back();
                  Get.snackbar('Saved', 'Notification preferences updated');
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getRecurrenceText(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.daily:
        return 'day';
      case RecurrenceType.weekly:
        return 'week';
      case RecurrenceType.biWeekly:
        return '2 weeks';
      case RecurrenceType.monthly:
        return 'month';
      case RecurrenceType.biMonthly:
        return '2 months';
      case RecurrenceType.quarterly:
        return 'quarter';
      case RecurrenceType.semiAnnual:
        return '6 months';
      case RecurrenceType.annual:
        return 'year';
      case RecurrenceType.custom:
        return 'custom';
      case RecurrenceType.oneTime:
        return 'one-time';
    }
  }
}
