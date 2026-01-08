import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/data/models/subscription_model.dart';

/// Premium Export & Reports Screen
class ExportReportsScreen extends StatefulWidget {
  const ExportReportsScreen({super.key});

  @override
  State<ExportReportsScreen> createState() => _ExportReportsScreenState();
}

class _ExportReportsScreenState extends State<ExportReportsScreen>
    with SingleTickerProviderStateMixin {
  final SubscriptionController _controller = Get.find();
  late TabController _tabController;

  String _selectedDateRange = 'Last 12 Months';
  String _selectedFormat = 'PDF';
  bool _includeCharts = true;
  bool _includeDetailedBreakdown = true;
  bool _includeRecommendations = true;
  bool _isGenerating = false;

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0F) : Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildQuickExport(context)),
          SliverToBoxAdapter(child: _buildReportTemplates(context)),
          SliverToBoxAdapter(child: _buildCustomReportBuilder(context)),
          SliverToBoxAdapter(child: _buildScheduledReports(context)),
          SliverToBoxAdapter(child: _buildExportHistory(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFA6), Color(0xFF00D4AA)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.description,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'Reports',
                style: TextStyle(fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00BFA6).withOpacity(0.3),
                const Color(0xFF667EEA).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickExport(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BFA6), Color(0xFF00D4AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BFA6).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 28,
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
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Export your subscription data instantly',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildQuickExportButton(
                    icon: Icons.picture_as_pdf,
                    label: 'PDF',
                    isSelected: _selectedFormat == 'PDF',
                    onTap: () => setState(() => _selectedFormat = 'PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickExportButton(
                    icon: Icons.table_chart,
                    label: 'Excel',
                    isSelected: _selectedFormat == 'Excel',
                    onTap: () => setState(() => _selectedFormat = 'Excel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickExportButton(
                    icon: Icons.code,
                    label: 'CSV',
                    isSelected: _selectedFormat == 'CSV',
                    onTap: () => setState(() => _selectedFormat = 'CSV'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickExportButton(
                    icon: Icons.data_object,
                    label: 'JSON',
                    isSelected: _selectedFormat == 'JSON',
                    onTap: () => setState(() => _selectedFormat = 'JSON'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _isGenerating ? null : () => _generateQuickExport(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isGenerating)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF00BFA6)),
                        ),
                      )
                    else
                      const Icon(
                        Icons.download,
                        color: Color(0xFF00BFA6),
                        size: 22,
                      ),
                    const SizedBox(width: 10),
                    Text(
                      _isGenerating ? 'Generating...' : 'Export Now',
                      style: const TextStyle(
                        color: Color(0xFF00BFA6),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickExportButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00BFA6) : Colors.white,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF00BFA6) : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTemplates(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final templates = [
      _ReportTemplate(
        id: 'monthly',
        title: 'Monthly Summary',
        description: 'Complete overview of this month\'s spending',
        icon: Icons.calendar_month,
        gradient: [const Color(0xFF7C4DFF), const Color(0xFF9C7DFF)],
        sections: ['Overview', 'Category Breakdown', 'Trends'],
      ),
      _ReportTemplate(
        id: 'annual',
        title: 'Annual Report',
        description: 'Comprehensive yearly financial analysis',
        icon: Icons.assessment,
        gradient: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
        sections: ['Year in Review', 'Comparisons', 'Insights', 'Predictions'],
      ),
      _ReportTemplate(
        id: 'tax',
        title: 'Tax Report',
        description: 'Subscription expenses for tax purposes',
        icon: Icons.receipt_long,
        gradient: [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
        sections: ['Deductible Expenses', 'Business vs Personal', 'Receipts'],
      ),
      _ReportTemplate(
        id: 'budget',
        title: 'Budget Analysis',
        description: 'Track spending against your budget goals',
        icon: Icons.account_balance_wallet,
        gradient: [const Color(0xFF00BFA6), const Color(0xFF00D4AA)],
        sections: ['Budget Status', 'Overages', 'Recommendations'],
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report Templates',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.9,
            ),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              return _buildTemplateCard(context, templates[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, _ReportTemplate template) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _generateReport(context, template),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: template.gradient[0].withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: template.gradient),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: template.gradient[0].withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(template.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              template.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                template.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.layers, color: template.gradient[0], size: 14),
                const SizedBox(width: 4),
                Text(
                  '${template.sections.length} sections',
                  style: TextStyle(
                    color: template.gradient[0],
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomReportBuilder(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.build, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Flexible(
                child: Text(
                  'Custom Report Builder',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Date Range Selector
          _buildOptionSection(
            context,
            title: 'Date Range',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildChip(
                  'Last 30 Days',
                  _selectedDateRange == 'Last 30 Days',
                  () => setState(() => _selectedDateRange = 'Last 30 Days'),
                ),
                _buildChip(
                  'Last 90 Days',
                  _selectedDateRange == 'Last 90 Days',
                  () => setState(() => _selectedDateRange = 'Last 90 Days'),
                ),
                _buildChip(
                  'Last 12 Months',
                  _selectedDateRange == 'Last 12 Months',
                  () => setState(() => _selectedDateRange = 'Last 12 Months'),
                ),
                _buildChip(
                  'Custom',
                  _selectedDateRange == 'Custom',
                  () => _showDatePicker(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Include Options
          _buildOptionSection(
            context,
            title: 'Include in Report',
            child: Column(
              children: [
                _buildToggleOption(
                  'Charts & Visualizations',
                  Icons.bar_chart,
                  _includeCharts,
                  (val) => setState(() => _includeCharts = val),
                ),
                _buildToggleOption(
                  'Detailed Breakdown',
                  Icons.list_alt,
                  _includeDetailedBreakdown,
                  (val) => setState(() => _includeDetailedBreakdown = val),
                ),
                _buildToggleOption(
                  'AI Recommendations',
                  Icons.lightbulb,
                  _includeRecommendations,
                  (val) => setState(() => _includeRecommendations = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _buildCustomReport(context),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Custom Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: const Color(0xFF667EEA).withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.hintColor,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF667EEA)
              : const Color(0xFF667EEA).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF667EEA),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.hintColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF667EEA),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledReports(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF9500).withOpacity(0.9),
            const Color(0xFFFF6B35).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9500).withOpacity(0.4),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scheduled Reports',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Automate your reporting workflow',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildScheduleItem(
            'Weekly Summary',
            'Every Monday at 9:00 AM',
            'Email',
            true,
          ),
          const SizedBox(height: 12),
          _buildScheduleItem(
            'Monthly Report',
            '1st of every month',
            'Email + Drive',
            true,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _addSchedule(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Add New Schedule',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    String name,
    String frequency,
    String delivery,
    bool isActive,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.white.withOpacity(0.7),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          frequency,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.send,
                          color: Colors.white.withOpacity(0.7),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          delivery,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isActive,
            onChanged: (val) {},
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildExportHistory(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final history = [
      _ExportItem(
        name: 'Monthly Summary - Jan 2025',
        format: 'PDF',
        date: 'Jan 31, 2025',
        size: '2.4 MB',
      ),
      _ExportItem(
        name: 'Annual Report 2024',
        format: 'PDF',
        date: 'Dec 31, 2024',
        size: '8.7 MB',
      ),
      _ExportItem(
        name: 'Subscriptions Export',
        format: 'CSV',
        date: 'Dec 15, 2024',
        size: '156 KB',
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Export History',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Clear All')),
            ],
          ),
          const SizedBox(height: 12),
          ...history.map((item) => _buildExportHistoryItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildExportHistoryItem(BuildContext context, _ExportItem item) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    IconData getFormatIcon(String format) {
      switch (format.toLowerCase()) {
        case 'pdf':
          return Icons.picture_as_pdf;
        case 'excel':
          return Icons.table_chart;
        case 'csv':
          return Icons.grid_on;
        case 'json':
          return Icons.data_object;
        default:
          return Icons.insert_drive_file;
      }
    }

    Color getFormatColor(String format) {
      switch (format.toLowerCase()) {
        case 'pdf':
          return const Color(0xFFFF6B6B);
        case 'excel':
          return const Color(0xFF00BFA6);
        case 'csv':
          return const Color(0xFF667EEA);
        case 'json':
          return const Color(0xFFFF9500);
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: getFormatColor(item.format).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              getFormatIcon(item.format),
              color: getFormatColor(item.format),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item.date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.hintColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      item.size,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _shareExport(item),
                icon: Icon(Icons.share, color: theme.hintColor, size: 20),
              ),
              IconButton(
                onPressed: () => _downloadExport(item),
                icon: const Icon(
                  Icons.download,
                  color: Color(0xFF00BFA6),
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Action methods
  void _generateQuickExport(BuildContext context) async {
    setState(() => _isGenerating = true);
    HapticFeedback.mediumImpact();

    // Simulate export generation
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isGenerating = false);
    Get.snackbar(
      'Export Complete! ✨',
      'Your $_selectedFormat file is ready to download',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00BFA6),
      colorText: Colors.white,
    );
  }

  void _generateReport(BuildContext context, _ReportTemplate template) {
    Get.snackbar(
      'Generating ${template.title}...',
      'Your report will be ready shortly',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _buildCustomReport(BuildContext context) {
    Get.snackbar(
      'Building Custom Report...',
      'With ${_includeCharts ? "charts, " : ""}${_includeDetailedBreakdown ? "breakdown, " : ""}${_includeRecommendations ? "recommendations" : ""}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showDatePicker(BuildContext context) {
    setState(() => _selectedDateRange = 'Custom');
    // TODO: Show date range picker
  }

  void _addSchedule(BuildContext context) {
    Get.snackbar(
      'Schedule Reports',
      'This feature is available in Pro version',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _shareExport(_ExportItem item) {
    Get.snackbar(
      'Sharing ${item.name}',
      'Opening share dialog...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _downloadExport(_ExportItem item) {
    Get.snackbar(
      'Downloaded!',
      '${item.name} saved to Downloads',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Data classes
class _ReportTemplate {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final List<String> sections;

  const _ReportTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.sections,
  });
}

class _ExportItem {
  final String name;
  final String format;
  final String date;
  final String size;

  const _ExportItem({
    required this.name,
    required this.format,
    required this.date,
    required this.size,
  });
}
