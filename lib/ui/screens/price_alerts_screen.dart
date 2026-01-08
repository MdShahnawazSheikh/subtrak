import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Price Alerts & Deals Screen
class PriceAlertsScreen extends StatefulWidget {
  const PriceAlertsScreen({super.key});

  @override
  State<PriceAlertsScreen> createState() => _PriceAlertsScreenState();
}

class _PriceAlertsScreenState extends State<PriceAlertsScreen>
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
          SliverToBoxAdapter(child: _buildPriceAlertSummary(context)),
          SliverToBoxAdapter(child: _buildTabBar(context)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 800,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveAlertsTab(context),
                  _buildDealsTab(context),
                  _buildPriceHistoryTab(context),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAlertSheet(context),
        backgroundColor: const Color(0xFF00BFA6),
        icon: const Icon(Icons.add_alert),
        label: const Text('New Alert'),
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
                  colors: [Color(0xFF00BFA6), Color(0xFFFF6B6B)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.price_change,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Price Alerts',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00BFA6).withOpacity(0.3),
                const Color(0xFFFF6B6B).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceAlertSummary(BuildContext context) {
    final theme = Theme.of(context);

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
                    Icons.savings,
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
                        '₹2,340 Saved',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Total savings from price alerts this year',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem('Active Alerts', '5'),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  _buildSummaryItem('Price Drops', '3'),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  _buildSummaryItem('Deals Found', '8'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
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
          Tab(text: 'Alerts'),
          Tab(text: 'Deals'),
          Tab(text: 'History'),
        ],
      ),
    );
  }

  Widget _buildActiveAlertsTab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final alerts = [
      _PriceAlert(
        name: 'Netflix Premium',
        currentPrice: 649,
        alertPrice: 599,
        icon: Icons.play_circle,
        color: const Color(0xFFE50914),
        status: 'Watching',
        lastChecked: '2 hours ago',
      ),
      _PriceAlert(
        name: 'Spotify Premium',
        currentPrice: 119,
        alertPrice: 99,
        icon: Icons.music_note,
        color: const Color(0xFF1DB954),
        status: 'Price Dropped!',
        lastChecked: 'Just now',
        isPriceDropped: true,
      ),
      _PriceAlert(
        name: 'Adobe Creative Cloud',
        currentPrice: 4230,
        alertPrice: 3499,
        icon: Icons.brush,
        color: const Color(0xFFFA0F00),
        status: 'Watching',
        lastChecked: '5 hours ago',
      ),
      _PriceAlert(
        name: 'YouTube Premium',
        currentPrice: 129,
        alertPrice: 99,
        icon: Icons.smart_display,
        color: const Color(0xFFFF0000),
        status: 'Watching',
        lastChecked: '1 day ago',
      ),
      _PriceAlert(
        name: 'Microsoft 365',
        currentPrice: 489,
        alertPrice: 399,
        icon: Icons.apps,
        color: const Color(0xFF00A4EF),
        status: 'Price Dropped!',
        lastChecked: '3 hours ago',
        isPriceDropped: true,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _buildAlertCard(context, alert);
      },
    );
  }

  Widget _buildAlertCard(BuildContext context, _PriceAlert alert) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: alert.isPriceDropped
            ? Border.all(
                color: const Color(0xFF00BFA6).withOpacity(0.5),
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: alert.isPriceDropped
                ? const Color(0xFF00BFA6).withOpacity(0.2)
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
                    color: alert.color,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: alert.color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(alert.icon, color: Colors.white, size: 24),
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
                            alert.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (alert.isPriceDropped)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00BFA6),
                                    Color(0xFF00D4AA),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.trending_down,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'DROPPED',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
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
                          Text(
                            'Current: ₹${alert.currentPrice}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: alert.isPriceDropped
                                  ? const Color(0xFF00BFA6)
                                  : null,
                              fontWeight: alert.isPriceDropped
                                  ? FontWeight.w600
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('→', style: TextStyle(color: theme.hintColor)),
                          const SizedBox(width: 12),
                          Text(
                            'Alert at: ₹${alert.alertPrice}',
                            style: theme.textTheme.bodyMedium?.copyWith(
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
            if (alert.isPriceDropped) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _dismissAlert(alert),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Dismiss'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _viewDeal(alert),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('View Deal'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last checked: ${alert.lastChecked}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _editAlert(alert),
                        icon: Icon(
                          Icons.edit_outlined,
                          color: theme.hintColor,
                          size: 20,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        onPressed: () => _deleteAlert(alert),
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.withOpacity(0.7),
                          size: 20,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDealsTab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final deals = [
      _Deal(
        name: 'Spotify Premium - 3 months free',
        description:
            'New user offer: Get 3 months of Spotify Premium absolutely free!',
        originalPrice: 357,
        dealPrice: 0,
        expiresIn: '5 days',
        icon: Icons.music_note,
        color: const Color(0xFF1DB954),
        isHot: true,
      ),
      _Deal(
        name: 'YouTube Premium Family - 50% off',
        description: 'Limited time: Family plan at half the price for 6 months',
        originalPrice: 189,
        dealPrice: 95,
        expiresIn: '2 weeks',
        icon: Icons.smart_display,
        color: const Color(0xFFFF0000),
        isHot: true,
      ),
      _Deal(
        name: 'Microsoft 365 - Student Discount',
        description: 'Verified students get 50% off on all plans',
        originalPrice: 489,
        dealPrice: 245,
        expiresIn: 'Ongoing',
        icon: Icons.apps,
        color: const Color(0xFF00A4EF),
        isHot: false,
      ),
      _Deal(
        name: 'Adobe CC - Annual Plan Discount',
        description: 'Save 20% when you switch to annual billing',
        originalPrice: 4230,
        dealPrice: 3384,
        expiresIn: '1 month',
        icon: Icons.brush,
        color: const Color(0xFFFA0F00),
        isHot: false,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: deals.length,
      itemBuilder: (context, index) {
        final deal = deals[index];
        return _buildDealCard(context, deal);
      },
    );
  }

  Widget _buildDealCard(BuildContext context, _Deal deal) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final savings = deal.originalPrice - deal.dealPrice;
    final savingsPercent = ((savings / deal.originalPrice) * 100)
        .toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: deal.color.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (deal.isHot)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'HOT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: deal.color,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: deal.color.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(deal.icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deal.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: theme.hintColor,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Expires in ${deal.expiresIn}',
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
                Text(
                  deal.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${deal.dealPrice}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF00BFA6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '₹${deal.originalPrice}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: theme.hintColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00BFA6).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-$savingsPercent%',
                            style: const TextStyle(
                              color: Color(0xFF00BFA6),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _claimDeal(deal),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deal.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Get Deal'),
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

  Widget _buildPriceHistoryTab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Netflix Premium',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: Color(0xFFFF6B6B),
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '+8% this year',
                            style: TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: _PriceChartPainter(
                      prices: [499, 499, 549, 549, 599, 599, 649],
                      color: const Color(0xFFE50914),
                      isDark: isDark,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPriceHistoryItem(
                      'Lowest',
                      '₹499',
                      'Jan 2023',
                      const Color(0xFF00BFA6),
                    ),
                    _buildPriceHistoryItem(
                      'Current',
                      '₹649',
                      'Now',
                      const Color(0xFF667EEA),
                    ),
                    _buildPriceHistoryItem(
                      'Predicted',
                      '₹699',
                      '2025',
                      const Color(0xFFFF6B6B),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF667EEA)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select a subscription above to view its price history',
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

  Widget _buildPriceHistoryItem(
    String label,
    String value,
    String date,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color.withOpacity(0.7), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          date,
          style: TextStyle(color: color.withOpacity(0.6), fontSize: 11),
        ),
      ],
    );
  }

  void _showAddAlertSheet(BuildContext context) {
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFA6), Color(0xFF00D4AA)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.add_alert, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 20),
            Text(
              'Create Price Alert',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Get notified when the price drops below your target',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Subscription',
                filled: true,
                fillColor: isDark ? const Color(0xFF374151) : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'netflix', child: Text('Netflix')),
                DropdownMenuItem(value: 'spotify', child: Text('Spotify')),
                DropdownMenuItem(
                  value: 'youtube',
                  child: Text('YouTube Premium'),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Alert me when price is below',
                prefixText: '₹ ',
                filled: true,
                fillColor: isDark ? const Color(0xFF374151) : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Alert Created! 🔔',
                    'You\'ll be notified when the price drops',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF00BFA6),
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Create Alert'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _dismissAlert(_PriceAlert alert) {
    Get.snackbar(
      'Alert Dismissed',
      '${alert.name} price alert has been dismissed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _viewDeal(_PriceAlert alert) {
    Get.snackbar(
      'Opening Deal...',
      'Redirecting to ${alert.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _editAlert(_PriceAlert alert) {
    _showAddAlertSheet(context);
  }

  void _deleteAlert(_PriceAlert alert) {
    Get.snackbar(
      'Alert Deleted',
      '${alert.name} price alert has been removed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _claimDeal(_Deal deal) {
    Get.snackbar(
      'Claiming Deal...',
      'Opening ${deal.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Data classes
class _PriceAlert {
  final String name;
  final double currentPrice;
  final double alertPrice;
  final IconData icon;
  final Color color;
  final String status;
  final String lastChecked;
  final bool isPriceDropped;

  const _PriceAlert({
    required this.name,
    required this.currentPrice,
    required this.alertPrice,
    required this.icon,
    required this.color,
    required this.status,
    required this.lastChecked,
    this.isPriceDropped = false,
  });
}

class _Deal {
  final String name;
  final String description;
  final double originalPrice;
  final double dealPrice;
  final String expiresIn;
  final IconData icon;
  final Color color;
  final bool isHot;

  const _Deal({
    required this.name,
    required this.description,
    required this.originalPrice,
    required this.dealPrice,
    required this.expiresIn,
    required this.icon,
    required this.color,
    required this.isHot,
  });
}

// Price chart painter
class _PriceChartPainter extends CustomPainter {
  final List<double> prices;
  final Color color;
  final bool isDark;

  _PriceChartPainter({
    required this.prices,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw grid
    for (var i = 0; i < 4; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Calculate points
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final priceRange = maxPrice - minPrice;
    final paddedRange = priceRange == 0 ? 100 : priceRange * 1.2;

    final points = <Offset>[];
    for (var i = 0; i < prices.length; i++) {
      final x = (i / (prices.length - 1)) * size.width;
      final y =
          size.height -
          ((prices[i] - minPrice + paddedRange * 0.1) / paddedRange) *
              size.height;
      points.add(Offset(x, y));
    }

    // Draw fill
    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, paint);

    // Draw points
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = isDark ? const Color(0xFF1F2937) : Colors.white
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 6, dotBorderPaint);
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
