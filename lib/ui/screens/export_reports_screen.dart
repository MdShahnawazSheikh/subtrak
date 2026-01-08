import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/controllers/subscription_controller.dart';
import '../widgets/modern_ui_components.dart';

/// Export & Reports Screen - Modern Redesign
class ExportReportsScreen extends StatefulWidget {
  const ExportReportsScreen({super.key});

  @override
  State<ExportReportsScreen> createState() => _ExportReportsScreenState();
}

class _ExportReportsScreenState extends State<ExportReportsScreen> {
  final SubscriptionController _controller = Get.find();

  String _selectedFormat = 'PDF';
  String _selectedPeriod = 'Last 12 Months';
  bool _includeCharts = true;
  bool _includeBreakdown = true;
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildQuickExport(context)),
          SliverToBoxAdapter(child: _buildReportTemplates(context)),
          SliverToBoxAdapter(child: _buildExportOptions(context)),
          SliverToBoxAdapter(child: _buildRecentExports(context)),
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
        'Export & Reports',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildQuickExport(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AccentCard(
        accentColor: AppColors.accent,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    Icons.flash_on_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Export',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Export your data in one tap',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Format selection
            Row(
              children: [
                _FormatChip(
                  label: 'PDF',
                  icon: Icons.picture_as_pdf_rounded,
                  isSelected: _selectedFormat == 'PDF',
                  onTap: () => setState(() => _selectedFormat = 'PDF'),
                ),
                const SizedBox(width: 10),
                _FormatChip(
                  label: 'Excel',
                  icon: Icons.table_chart_rounded,
                  isSelected: _selectedFormat == 'Excel',
                  onTap: () => setState(() => _selectedFormat = 'Excel'),
                ),
                const SizedBox(width: 10),
                _FormatChip(
                  label: 'CSV',
                  icon: Icons.text_snippet_rounded,
                  isSelected: _selectedFormat == 'CSV',
                  onTap: () => setState(() => _selectedFormat = 'CSV'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isExporting ? null : () => _handleQuickExport(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isExporting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Export Now',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTemplates(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(
          title: 'Report Templates',
          subtitle: 'Pre-built reports for common needs',
        ),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _TemplateCard(
                title: 'Monthly Summary',
                subtitle: 'Spending overview',
                icon: Icons.calendar_month_rounded,
                color: AppColors.primary,
                onTap: () => _generateReport('monthly'),
              ),
              _TemplateCard(
                title: 'Annual Report',
                subtitle: 'Full year analysis',
                icon: Icons.analytics_rounded,
                color: AppColors.success,
                onTap: () => _generateReport('annual'),
              ),
              _TemplateCard(
                title: 'Tax Summary',
                subtitle: 'Deductible expenses',
                icon: Icons.receipt_long_rounded,
                color: AppColors.warning,
                onTap: () => _generateReport('tax'),
              ),
              _TemplateCard(
                title: 'Category Analysis',
                subtitle: 'Spending by type',
                icon: Icons.pie_chart_rounded,
                color: AppColors.secondary,
                onTap: () => _generateReport('category'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExportOptions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(title: 'Export Options'),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Period selection
              ActionTile(
                icon: Icons.date_range_rounded,
                title: 'Time Period',
                subtitle: _selectedPeriod,
                onTap: () => _showPeriodPicker(context),
              ),
              const ModernDivider(),
              // Include charts toggle
              ToggleTile(
                icon: Icons.bar_chart_rounded,
                title: 'Include Charts',
                subtitle: 'Visual graphs and charts',
                value: _includeCharts,
                onChanged: (v) => setState(() => _includeCharts = v),
              ),
              const ModernDivider(),
              // Include breakdown toggle
              ToggleTile(
                icon: Icons.list_alt_rounded,
                title: 'Detailed Breakdown',
                subtitle: 'Individual subscription details',
                value: _includeBreakdown,
                onChanged: (v) => setState(() => _includeBreakdown = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentExports(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(
          title: 'Recent Exports',
          subtitle: 'Your export history',
        ),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _ExportHistoryItem(
                title: 'Monthly Report - January 2025',
                subtitle: 'PDF • 2.4 MB',
                date: 'Jan 15, 2025',
                onTap: () => _viewExport('report1'),
                onShare: () => _shareExport('report1'),
              ),
              const ModernDivider(),
              _ExportHistoryItem(
                title: 'Q4 2024 Summary',
                subtitle: 'Excel • 1.8 MB',
                date: 'Dec 31, 2024',
                onTap: () => _viewExport('report2'),
                onShare: () => _shareExport('report2'),
              ),
              const ModernDivider(),
              _ExportHistoryItem(
                title: 'Subscription List',
                subtitle: 'CSV • 245 KB',
                date: 'Dec 20, 2024',
                onTap: () => _viewExport('report3'),
                onShare: () => _shareExport('report3'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleQuickExport() async {
    HapticFeedback.mediumImpact();
    setState(() => _isExporting = true);

    // Simulate export delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isExporting = false);

    Get.snackbar(
      'Export Complete',
      'Your $_selectedFormat file has been generated',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _generateReport(String type) {
    HapticFeedback.mediumImpact();
    Get.snackbar(
      'Generating Report',
      'Your ${type.capitalizeFirst} report is being created...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showPeriodPicker(BuildContext context) {
    final periods = [
      'Last 30 Days',
      'Last 3 Months',
      'Last 6 Months',
      'Last 12 Months',
      'This Year',
      'All Time',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select Time Period',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            ...periods.map(
              (period) => ListTile(
                title: Text(period),
                trailing: _selectedPeriod == period
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedPeriod = period);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _viewExport(String id) {
    HapticFeedback.lightImpact();
    Get.snackbar(
      'Opening Export',
      'Loading your exported file...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _shareExport(String id) {
    HapticFeedback.lightImpact();
    Get.snackbar(
      'Share',
      'Share options will appear here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _FormatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.accent : Colors.white,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.accent : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.title,
    required this.subtitle,
    required this.icon,
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
        width: 140,
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
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
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportHistoryItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final VoidCallback onTap;
  final VoidCallback onShare;

  const _ExportHistoryItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.onTap,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: AppColors.primary,
                size: 20,
              ),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        ' • $date',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined, size: 20),
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              onPressed: onShare,
            ),
          ],
        ),
      ),
    );
  }
}
