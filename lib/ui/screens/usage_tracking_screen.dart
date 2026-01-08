import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Usage Tracking Screen - Track actual usage of subscriptions
class UsageTrackingScreen extends StatefulWidget {
  const UsageTrackingScreen({super.key});

  @override
  State<UsageTrackingScreen> createState() => _UsageTrackingScreenState();
}

class _UsageTrackingScreenState extends State<UsageTrackingScreen> {
  String _selectedPeriod = 'month';

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
          SliverToBoxAdapter(child: _buildUsageOverview(context)),
          SliverToBoxAdapter(child: _buildPeriodSelector(context)),
          SliverToBoxAdapter(child: _buildValueAnalysis(context)),
          SliverToBoxAdapter(child: _buildUsageList(context)),
          SliverToBoxAdapter(child: _buildRecommendations(context)),
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
                  colors: [Color(0xFF667EEA), Color(0xFF00BFA6)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bar_chart, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            const Text(
              'Usage Tracking',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF667EEA).withOpacity(0.3),
                const Color(0xFF00BFA6).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsageOverview(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overall Value Score',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '78',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            '/100',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '+12%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
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
                Container(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: _ValueGaugePainter(value: 0.78),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 28),
                          Text(
                            'GREAT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOverviewStat('₹4.2/hr', 'Cost per Use'),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  _buildOverviewStat('156 hrs', 'Total Usage'),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  _buildOverviewStat('8/12', 'Active Subs'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final periods = [
      {'id': 'week', 'label': 'Week'},
      {'id': 'month', 'label': 'Month'},
      {'id': 'quarter', 'label': 'Quarter'},
      {'id': 'year', 'label': 'Year'},
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: periods.map((period) {
          final isSelected = _selectedPeriod == period['id'];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = period['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? const Color(0xFF374151) : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    period['label']!,
                    style: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.hintColor,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildValueAnalysis(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Value Analysis',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildValueCard(
                  context,
                  'Great Value',
                  '5 subs',
                  '₹2,140/mo',
                  Icons.thumb_up,
                  const Color(0xFF00BFA6),
                  0.75,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildValueCard(
                  context,
                  'Underused',
                  '4 subs',
                  '₹1,890/mo',
                  Icons.warning_amber,
                  const Color(0xFFFF9500),
                  0.35,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildValueCard(
                  context,
                  'Unused',
                  '3 subs',
                  '₹780/mo',
                  Icons.cancel,
                  const Color(0xFFFF6B6B),
                  0.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(
    BuildContext context,
    String title,
    String subtitle,
    String amount,
    IconData icon,
    Color color,
    double usageLevel,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usageLevel,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageList(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final usageData = [
      _UsageData(
        name: 'Netflix',
        icon: Icons.play_circle,
        color: const Color(0xFFE50914),
        hoursUsed: 45.5,
        sessionsCount: 28,
        costPerHour: 14.29,
        trend: 0.15,
        valueScore: 92,
      ),
      _UsageData(
        name: 'Spotify',
        icon: Icons.music_note,
        color: const Color(0xFF1DB954),
        hoursUsed: 82.3,
        sessionsCount: 124,
        costPerHour: 1.45,
        trend: 0.08,
        valueScore: 98,
      ),
      _UsageData(
        name: 'Adobe CC',
        icon: Icons.brush,
        color: const Color(0xFFFA0F00),
        hoursUsed: 28.0,
        sessionsCount: 15,
        costPerHour: 151.07,
        trend: -0.12,
        valueScore: 45,
      ),
      _UsageData(
        name: 'Disney+',
        icon: Icons.movie,
        color: const Color(0xFF113CCF),
        hoursUsed: 8.5,
        sessionsCount: 6,
        costPerHour: 35.18,
        trend: -0.25,
        valueScore: 28,
      ),
      _UsageData(
        name: 'YouTube Premium',
        icon: Icons.smart_display,
        color: const Color(0xFFFF0000),
        hoursUsed: 62.0,
        sessionsCount: 95,
        costPerHour: 2.08,
        trend: 0.22,
        valueScore: 95,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Usage Breakdown',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sort, size: 18),
                label: const Text('Sort'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...usageData.map((data) => _buildUsageItem(context, data)).toList(),
        ],
      ),
    );
  }

  Widget _buildUsageItem(BuildContext context, _UsageData data) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final valueColor = data.valueScore >= 70
        ? const Color(0xFF00BFA6)
        : data.valueScore >= 40
        ? const Color(0xFFFF9500)
        : const Color(0xFFFF6B6B);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: data.color,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: data.color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: valueColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  data.valueScore >= 70
                                      ? Icons.star
                                      : data.valueScore >= 40
                                      ? Icons.star_half
                                      : Icons.star_border,
                                  color: valueColor,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${data.valueScore}',
                                  style: TextStyle(
                                    color: valueColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: theme.hintColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${data.hoursUsed.toStringAsFixed(1)} hrs',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.play_arrow,
                            color: theme.hintColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${data.sessionsCount} sessions',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF374151) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildUsageStat(
                    '₹${data.costPerHour.toStringAsFixed(2)}',
                    'per hour',
                    data.costPerHour < 10
                        ? const Color(0xFF00BFA6)
                        : data.costPerHour < 50
                        ? const Color(0xFFFF9500)
                        : const Color(0xFFFF6B6B),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: isDark ? Colors.white10 : Colors.grey[300],
                  ),
                  _buildUsageStat(
                    '${(data.trend * 100).abs().toStringAsFixed(0)}%',
                    data.trend >= 0 ? 'more usage' : 'less usage',
                    data.trend >= 0
                        ? const Color(0xFF00BFA6)
                        : const Color(0xFFFF6B6B),
                    icon: data.trend >= 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageStat(
    String value,
    String label,
    Color color, {
    IconData? icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: color.withOpacity(0.7), fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecommendationCard(
            context,
            'Consider Cancelling Disney+',
            'You\'ve only used it 8.5 hours this month. Consider pausing to save ₹299/mo.',
            Icons.cancel_presentation,
            const Color(0xFFFF6B6B),
            'Pause',
          ),
          const SizedBox(height: 12),
          _buildRecommendationCard(
            context,
            'Adobe CC Underutilized',
            'At ₹151/hr, consider switching to Canva Pro (₹499/mo) for casual design work.',
            Icons.swap_horiz,
            const Color(0xFFFF9500),
            'Compare',
          ),
          const SizedBox(height: 12),
          _buildRecommendationCard(
            context,
            'Great Spotify Value! 🎉',
            'At just ₹1.45/hr, Spotify is your best value subscription. Keep it up!',
            Icons.thumb_up,
            const Color(0xFF00BFA6),
            null,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    String? actionLabel,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                    height: 1.4,
                  ),
                ),
                if (actionLabel != null) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(actionLabel),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Data class
class _UsageData {
  final String name;
  final IconData icon;
  final Color color;
  final double hoursUsed;
  final int sessionsCount;
  final double costPerHour;
  final double trend;
  final int valueScore;

  const _UsageData({
    required this.name,
    required this.icon,
    required this.color,
    required this.hoursUsed,
    required this.sessionsCount,
    required this.costPerHour,
    required this.trend,
    required this.valueScore,
  });
}

// Custom painter for value gauge
class _ValueGaugePainter extends CustomPainter {
  final double value;

  _ValueGaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.356, // Start angle (-135 degrees)
      4.712, // Sweep angle (270 degrees)
      false,
      bgPaint,
    );

    // Value arc
    final valuePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.356,
      4.712 * value,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
