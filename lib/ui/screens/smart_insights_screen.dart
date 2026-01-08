import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../app/controllers/subscription_controller.dart';
import '../../app/data/models/subscription_model.dart';

/// Smart AI-Powered Insights Screen
class SmartInsightsScreen extends StatefulWidget {
  const SmartInsightsScreen({super.key});

  @override
  State<SmartInsightsScreen> createState() => _SmartInsightsScreenState();
}

class _SmartInsightsScreenState extends State<SmartInsightsScreen>
    with TickerProviderStateMixin {
  final SubscriptionController _controller = Get.find();
  late AnimationController _pulseController;
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
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
          SliverToBoxAdapter(child: _buildAIScoreCard(context)),
          SliverToBoxAdapter(child: _buildQuickActions(context)),
          SliverToBoxAdapter(child: _buildSmartRecommendations(context)),
          SliverToBoxAdapter(child: _buildSpendingPatterns(context)),
          SliverToBoxAdapter(child: _buildOptimizationOpportunities(context)),
          SliverToBoxAdapter(child: _buildPredictiveAlerts(context)),
          SliverToBoxAdapter(child: _buildUsageAnalysis(context)),
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
                  colors: [Color(0xFF7C4DFF), Color(0xFF00BFA6)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'AI Insights',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7C4DFF).withOpacity(0.3),
                const Color(0xFF00BFA6).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF7C4DFF,
                      ).withOpacity(0.3 * _pulseController.value),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(Icons.refresh, size: 20),
              );
            },
          ),
          onPressed: () => _refreshInsights(),
        ),
      ],
    );
  }

  Widget _buildAIScoreCard(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final subs = _controller.filteredSubscriptions;
      final active = subs
          .where((s) => s.status == SubscriptionStatus.active)
          .length;
      final total = subs.length;

      // Calculate AI health score
      int healthScore = _calculateHealthScore(subs);

      return Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C4DFF).withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated gradient overlay
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _scanController,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: CustomPaint(
                      painter: _ScanLinePainter(
                        progress: _scanController.value,
                        color: const Color(0xFF00BFA6),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C4DFF), Color(0xFF9C7DFF)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C4DFF).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.psychology,
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
                              'AI Financial Health',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Based on $active active subscriptions',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Animated score gauge
                  SizedBox(
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(200, 200),
                              painter: _AIScoreGaugePainter(
                                score: healthScore,
                                pulseValue: _pulseController.value,
                              ),
                            );
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              healthScore.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 56,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getScoreColor(
                                  healthScore,
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getScoreLabel(healthScore),
                                style: TextStyle(
                                  color: _getScoreColor(healthScore),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Score factors
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreFactor(
                          'Budget',
                          '+15',
                          Icons.trending_down,
                          Colors.green,
                        ),
                        _buildScoreFactor(
                          'Usage',
                          '-8',
                          Icons.bar_chart,
                          Colors.orange,
                        ),
                        _buildScoreFactor(
                          'Diversity',
                          '+12',
                          Icons.category,
                          Colors.blue,
                        ),
                        _buildScoreFactor(
                          'Overlap',
                          '-5',
                          Icons.copy_all,
                          Colors.red,
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

  Widget _buildScoreFactor(
    String label,
    String impact,
    IconData icon,
    Color color,
  ) {
    final isPositive = impact.startsWith('+');
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          impact,
          style: TextStyle(
            color: isPositive ? Colors.green : Colors.red,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final actions = [
      _QuickAction(
        icon: Icons.auto_fix_high,
        label: 'Auto-Optimize',
        color: const Color(0xFF7C4DFF),
        onTap: () => _showOptimizationSheet(context),
      ),
      _QuickAction(
        icon: Icons.find_replace,
        label: 'Find Duplicates',
        color: const Color(0xFFFF6B6B),
        onTap: () => _findDuplicates(context),
      ),
      _QuickAction(
        icon: Icons.price_check,
        label: 'Price Compare',
        color: const Color(0xFF00BFA6),
        onTap: () => _compareprices(context),
      ),
      _QuickAction(
        icon: Icons.schedule,
        label: 'Optimize Billing',
        color: const Color(0xFFFF9500),
        onTap: () => _optimizeBilling(context),
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actions.map((action) {
              return GestureDetector(
                onTap: action.onTap,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 56) / 4,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F2937) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: action.color.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: action.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(action.icon, color: action.color, size: 24),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        action.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartRecommendations(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final recommendations = [
      _Recommendation(
        title: 'Cancel Unused Subscriptions',
        description:
            'Adobe Creative Cloud hasn\'t been used in 45 days. You could save ₹4,230/month.',
        icon: Icons.cancel_outlined,
        color: const Color(0xFFFF6B6B),
        savingsAmount: 4230,
        priority: 'High',
        actionLabel: 'Review',
      ),
      _Recommendation(
        title: 'Switch to Annual Billing',
        description:
            'Switch Spotify & Netflix to annual plans and save ₹1,440/year.',
        icon: Icons.calendar_today,
        color: const Color(0xFF00BFA6),
        savingsAmount: 1440,
        priority: 'Medium',
        actionLabel: 'Compare',
      ),
      _Recommendation(
        title: 'Bundle Opportunity',
        description:
            'Disney+ & Hotstar can be bundled for ₹299/month instead of ₹499.',
        icon: Icons.inventory_2,
        color: const Color(0xFF7C4DFF),
        savingsAmount: 200,
        priority: 'Low',
        actionLabel: 'Learn More',
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
              Flexible(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C4DFF), Color(0xFF00BFA6)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.lightbulb,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Smart Recommendations',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFA6).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '₹5,870 savings',
                    style: TextStyle(
                      color: Color(0xFF00BFA6),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recommendations.map(
            (rec) => _buildRecommendationCard(context, rec),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, _Recommendation rec) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: rec.color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: rec.color.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: rec.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(rec.icon, color: rec.color, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              rec.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(
                                rec.priority,
                              ).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              rec.priority,
                              style: TextStyle(
                                color: _getPriorityColor(rec.priority),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        rec.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: rec.color.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(Icons.savings, color: rec.color, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Save ₹${rec.savingsAmount}/mo',
                          style: TextStyle(
                            color: rec.color,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rec.color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    rec.actionLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingPatterns(BuildContext context) {
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
                  color: const Color(0xFF667EEA).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.insights,
                  color: Color(0xFF667EEA),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Spending Patterns',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Weekly spending pattern chart
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDayBar(context, 'Mon', 0.4, false),
                _buildDayBar(context, 'Tue', 0.6, false),
                _buildDayBar(context, 'Wed', 0.3, false),
                _buildDayBar(context, 'Thu', 0.8, true),
                _buildDayBar(context, 'Fri', 0.5, false),
                _buildDayBar(context, 'Sat', 0.7, false),
                _buildDayBar(context, 'Sun', 0.4, false),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Pattern insights
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF667EEA),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Most bills are charged on Thursdays. Consider spreading payments.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF667EEA),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBar(
    BuildContext context,
    String day,
    double value,
    bool isHighest,
  ) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isHighest)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Peak',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 30,
          height: 120 * value,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isHighest
                  ? [const Color(0xFF667EEA), const Color(0xFF764BA2)]
                  : [
                      const Color(0xFF667EEA).withOpacity(0.6),
                      const Color(0xFF764BA2).withOpacity(0.6),
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isHighest ? FontWeight.w700 : FontWeight.w500,
            color: isHighest ? const Color(0xFF667EEA) : theme.hintColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOptimizationOpportunities(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Optimization Opportunities',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildOpportunityCard(
            context,
            icon: Icons.family_restroom,
            title: 'Family Plan Available',
            description:
                'Add 5 more members to your Spotify for only ₹50 extra/month each',
            gradient: [const Color(0xFF1DB954), const Color(0xFF1ED760)],
            savings: '₹840/year',
          ),
          const SizedBox(height: 12),
          _buildOpportunityCard(
            context,
            icon: Icons.credit_card,
            title: 'Student Discount Eligible',
            description:
                'You might qualify for 50% off on Adobe Creative Cloud',
            gradient: [const Color(0xFFFA0F00), const Color(0xFFFF4000)],
            savings: '₹25,380/year',
          ),
          const SizedBox(height: 12),
          _buildOpportunityCard(
            context,
            icon: Icons.local_offer,
            title: 'Promotional Pricing',
            description:
                'YouTube Premium has a 3-month trial offer available now',
            gradient: [const Color(0xFFFF0000), const Color(0xFFCC0000)],
            savings: 'Free for 3mo',
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradient,
    required String savings,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradient[0].withOpacity(0.15),
                  gradient[1].withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              savings,
              style: TextStyle(
                color: gradient[0],
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictiveAlerts(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B6B).withOpacity(0.9),
            const Color(0xFFFF8E53).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withOpacity(0.4),
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
                  Icons.warning_amber,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Predictive Alerts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAlertItem(
            icon: Icons.trending_up,
            title: 'Price Increase Predicted',
            description:
                'Netflix typically raises prices in January. Current: ₹649',
          ),
          const SizedBox(height: 14),
          _buildAlertItem(
            icon: Icons.credit_card_off,
            title: 'Card Expiring Soon',
            description:
                'Your payment card expires in 23 days. Update to avoid interruption.',
          ),
          const SizedBox(height: 14),
          _buildAlertItem(
            icon: Icons.event_busy,
            title: 'Trial Ending',
            description:
                'Notion trial ends in 5 days. Decide whether to subscribe.',
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageAnalysis(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFA6).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.pie_chart,
                        color: Color(0xFF00BFA6),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Flexible(
                      child: Text(
                        'Usage Efficiency',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BFA6).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '78% efficient',
                  style: TextStyle(
                    color: Color(0xFF00BFA6),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildUsageItem(
            context,
            name: 'Netflix',
            usagePercent: 95,
            costPerUse: '₹21/hour',
            isEfficient: true,
          ),
          _buildUsageItem(
            context,
            name: 'Spotify',
            usagePercent: 88,
            costPerUse: '₹0.50/song',
            isEfficient: true,
          ),
          _buildUsageItem(
            context,
            name: 'Adobe CC',
            usagePercent: 15,
            costPerUse: '₹845/use',
            isEfficient: false,
          ),
          _buildUsageItem(
            context,
            name: 'Notion',
            usagePercent: 45,
            costPerUse: '₹6/doc',
            isEfficient: true,
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem(
    BuildContext context, {
    required String name,
    required int usagePercent,
    required String costPerUse,
    required bool isEfficient,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: usagePercent / 100,
                backgroundColor:
                    (isEfficient
                            ? const Color(0xFF00BFA6)
                            : const Color(0xFFFF6B6B))
                        .withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(
                  isEfficient
                      ? const Color(0xFF00BFA6)
                      : const Color(0xFFFF6B6B),
                ),
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 80,
            child: Text(
              costPerUse,
              style: TextStyle(
                color: isEfficient
                    ? const Color(0xFF00BFA6)
                    : const Color(0xFFFF6B6B),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  int _calculateHealthScore(List<SubscriptionModel> subs) {
    if (subs.isEmpty) return 100;

    int score = 85; // Base score

    // Deduct for inactive/unused subscriptions
    final activeCount = subs
        .where((s) => s.status == SubscriptionStatus.active)
        .length;
    final totalCount = subs.length;
    if (totalCount > 0 && activeCount < totalCount * 0.7) {
      score -= 10;
    }

    return score.clamp(0, 100);
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return const Color(0xFF00BFA6);
    if (score >= 60) return const Color(0xFFFF9500);
    return const Color(0xFFFF6B6B);
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Work';
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFFF6B6B);
      case 'medium':
        return const Color(0xFFFF9500);
      case 'low':
        return const Color(0xFF00BFA6);
      default:
        return Colors.grey;
    }
  }

  void _refreshInsights() {
    HapticFeedback.mediumImpact();
    Get.snackbar(
      'Analyzing...',
      'AI is refreshing your insights',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _showOptimizationSheet(BuildContext context) {
    Get.snackbar(
      'Auto-Optimize',
      'Analyzing your subscriptions for optimization...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _findDuplicates(BuildContext context) {
    Get.snackbar(
      'Finding Duplicates',
      'Scanning for overlapping services...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _compareprices(BuildContext context) {
    Get.snackbar(
      'Price Compare',
      'Comparing prices across plans...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _optimizeBilling(BuildContext context) {
    Get.snackbar(
      'Optimize Billing',
      'Analyzing billing dates for optimization...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Data classes
class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _Recommendation {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final double savingsAmount;
  final String priority;
  final String actionLabel;

  const _Recommendation({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.savingsAmount,
    required this.priority,
    required this.actionLabel,
  });
}

// Custom painters
class _ScanLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScanLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          color.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 40));

    final y = progress * size.height;
    canvas.drawRect(Rect.fromLTWH(0, y - 20, size.width, 40), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _AIScoreGaugePainter extends CustomPainter {
  final int score;
  final double pulseValue;

  _AIScoreGaugePainter({required this.score, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 30) / 2;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      bgPaint,
    );

    // Score arc
    final scoreProgress = score / 100;
    final scoreColor = _getScoreColor(score);

    final scorePaint = Paint()
      ..shader = SweepGradient(
        startAngle: math.pi * 0.75,
        endAngle: math.pi * 2.25,
        colors: [
          scoreColor.withOpacity(0.5),
          scoreColor,
          scoreColor.withOpacity(0.8),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5 * scoreProgress,
      false,
      scorePaint,
    );

    // Glow effect
    final glowPaint = Paint()
      ..color = scoreColor.withOpacity(0.3 * pulseValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5 * scoreProgress,
      false,
      glowPaint,
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return const Color(0xFF00BFA6);
    if (score >= 60) return const Color(0xFFFF9500);
    return const Color(0xFFFF6B6B);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
