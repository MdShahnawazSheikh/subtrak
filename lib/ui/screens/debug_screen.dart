import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../app/services/debug_service.dart';
import '../../app/controllers/subscription_controller.dart';

/// Comprehensive Debug & Testing Screen
class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DebugService _debugService = Get.find<DebugService>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.bug_report,
                color: Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Debug Console'),
          ],
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(icon: Icon(Icons.data_array), text: 'Data'),
            Tab(icon: Icon(Icons.notifications), text: 'Notifications'),
            Tab(icon: Icon(Icons.speed), text: 'Tests'),
            Tab(icon: Icon(Icons.storage), text: 'Database'),
            Tab(icon: Icon(Icons.terminal), text: 'Logs'),
          ],
        ),
      ),
      body: Obx(
        () => Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                _buildDataTab(context),
                _buildNotificationsTab(context),
                _buildTestsTab(context),
                _buildDatabaseTab(context),
                _buildLogsTab(context),
              ],
            ),
            if (_debugService.isLoading.value)
              Container(
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DATA TAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildDataTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          'Sample Data Generation',
          Icons.add_circle,
          Colors.green,
        ),
        const SizedBox(height: 12),

        _buildActionCard(
          context,
          title: 'Generate 5 Subscriptions',
          subtitle: 'Quick test data',
          icon: Icons.add_box,
          color: Colors.green,
          onTap: () => _debugService.generateSampleSubscriptions(count: 5),
        ),

        _buildActionCard(
          context,
          title: 'Generate 15 Subscriptions',
          subtitle: 'Medium test data set',
          icon: Icons.playlist_add,
          color: Colors.blue,
          onTap: () => _debugService.generateSampleSubscriptions(count: 15),
        ),

        _buildActionCard(
          context,
          title: 'Generate 50 Subscriptions',
          subtitle: 'Large test data for stress testing',
          icon: Icons.library_add,
          color: Colors.purple,
          onTap: () => _debugService.generateSampleSubscriptions(count: 50),
        ),

        const SizedBox(height: 24),
        _buildSectionHeader('Data Cleanup', Icons.delete_sweep, Colors.red),
        const SizedBox(height: 12),

        _buildActionCard(
          context,
          title: 'Clear Debug Subscriptions',
          subtitle: 'Remove only debug-generated data',
          icon: Icons.cleaning_services,
          color: Colors.orange,
          onTap: () => _showConfirmDialog(
            context,
            'Clear Debug Data?',
            'This will delete all debug-generated subscriptions.',
            () => _debugService.clearDebugSubscriptions(),
          ),
        ),

        _buildActionCard(
          context,
          title: 'Clear ALL Subscriptions',
          subtitle: '⚠️ Deletes everything - use with caution!',
          icon: Icons.delete_forever,
          color: Colors.red,
          onTap: () => _showConfirmDialog(
            context,
            'DELETE ALL DATA?',
            'This will permanently delete ALL subscriptions. This cannot be undone!',
            () => _debugService.clearAllSubscriptions(),
          ),
        ),

        const SizedBox(height: 24),
        _buildSectionHeader('Insights', Icons.lightbulb, Colors.amber),
        const SizedBox(height: 12),

        _buildActionCard(
          context,
          title: 'Generate Sample Insights',
          subtitle: 'Create AI insight examples',
          icon: Icons.auto_awesome,
          color: Colors.amber,
          onTap: () => _debugService.generateSampleInsights(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTIFICATIONS TAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildNotificationsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          'Test Notifications',
          Icons.notifications_active,
          Colors.blue,
        ),
        const SizedBox(height: 12),

        _buildActionCard(
          context,
          title: 'Send Instant Notification',
          subtitle: 'Test notification appears immediately',
          icon: Icons.flash_on,
          color: Colors.blue,
          onTap: () => _debugService.testInstantNotification(),
        ),

        _buildActionCard(
          context,
          title: 'Schedule Test Notification',
          subtitle: 'Notification in ~1 minute',
          icon: Icons.schedule,
          color: Colors.indigo,
          onTap: () => _debugService.testScheduledNotification(),
        ),

        const SizedBox(height: 24),
        _buildSectionHeader(
          'Notification Management',
          Icons.manage_history,
          Colors.teal,
        ),
        const SizedBox(height: 12),

        _buildActionCard(
          context,
          title: 'View Pending Notifications',
          subtitle: 'Show all scheduled notifications',
          icon: Icons.pending_actions,
          color: Colors.teal,
          onTap: () async {
            final pending = await _debugService.getPendingNotifications();
            if (context.mounted) {
              _showInfoDialog(
                context,
                'Pending Notifications (${pending.length})',
                pending.isEmpty
                    ? 'No pending notifications'
                    : pending.map((n) => '• ${n.title}').join('\n'),
              );
            }
          },
        ),

        _buildActionCard(
          context,
          title: 'Schedule All Bill Reminders',
          subtitle: 'Create notifications for upcoming bills',
          icon: Icons.event_available,
          color: Colors.green,
          onTap: () => _debugService.scheduleUpcomingBillNotifications(),
        ),

        _buildActionCard(
          context,
          title: 'Cancel All Notifications',
          subtitle: 'Clear all pending notifications',
          icon: Icons.notifications_off,
          color: Colors.red,
          onTap: () => _showConfirmDialog(
            context,
            'Cancel All Notifications?',
            'This will cancel all scheduled notifications.',
            () => _debugService.cancelAllNotifications(),
          ),
        ),

        const SizedBox(height: 24),
        _buildNotificationChannelInfo(context),
      ],
    );
  }

  Widget _buildNotificationChannelInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Notification Channels',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildChannelRow(
            'bill_reminders',
            'Bill Reminders',
            'Upcoming bill alerts',
          ),
          _buildChannelRow('debug_channel', 'Debug', 'Test notifications'),
          _buildChannelRow(
            'price_alerts',
            'Price Alerts',
            'Price change notifications',
          ),
        ],
      ),
    );
  }

  Widget _buildChannelRow(String id, String name, String description) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            id,
            style: theme.textTheme.labelSmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TESTS TAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTestsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Feature Tests', Icons.checklist, Colors.green),
        const SizedBox(height: 12),

        _buildActionCard(
          context,
          title: 'Test All Premium Features',
          subtitle: 'Verify analytics, insights, notifications',
          icon: Icons.verified,
          color: Colors.green,
          onTap: () async {
            final results = await _debugService.testPremiumFeatures();
            if (context.mounted) {
              final passed = results.values.where((v) => v).length;
              _showInfoDialog(
                context,
                'Feature Test Results ($passed/${results.length})',
                results.entries
                    .map((e) => '${e.value ? "✅" : "❌"} ${e.key}')
                    .join('\n'),
              );
            }
          },
        ),

        _buildActionCard(
          context,
          title: 'Validate Data Integrity',
          subtitle: 'Check for data inconsistencies',
          icon: Icons.fact_check,
          color: Colors.blue,
          onTap: () async {
            final issues = await _debugService.validateDataIntegrity();
            if (context.mounted) {
              final total = issues.values.fold<int>(0, (a, b) => a + b);
              _showInfoDialog(
                context,
                total == 0 ? 'Data Valid ✅' : 'Issues Found: $total',
                issues.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
              );
            }
          },
        ),

        const SizedBox(height: 24),
        _buildSectionHeader('Stress Tests', Icons.speed, Colors.orange),
        const SizedBox(height: 12),

        _buildActionCard(
          context,
          title: 'Run Stress Test (100 items)',
          subtitle: 'Test app performance with large dataset',
          icon: Icons.trending_up,
          color: Colors.orange,
          onTap: () => _showConfirmDialog(
            context,
            'Run Stress Test?',
            'This will generate 100 subscriptions to test performance.',
            () => _debugService.runStressTest(count: 100),
          ),
        ),

        const SizedBox(height: 24),
        _buildSectionHeader(
          'Navigation Tests',
          Icons.navigation,
          Colors.purple,
        ),
        const SizedBox(height: 12),

        _buildNavigationTestGrid(context),
      ],
    );
  }

  Widget _buildNavigationTestGrid(BuildContext context) {
    final routes = [
      {'name': 'Home', 'route': '/home', 'icon': Icons.home},
      {'name': 'Calendar', 'route': '/calendar', 'icon': Icons.calendar_today},
      {'name': 'Insights', 'route': '/insights', 'icon': Icons.insights},
      {'name': 'Settings', 'route': '/settings', 'icon': Icons.settings},
      {'name': 'Analytics', 'route': '/analytics', 'icon': Icons.analytics},
      {'name': 'Budget', 'route': '/budget-goals', 'icon': Icons.savings},
      {
        'name': 'AI Insights',
        'route': '/ai-insights',
        'icon': Icons.auto_awesome,
      },
      {'name': 'Export', 'route': '/export', 'icon': Icons.file_download},
      {
        'name': 'Family',
        'route': '/family-sharing',
        'icon': Icons.family_restroom,
      },
      {
        'name': 'Alerts',
        'route': '/price-alerts',
        'icon': Icons.notifications_active,
      },
      {'name': 'Compare', 'route': '/compare', 'icon': Icons.compare_arrows},
      {'name': 'Renewals', 'route': '/renewals', 'icon': Icons.event_repeat},
      {'name': 'Usage', 'route': '/usage-tracking', 'icon': Icons.pie_chart},
      {'name': 'Themes', 'route': '/themes', 'icon': Icons.palette},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return _buildNavButton(
          context,
          route['name'] as String,
          route['route'] as String,
          route['icon'] as IconData,
        );
      },
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String name,
    String route,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        _debugService.log('Navigate: $route');
        Get.toNamed(route);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: theme.colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              name,
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DATABASE TAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildDatabaseTab(BuildContext context) {
    final controller = Get.find<SubscriptionController>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Database Stats', Icons.storage, Colors.indigo),
        const SizedBox(height: 12),

        _buildActionCard(
          context,
          title: 'Refresh Database Stats',
          subtitle: 'Get current database statistics',
          icon: Icons.refresh,
          color: Colors.indigo,
          onTap: () async {
            final stats = await _debugService.getDatabaseStats();
            if (context.mounted) {
              _showInfoDialog(
                context,
                'Database Statistics',
                stats.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
              );
            }
          },
        ),

        const SizedBox(height: 16),
        _buildStatsCard(context, controller),

        const SizedBox(height: 24),
        _buildSectionHeader('Export', Icons.upload, Colors.teal),
        const SizedBox(height: 12),

        _buildActionCard(
          context,
          title: 'Export Debug State',
          subtitle: 'Copy app state to clipboard',
          icon: Icons.content_copy,
          color: Colors.teal,
          onTap: () async {
            final state = await _debugService.exportDebugState();
            final json = const JsonEncoder.withIndent('  ').convert(state);
            await Clipboard.setData(ClipboardData(text: json));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Debug state copied to clipboard'),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    SubscriptionController controller,
  ) {
    final theme = Theme.of(context);

    return Obx(() {
      final stats = controller.subscriptionStats;
      final summary = controller.summary.value;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Statistics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              'Total Subscriptions',
              '${stats['total'] ?? 0}',
              Icons.list,
            ),
            _buildStatRow(
              'Active',
              '${stats['active'] ?? 0}',
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatRow(
              'Paused',
              '${stats['paused'] ?? 0}',
              Icons.pause_circle,
              Colors.orange,
            ),
            _buildStatRow(
              'Trials',
              '${stats['trials'] ?? 0}',
              Icons.hourglass_empty,
              Colors.blue,
            ),
            _buildStatRow(
              'Cancelled',
              '${stats['cancelled'] ?? 0}',
              Icons.cancel,
              Colors.red,
            ),
            const Divider(height: 24),
            _buildStatRow(
              'Monthly Spend',
              '₹${summary.totalMonthly.toStringAsFixed(0)}',
              Icons.attach_money,
              Colors.green,
            ),
            _buildStatRow(
              'Annual Spend',
              '₹${summary.totalYearly.toStringAsFixed(0)}',
              Icons.savings,
              Colors.blue,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatRow(
    String label,
    String value,
    IconData icon, [
    Color? color,
  ]) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: color ?? theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOGS TAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLogsTab(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.terminal, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  'Debug Logs (${_debugService.logs.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _debugService.clearLogs(),
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Clear'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () async {
                  final logs = _debugService.logs.join('\n');
                  await Clipboard.setData(ClipboardData(text: logs));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logs copied to clipboard')),
                    );
                  }
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Copy'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(
            () => _debugService.logs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.terminal,
                          size: 64,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No logs yet',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Run some debug actions to see logs here',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _debugService.logs.length,
                    itemBuilder: (context, index) {
                      final log = _debugService.logs[index];
                      final isError = log.contains('❌');
                      final isSuccess = log.contains('✅');
                      final isWarning = log.contains('⚠️');

                      Color? textColor;
                      if (isError) textColor = Colors.red;
                      if (isSuccess) textColor = Colors.green;
                      if (isWarning) textColor = Colors.orange;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (textColor ?? theme.colorScheme.primary)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          log,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color:
                                textColor ??
                                theme.colorScheme.onSurface.withValues(
                                  alpha: 0.8,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER WIDGETS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
