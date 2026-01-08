import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/data/models/user_settings_model.dart';
import '../../app/controllers/settings_controller.dart';
import '../widgets/premium_components.dart';
import '../themes/app_themes.dart';
import 'help_screen.dart';
import 'rules_screen.dart';
import 'audit_log_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        final settings = _controller.settings.value;
        if (settings == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            // Pro upgrade banner
            if (settings.tier == UserTier.free) _buildUpgradeBanner(context),

            // Appearance section
            _buildSectionHeader(context, 'Appearance'),
            _buildThemeSelectorTile(context),
            _buildSettingsTile(
              context,
              icon: Icons.currency_exchange_outlined,
              title: 'Currency',
              subtitle: settings.defaultCurrency,
              onTap: () => _showCurrencyPicker(context),
            ),

            // Notifications section
            _buildSectionHeader(context, 'Notifications'),
            _buildSwitchTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'Bill Reminders',
              subtitle: 'Get notified before bills are due',
              value: settings.notifications.billReminders,
              onChanged: (value) => _controller.toggleBillReminders(value),
            ),
            _buildSwitchTile(
              context,
              icon: Icons.lightbulb_outline,
              title: 'Smart Insights',
              subtitle: 'Receive savings suggestions',
              value: settings.notifications.insightAlerts,
              onChanged: (value) => _controller.toggleInsightAlerts(value),
            ),
            _buildSwitchTile(
              context,
              icon: Icons.trending_up_outlined,
              title: 'Price Change Alerts',
              subtitle: 'Get notified when prices change',
              value: settings.notifications.priceChangeAlerts,
              onChanged: (value) => _controller.togglePriceAlerts(value),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.access_time_outlined,
              title: 'Quiet Hours',
              subtitle: settings.notifications.quietHoursEnabled
                  ? '${settings.notifications.quietHoursStart} - ${settings.notifications.quietHoursEnd}'
                  : 'Disabled',
              onTap: () => _showQuietHoursPicker(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.calendar_today_outlined,
              title: 'Default Reminder Days',
              subtitle:
                  settings.notifications.defaultReminderDays.join(', ') +
                  ' days before',
              onTap: () => _showReminderDaysPicker(context),
            ),

            // Budget section
            _buildSectionHeader(context, 'Budget'),
            _buildSettingsTile(
              context,
              icon: Icons.account_balance_wallet_outlined,
              title: 'Monthly Budget',
              subtitle: settings.budget.monthlyLimit != null
                  ? '₹${settings.budget.monthlyLimit!.toStringAsFixed(0)}'
                  : 'Not set',
              onTap: () => _showBudgetEditor(context),
            ),
            _buildSwitchTile(
              context,
              icon: Icons.warning_outlined,
              title: 'Budget Alerts',
              subtitle: 'Warn when approaching budget limit',
              value: settings.budget.alertsEnabled,
              onChanged: (value) => _controller.toggleBudgetAlerts(value),
            ),

            // Privacy section
            _buildSectionHeader(context, 'Privacy & Security'),
            _buildSwitchTile(
              context,
              icon: Icons.fingerprint,
              title: 'Biometric Lock',
              subtitle: 'Require fingerprint or face to open',
              value: settings.privacy.biometricLock,
              onChanged: (value) => _controller.toggleBiometricLock(value),
            ),
            _buildSwitchTile(
              context,
              icon: Icons.analytics_outlined,
              title: 'Anonymous Analytics',
              subtitle: 'Help improve the app',
              value: settings.privacy.analyticsEnabled,
              onChanged: (value) => _controller.toggleAnalytics(value),
            ),
            _buildSwitchTile(
              context,
              icon: Icons.cloud_upload_outlined,
              title: 'Cloud Backup',
              subtitle: 'Backup data to cloud',
              value: settings.privacy.cloudBackup,
              onChanged: (value) => _controller.toggleCloudBackup(value),
            ),

            // Data section
            _buildSectionHeader(context, 'Data'),
            _buildSettingsTile(
              context,
              icon: Icons.rule_outlined,
              title: 'Smart Rules',
              subtitle: 'Automate subscription monitoring',
              onTap: () => _openSmartRules(),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.history,
              title: 'Audit Log',
              subtitle: 'View change history and rollback',
              onTap: () => _openAuditLog(),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.file_download_outlined,
              title: 'Export Data',
              subtitle: 'Download your data as JSON or CSV',
              onTap: () => _showExportOptions(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.file_upload_outlined,
              title: 'Import Data',
              subtitle: 'Import from backup or other apps',
              onTap: () => _showImportOptions(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.delete_outline,
              title: 'Clear All Data',
              subtitle: 'Delete all subscriptions and settings',
              textColor: Colors.red,
              onTap: () => _confirmClearData(context),
            ),

            // About section
            _buildSectionHeader(context, 'About'),
            _buildSettingsTile(
              context,
              icon: Icons.star_outline,
              title: 'Rate the App',
              subtitle: 'Help us by leaving a review',
              onTap: () => _rateApp(),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.share_outlined,
              title: 'Share SubTrak',
              subtitle: 'Tell your friends about us',
              onTap: () => _shareApp(),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'FAQs and contact support',
              onTap: () => _openHelp(),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => _openPrivacyPolicy(),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () => _openTerms(),
            ),

            // Developer section
            _buildSectionHeader(context, 'Developer'),
            _buildSettingsTile(
              context,
              icon: Icons.bug_report_outlined,
              title: 'Debug Console',
              subtitle: 'Testing tools & sample data',
              onTap: () => Get.toNamed('/debug'),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('SubTrak v1.0.0', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    'Made with ❤️ in India',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        );
      }),
    );
  }

  Widget _buildUpgradeBanner(BuildContext context) {
    return GradientCard(
      colors: const [Color(0xFF7C4DFF), Color(0xFF00BFA6)],
      margin: const EdgeInsets.all(16),
      onTap: () => _showUpgradeSheet(context),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upgrade to Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Unlock unlimited subscriptions & insights',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: textColor ?? theme.iconTheme.color),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: textColor?.withOpacity(0.7),
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: (newValue) {
        HapticFeedback.lightImpact();
        onChanged(newValue);
      },
    );
  }

  Widget _buildThemeSelectorTile(BuildContext context) {
    final theme = Theme.of(context);
    final currentTheme = _controller.currentTheme;
    final metadata = AppThemes.themeMetadata[currentTheme]!;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.toNamed('/themes');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Theme preview circles
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: metadata.previewColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: metadata.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.palette_rounded,
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
                    'Theme',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        metadata.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: metadata.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...metadata.previewColors.take(3).map((color) {
                        return Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    final currencies = [
      {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
      {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
      {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
      {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
      {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
      {'code': 'AUD', 'symbol': 'A\$', 'name': 'Australian Dollar'},
      {'code': 'CAD', 'symbol': 'C\$', 'name': 'Canadian Dollar'},
    ];

    Get.bottomSheet(
      Container(
        height: 400,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Select Currency',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected =
                      _controller.settings.value?.defaultCurrency ==
                      currency['code'];

                  return ListTile(
                    leading: Text(
                      currency['symbol']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    title: Text(currency['name']!),
                    subtitle: Text(currency['code']!),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      _controller.setCurrency(currency['code']!);
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuietHoursPicker(BuildContext context) {
    final theme = Theme.of(context);
    final settings = _controller.settings.value!;
    TimeOfDay startTime = TimeOfDay(
      hour: settings.notifications.quietHoursStart,
      minute: 0,
    );
    TimeOfDay endTime = TimeOfDay(
      hour: settings.notifications.quietHoursEnd,
      minute: 0,
    );
    bool enabled = settings.notifications.quietHoursEnabled;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setLocalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiet Hours',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Notifications will be silenced during this time',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Enable Quiet Hours'),
                  value: enabled,
                  onChanged: (value) => setLocalState(() => enabled = value),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _TimePickerTile(
                        label: 'Start',
                        time: startTime,
                        enabled: enabled,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: startTime,
                          );
                          if (picked != null) {
                            setLocalState(() => startTime = picked);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _TimePickerTile(
                        label: 'End',
                        time: endTime,
                        enabled: enabled,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: endTime,
                          );
                          if (picked != null) {
                            setLocalState(() => endTime = picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      _controller.setQuietHours(
                        enabled: enabled,
                        start:
                            '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
                        end:
                            '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
                      );
                      Get.back();
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showReminderDaysPicker(BuildContext context) {
    final theme = Theme.of(context);
    final settings = _controller.settings.value!;
    List<int> selectedDays = List.from(
      settings.notifications.defaultReminderDays,
    );
    final availableDays = [1, 2, 3, 5, 7, 14, 30];

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setLocalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Default Reminder Days',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get reminded this many days before a bill is due',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableDays.map((day) {
                    final isSelected = selectedDays.contains(day);
                    return FilterChip(
                      label: Text('$day day${day == 1 ? '' : 's'}'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setLocalState(() {
                          if (selected) {
                            selectedDays.add(day);
                          } else {
                            selectedDays.remove(day);
                          }
                          selectedDays.sort((a, b) => b.compareTo(a));
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: selectedDays.isEmpty
                        ? null
                        : () {
                            _controller.setDefaultReminderDays(selectedDays);
                            Get.back();
                          },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBudgetEditor(BuildContext context) {
    final controller = TextEditingController(
      text: _controller.settings.value?.budget.monthlyLimit?.toString() ?? '',
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixText: '₹ ',
            hintText: 'Enter amount',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null) {
                _controller.setBudgetLimit(amount);
              }
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Data',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Export as JSON'),
              subtitle: const Text('Full backup with all data'),
              onTap: () async {
                Get.back();
                await _controller.exportData(format: 'json');
                Get.snackbar('Success', 'Data exported as JSON');
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: const Text('Export as CSV'),
              subtitle: const Text('Spreadsheet compatible'),
              onTap: () async {
                Get.back();
                await _controller.exportData(format: 'csv');
                Get.snackbar('Success', 'Data exported as CSV');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showImportOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Import Data',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Restore from Backup'),
              subtitle: const Text('Import a SubTrak JSON backup'),
              onTap: () async {
                Get.back();
                await _controller.importData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Import from Bank Statement'),
              subtitle: const Text('Detect subscriptions from transactions'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Coming Soon',
                  'Bank statement import will be available soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _confirmClearData(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your subscriptions and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              await _controller.clearAllData();
              Get.snackbar('Data Cleared', 'All data has been deleted');
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpgradeSheet(BuildContext context) {
    final theme = Theme.of(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF00BFA6)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'SubTrak Pro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock the full power of subscription tracking',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildProFeature(
              context,
              Icons.all_inclusive,
              'Unlimited subscriptions',
            ),
            _buildProFeature(context, Icons.lightbulb, 'Advanced insights'),
            _buildProFeature(context, Icons.cloud, 'Cloud backup'),
            _buildProFeature(context, Icons.palette, 'Premium themes'),
            _buildProFeature(context, Icons.block, 'No ads'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Get.back();
                  _controller.upgradeToPro();
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '₹199/year',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Get.back();
                _controller.upgradeToLifetime();
              },
              child: const Text('Or get lifetime access for ₹499'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildProFeature(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00BFA6), size: 20),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  void _rateApp() async {
    // Open Play Store for rating
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.example.subtrak';
    final uri = Uri.parse(playStoreUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Thank You!',
        'We appreciate your support',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _shareApp() {
    _controller.shareApp();
  }

  void _openHelp() {
    Get.to(() => const HelpScreen());
  }

  void _openSmartRules() {
    Get.to(() => const RulesScreen());
  }

  void _openAuditLog() {
    Get.to(() => const AuditLogScreen());
  }

  void _openPrivacyPolicy() {
    Get.toNamed('/privacy');
  }

  void _openTerms() {
    Get.toNamed('/terms');
  }
}

class _TimePickerTile extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final bool enabled;
  final VoidCallback onTap;

  const _TimePickerTile({
    required this.label,
    required this.time,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enabled
              ? theme.colorScheme.surfaceContainerHighest
              : theme.disabledColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: enabled ? theme.hintColor : theme.disabledColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time.format(context),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: enabled ? null : theme.disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
