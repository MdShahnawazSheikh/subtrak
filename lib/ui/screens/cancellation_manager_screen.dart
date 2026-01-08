import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Cancellation & Renewal Manager Screen
class CancellationManagerScreen extends StatefulWidget {
  const CancellationManagerScreen({super.key});

  @override
  State<CancellationManagerScreen> createState() =>
      _CancellationManagerScreenState();
}

class _CancellationManagerScreenState extends State<CancellationManagerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
          SliverToBoxAdapter(child: _buildRenewalSummary(context)),
          SliverToBoxAdapter(child: _buildTabBar(context)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 900,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildUpcomingRenewalsTab(context),
                  _buildPausedSubscriptionsTab(context),
                  _buildCancellationHistoryTab(context),
                ],
              ),
            ),
          ),
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
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.event_repeat,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Renewals',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF6B6B).withOpacity(0.3),
                const Color(0xFFFF8E53).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRenewalSummary(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withOpacity(0.4),
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
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.calendar_month,
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
                        '₹3,847 Due',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Total renewals in the next 30 days',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem('This Week', '₹649', Icons.today),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      _buildSummaryItem(
                        'This Month',
                        '₹2,198',
                        Icons.date_range,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      _buildSummaryItem('Paused', '2', Icons.pause_circle),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTimelineBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildTimelineBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Renewal Timeline',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '6 renewals this month',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.35,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Week 1',
              style: TextStyle(color: Colors.white70, fontSize: 10),
            ),
            Text(
              'Week 2',
              style: TextStyle(color: Colors.white70, fontSize: 10),
            ),
            Text(
              'Week 3',
              style: TextStyle(color: Colors.white70, fontSize: 10),
            ),
            Text(
              'Week 4',
              style: TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: isDark ? const Color(0xFF374151) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.hintColor,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Paused'),
          Tab(text: 'History'),
        ],
      ),
    );
  }

  Widget _buildUpcomingRenewalsTab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final renewals = [
      _Renewal(
        name: 'Netflix Premium',
        amount: 649,
        renewDate: DateTime.now().add(const Duration(days: 3)),
        icon: Icons.play_circle,
        color: const Color(0xFFE50914),
        billingCycle: 'Monthly',
        autoRenew: true,
      ),
      _Renewal(
        name: 'Spotify Premium',
        amount: 119,
        renewDate: DateTime.now().add(const Duration(days: 7)),
        icon: Icons.music_note,
        color: const Color(0xFF1DB954),
        billingCycle: 'Monthly',
        autoRenew: true,
      ),
      _Renewal(
        name: 'Adobe Creative Cloud',
        amount: 4230,
        renewDate: DateTime.now().add(const Duration(days: 15)),
        icon: Icons.brush,
        color: const Color(0xFFFA0F00),
        billingCycle: 'Monthly',
        autoRenew: true,
      ),
      _Renewal(
        name: 'Microsoft 365',
        amount: 5868,
        renewDate: DateTime.now().add(const Duration(days: 45)),
        icon: Icons.apps,
        color: const Color(0xFF00A4EF),
        billingCycle: 'Yearly',
        autoRenew: true,
      ),
      _Renewal(
        name: 'YouTube Premium',
        amount: 129,
        renewDate: DateTime.now().add(const Duration(days: 12)),
        icon: Icons.smart_display,
        color: const Color(0xFFFF0000),
        billingCycle: 'Monthly',
        autoRenew: true,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: renewals.length,
      itemBuilder: (context, index) {
        final renewal = renewals[index];
        return _buildRenewalCard(context, renewal);
      },
    );
  }

  Widget _buildRenewalCard(BuildContext context, _Renewal renewal) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final daysUntil = renewal.renewDate.difference(DateTime.now()).inDays;
    final isUrgent = daysUntil <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isUrgent
            ? Border.all(
                color: const Color(0xFFFF6B6B).withOpacity(0.5),
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isUrgent
                ? const Color(0xFFFF6B6B).withOpacity(0.2)
                : Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: renewal.color,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: renewal.color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(renewal.icon, color: Colors.white, size: 24),
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
                            renewal.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '₹${renewal.amount}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF667EEA),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isUrgent
                                  ? const Color(0xFFFF6B6B).withOpacity(0.15)
                                  : const Color(0xFF00BFA6).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$daysUntil days',
                              style: TextStyle(
                                color: isUrgent
                                    ? const Color(0xFFFF6B6B)
                                    : const Color(0xFF00BFA6),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '• ${renewal.billingCycle}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                renewal.autoRenew
                                    ? Icons.autorenew
                                    : Icons.cancel_outlined,
                                size: 14,
                                color: renewal.autoRenew
                                    ? const Color(0xFF00BFA6)
                                    : theme.hintColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                renewal.autoRenew ? 'Auto' : 'Manual',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pauseSubscription(renewal),
                    icon: const Icon(Icons.pause_outlined, size: 16),
                    label: const Text('Pause'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _skipRenewal(renewal),
                    icon: const Icon(Icons.skip_next_outlined, size: 16),
                    label: const Text('Skip'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCancelSheet(context, renewal),
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    label: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPausedSubscriptionsTab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final paused = [
      _PausedSubscription(
        name: 'Disney+ Hotstar',
        pausedDate: DateTime.now().subtract(const Duration(days: 15)),
        resumeDate: DateTime.now().add(const Duration(days: 15)),
        savedAmount: 299,
        icon: Icons.movie,
        color: const Color(0xFF113CCF),
        reason: 'Traveling',
      ),
      _PausedSubscription(
        name: 'Gym Membership',
        pausedDate: DateTime.now().subtract(const Duration(days: 30)),
        resumeDate: DateTime.now().add(const Duration(days: 30)),
        savedAmount: 1499,
        icon: Icons.fitness_center,
        color: const Color(0xFFFF5722),
        reason: 'Medical',
      ),
    ];

    if (paused.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pause_circle_outline,
              size: 64,
              color: theme.hintColor.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No Paused Subscriptions',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paused.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildPausedSavingsCard(context, paused);
        }
        return _buildPausedCard(context, paused[index - 1]);
      },
    );
  }

  Widget _buildPausedSavingsCard(
    BuildContext context,
    List<_PausedSubscription> paused,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final totalSaved = paused.fold(0.0, (sum, p) => sum + p.savedAmount);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00BFA6).withOpacity(0.15),
            const Color(0xFF00D4AA).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00BFA6).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00BFA6), Color(0xFF00D4AA)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.savings, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You\'re saving ₹${totalSaved.toStringAsFixed(0)}/mo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00BFA6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'by pausing ${paused.length} subscription${paused.length > 1 ? 's' : ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPausedCard(BuildContext context, _PausedSubscription sub) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final daysRemaining = sub.resumeDate.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sub.color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(sub.icon, color: sub.color, size: 24),
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
                            sub.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.pause,
                                  size: 12,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'PAUSED',
                                  style: TextStyle(
                                    color: Colors.amber[700],
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Reason: ${sub.reason}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF374151) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '₹${sub.savedAmount}',
                        style: const TextStyle(
                          color: Color(0xFF00BFA6),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Saving/mo',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 35,
                    color: isDark ? Colors.white10 : Colors.grey[300],
                  ),
                  Column(
                    children: [
                      Text(
                        '$daysRemaining days',
                        style: TextStyle(
                          color: Colors.amber[700],
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Until resume',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _extendPause(sub),
                    icon: const Icon(Icons.more_time, size: 16),
                    label: const Text('Extend'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _resumeSubscription(sub),
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('Resume'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BFA6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancellationHistoryTab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final history = [
      _CancellationRecord(
        name: 'LinkedIn Premium',
        cancelledDate: DateTime.now().subtract(const Duration(days: 30)),
        monthlyCost: 1499,
        totalPaid: 8994,
        usageDuration: 6,
        icon: Icons.business,
        color: const Color(0xFF0077B5),
        reason: 'Not using enough',
      ),
      _CancellationRecord(
        name: 'Headspace',
        cancelledDate: DateTime.now().subtract(const Duration(days: 60)),
        monthlyCost: 899,
        totalPaid: 10788,
        usageDuration: 12,
        icon: Icons.self_improvement,
        color: const Color(0xFFFF8C00),
        reason: 'Found free alternative',
      ),
      _CancellationRecord(
        name: 'Audible',
        cancelledDate: DateTime.now().subtract(const Duration(days: 90)),
        monthlyCost: 199,
        totalPaid: 796,
        usageDuration: 4,
        icon: Icons.headphones,
        color: const Color(0xFFFF9900),
        reason: 'Too expensive',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHistorySummary(context, history);
        }
        return _buildHistoryCard(context, history[index - 1]);
      },
    );
  }

  Widget _buildHistorySummary(
    BuildContext context,
    List<_CancellationRecord> history,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final totalSaved = history.fold(0.0, (sum, h) => sum + h.monthlyCost);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.trending_up, color: Color(0xFF00BFA6), size: 28),
              const SizedBox(width: 12),
              Text(
                '₹${totalSaved.toStringAsFixed(0)}/mo saved',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF00BFA6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'from ${history.length} cancelled subscriptions',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat(
                context,
                '₹${(totalSaved * 12).toStringAsFixed(0)}',
                'Yearly',
              ),
              _buildMiniStat(context, '${history.length}', 'Cancelled'),
              _buildMiniStat(
                context,
                '${(history.fold(0, (sum, h) => sum + h.usageDuration) / history.length).toStringAsFixed(0)} mo',
                'Avg Duration',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(BuildContext context, String value, String label) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(BuildContext context, _CancellationRecord record) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: record.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    record.icon,
                    color: record.color.withOpacity(0.7),
                    size: 24,
                  ),
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
                            record.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: theme.hintColor,
                            ),
                          ),
                          Text(
                            '₹${record.monthlyCost}/mo',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cancelled ${_formatDate(record.cancelledDate)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.format_quote,
                    color: theme.hintColor.withOpacity(0.5),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Reason: ${record.reason}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Used for ${record.usageDuration} months',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                Text(
                  'Total paid: ₹${record.totalPaid}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _resubscribe(record),
                icon: const Icon(Icons.replay, size: 16),
                label: const Text('Resubscribe'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showCancelSheet(BuildContext context, _Renewal renewal) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: const Color(0xFFFF6B6B),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Cancel ${renewal.name}?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your subscription will remain active until ${_formatDate(renewal.renewDate)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text('Why are you cancelling?', style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildReasonChip('Too expensive'),
                _buildReasonChip('Not using enough'),
                _buildReasonChip('Found alternative'),
                _buildReasonChip('Poor service'),
                _buildReasonChip('Other'),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Keep Subscription'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Subscription Cancelled',
                        '${renewal.name} will be cancelled after ${_formatDate(renewal.renewDate)}',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFFF6B6B),
                        colorText: Colors.white,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Confirm Cancel'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonChip(String reason) {
    return ChoiceChip(
      label: Text(reason),
      selected: false,
      onSelected: (selected) {},
    );
  }

  void _pauseSubscription(_Renewal renewal) {
    Get.snackbar(
      'Subscription Paused ⏸️',
      '${renewal.name} has been paused for 30 days',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.amber,
      colorText: Colors.black,
    );
  }

  void _skipRenewal(_Renewal renewal) {
    Get.snackbar(
      'Renewal Skipped ⏭️',
      '${renewal.name} renewal has been skipped for this cycle',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _extendPause(_PausedSubscription sub) {
    Get.snackbar(
      'Pause Extended',
      '${sub.name} pause extended by 30 days',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _resumeSubscription(_PausedSubscription sub) {
    Get.snackbar(
      'Subscription Resumed ▶️',
      '${sub.name} is now active again',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00BFA6),
      colorText: Colors.white,
    );
  }

  void _resubscribe(_CancellationRecord record) {
    Get.snackbar(
      'Opening ${record.name}...',
      'Redirecting to subscription page',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Data classes
class _Renewal {
  final String name;
  final double amount;
  final DateTime renewDate;
  final IconData icon;
  final Color color;
  final String billingCycle;
  final bool autoRenew;

  const _Renewal({
    required this.name,
    required this.amount,
    required this.renewDate,
    required this.icon,
    required this.color,
    required this.billingCycle,
    required this.autoRenew,
  });
}

class _PausedSubscription {
  final String name;
  final DateTime pausedDate;
  final DateTime resumeDate;
  final double savedAmount;
  final IconData icon;
  final Color color;
  final String reason;

  const _PausedSubscription({
    required this.name,
    required this.pausedDate,
    required this.resumeDate,
    required this.savedAmount,
    required this.icon,
    required this.color,
    required this.reason,
  });
}

class _CancellationRecord {
  final String name;
  final DateTime cancelledDate;
  final double monthlyCost;
  final double totalPaid;
  final int usageDuration;
  final IconData icon;
  final Color color;
  final String reason;

  const _CancellationRecord({
    required this.name,
    required this.cancelledDate,
    required this.monthlyCost,
    required this.totalPaid,
    required this.usageDuration,
    required this.icon,
    required this.color,
    required this.reason,
  });
}
