import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Subscription Comparison & Alternatives Screen
class SubscriptionComparisonScreen extends StatefulWidget {
  const SubscriptionComparisonScreen({super.key});

  @override
  State<SubscriptionComparisonScreen> createState() =>
      _SubscriptionComparisonScreenState();
}

class _SubscriptionComparisonScreenState
    extends State<SubscriptionComparisonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'streaming';

  final List<Map<String, dynamic>> _categories = [
    {'id': 'streaming', 'name': 'Streaming', 'icon': Icons.play_circle},
    {'id': 'music', 'name': 'Music', 'icon': Icons.music_note},
    {'id': 'productivity', 'name': 'Productivity', 'icon': Icons.work},
    {'id': 'storage', 'name': 'Storage', 'icon': Icons.cloud},
    {'id': 'gaming', 'name': 'Gaming', 'icon': Icons.sports_esports},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          SliverToBoxAdapter(child: _buildCurrentSubscription(context)),
          SliverToBoxAdapter(child: _buildCategorySelector(context)),
          SliverToBoxAdapter(child: _buildTabBar(context)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 800,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCompareTab(context),
                  _buildAlternativesTab(context),
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
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.compare_arrows,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Compare',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF667EEA).withOpacity(0.3),
                const Color(0xFF764BA2).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentSubscription(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.analytics,
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
                        'Subscription Analysis',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Compare your subscriptions & find alternatives',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Active', '12', Icons.subscriptions),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  _buildStatItem('Savings Potential', '₹2.4k', Icons.savings),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  _buildStatItem('Alternatives', '8', Icons.swap_horiz),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
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
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category['id'];

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category['id']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      )
                    : null,
                color: isSelected
                    ? null
                    : isDark
                    ? const Color(0xFF1F2937)
                    : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    category['icon'],
                    size: 18,
                    color: isSelected ? Colors.white : theme.hintColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category['name'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : theme.hintColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
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
          Tab(text: 'Compare'),
          Tab(text: 'Alternatives'),
        ],
      ),
    );
  }

  Widget _buildCompareTab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final services = _getServicesForCategory(_selectedCategory);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feature Comparison',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
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
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF374151) : Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          'Features',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ...services.map(
                        (service) => Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: service['color'],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    service['icon'],
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  service['name'],
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Price row
                _buildComparisonRow(
                  context,
                  'Monthly Price',
                  services.map((s) => '₹${s['price']}').toList(),
                  isPrice: true,
                ),
                // Features
                _buildComparisonRow(
                  context,
                  'Video Quality',
                  services.map((s) => s['quality'] ?? '-').toList(),
                ),
                _buildComparisonRow(
                  context,
                  'Screens',
                  services.map((s) => s['screens'] ?? '-').toList(),
                ),
                _buildComparisonRow(
                  context,
                  'Downloads',
                  services.map((s) => s['downloads'] ?? false).toList(),
                  isBoolean: true,
                ),
                _buildComparisonRow(
                  context,
                  'Ads',
                  services.map((s) => s['ads'] ?? true).toList(),
                  isBoolean: true,
                  invertBoolean: true,
                ),
                _buildComparisonRow(
                  context,
                  'Family Plan',
                  services.map((s) => s['family'] ?? false).toList(),
                  isBoolean: true,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildRecommendationCard(context, services),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
    BuildContext context,
    String label,
    List<dynamic> values, {
    bool isPrice = false,
    bool isBoolean = false,
    bool invertBoolean = false,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey[200]!,
                ),
              ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
          ...values.map(
            (value) => Expanded(
              child: Center(
                child: isBoolean
                    ? Icon(
                        (invertBoolean ? !(value as bool) : (value as bool))
                            ? Icons.check_circle
                            : Icons.cancel,
                        color:
                            (invertBoolean ? !(value as bool) : (value as bool))
                            ? const Color(0xFF00BFA6)
                            : Colors.red.withOpacity(0.5),
                        size: 22,
                      )
                    : Text(
                        value.toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isPrice
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isPrice ? const Color(0xFF667EEA) : null,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    List<Map<String, dynamic>> services,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Find best value - parse screens as int (handle '∞' and other strings)
    int parseScreens(dynamic value) {
      if (value == null) return 1;
      if (value is int) return value == 0 ? 1 : value;
      if (value is String) {
        if (value == '∞') return 999;
        return int.tryParse(value) ?? 1;
      }
      return 1;
    }

    final bestValue = services.reduce(
      (a, b) =>
          (a['price'] as num) / parseScreens(a['screens']) <
              (b['price'] as num) / parseScreens(b['screens'])
          ? a
          : b,
    );

    return Container(
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00BFA6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.thumb_up, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Value: ${bestValue['name']}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00BFA6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on features per rupee, this offers the best value for money.',
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

  Widget _buildAlternativesTab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final alternatives = _getAlternativesForCategory(_selectedCategory);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: alternatives.length,
      itemBuilder: (context, index) {
        final alt = alternatives[index];
        return _buildAlternativeCard(context, alt);
      },
    );
  }

  Widget _buildAlternativeCard(BuildContext context, Map<String, dynamic> alt) {
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
                    color: alt['color'],
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: (alt['color'] as Color).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(alt['icon'], color: Colors.white, size: 24),
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
                            alt['name'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (alt['isFree'] == true)
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
                              child: const Text(
                                'FREE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alt['description'],
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
            Row(
              children: [
                _buildAltFeature(
                  context,
                  Icons.attach_money,
                  '₹${alt['price']}/mo',
                ),
                const SizedBox(width: 16),
                _buildAltFeature(context, Icons.star, '${alt['rating']}'),
                const SizedBox(width: 16),
                _buildAltFeature(
                  context,
                  Icons.people,
                  '${alt['users']} users',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (alt['features'] as List<String>).map((feature) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (alt['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    feature,
                    style: TextStyle(
                      color: alt['color'],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('Learn More'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _switchToAlternative(alt),
                    icon: const Icon(Icons.swap_horiz, size: 18),
                    label: const Text('Switch'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: alt['color'],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

  Widget _buildAltFeature(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.hintColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getServicesForCategory(String category) {
    switch (category) {
      case 'streaming':
        return [
          {
            'name': 'Netflix',
            'icon': Icons.play_circle,
            'color': const Color(0xFFE50914),
            'price': 649,
            'quality': '4K HDR',
            'screens': '4',
            'downloads': true,
            'ads': false,
            'family': true,
          },
          {
            'name': 'Prime Video',
            'icon': Icons.video_library,
            'color': const Color(0xFF00A8E1),
            'price': 179,
            'quality': '4K HDR',
            'screens': '3',
            'downloads': true,
            'ads': true,
            'family': true,
          },
          {
            'name': 'Disney+',
            'icon': Icons.movie,
            'color': const Color(0xFF113CCF),
            'price': 299,
            'quality': '4K',
            'screens': '4',
            'downloads': true,
            'ads': false,
            'family': true,
          },
        ];
      case 'music':
        return [
          {
            'name': 'Spotify',
            'icon': Icons.music_note,
            'color': const Color(0xFF1DB954),
            'price': 119,
            'quality': '320kbps',
            'screens': '1',
            'downloads': true,
            'ads': false,
            'family': true,
          },
          {
            'name': 'Apple Music',
            'icon': Icons.music_note,
            'color': const Color(0xFFFA2D48),
            'price': 99,
            'quality': 'Lossless',
            'screens': '1',
            'downloads': true,
            'ads': false,
            'family': true,
          },
          {
            'name': 'YT Music',
            'icon': Icons.music_video,
            'color': const Color(0xFFFF0000),
            'price': 99,
            'quality': '256kbps',
            'screens': '1',
            'downloads': true,
            'ads': false,
            'family': true,
          },
        ];
      case 'productivity':
        return [
          {
            'name': 'Microsoft 365',
            'icon': Icons.apps,
            'color': const Color(0xFF00A4EF),
            'price': 489,
            'quality': 'Full Suite',
            'screens': '5',
            'downloads': true,
            'ads': false,
            'family': true,
          },
          {
            'name': 'Google One',
            'icon': Icons.cloud,
            'color': const Color(0xFF4285F4),
            'price': 130,
            'quality': 'Web-based',
            'screens': '∞',
            'downloads': true,
            'ads': false,
            'family': true,
          },
          {
            'name': 'Notion',
            'icon': Icons.note,
            'color': const Color(0xFF000000),
            'price': 0,
            'quality': 'Personal',
            'screens': '∞',
            'downloads': false,
            'ads': false,
            'family': false,
          },
        ];
      case 'storage':
        return [
          {
            'name': 'Google One',
            'icon': Icons.cloud,
            'color': const Color(0xFF4285F4),
            'price': 130,
            'quality': '100 GB',
            'screens': '∞',
            'downloads': true,
            'ads': false,
            'family': true,
          },
          {
            'name': 'iCloud+',
            'icon': Icons.cloud_outlined,
            'color': const Color(0xFF3D7EF7),
            'price': 75,
            'quality': '50 GB',
            'screens': '∞',
            'downloads': true,
            'ads': false,
            'family': true,
          },
          {
            'name': 'Dropbox',
            'icon': Icons.cloud_upload,
            'color': const Color(0xFF0061FF),
            'price': 950,
            'quality': '2 TB',
            'screens': '3',
            'downloads': true,
            'ads': false,
            'family': false,
          },
        ];
      case 'gaming':
        return [
          {
            'name': 'Xbox Game Pass',
            'icon': Icons.sports_esports,
            'color': const Color(0xFF107C10),
            'price': 499,
            'quality': '100+ Games',
            'screens': '1',
            'downloads': true,
            'ads': false,
            'family': false,
          },
          {
            'name': 'PS Plus',
            'icon': Icons.gamepad,
            'color': const Color(0xFF003087),
            'price': 499,
            'quality': '400+ Games',
            'screens': '1',
            'downloads': true,
            'ads': false,
            'family': false,
          },
          {
            'name': 'Nintendo Online',
            'icon': Icons.videogame_asset,
            'color': const Color(0xFFE60012),
            'price': 159,
            'quality': 'Online Play',
            'screens': '1',
            'downloads': true,
            'ads': false,
            'family': true,
          },
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _getAlternativesForCategory(String category) {
    switch (category) {
      case 'streaming':
        return [
          {
            'name': 'Pluto TV',
            'icon': Icons.tv,
            'color': const Color(0xFF000000),
            'description': 'Free streaming with 250+ live TV channels',
            'price': 0,
            'rating': 4.2,
            'users': '80M+',
            'isFree': true,
            'features': ['Live TV', 'On Demand', 'No Sign-up'],
          },
          {
            'name': 'Tubi',
            'icon': Icons.movie,
            'color': const Color(0xFFFA382F),
            'description': 'Free movies and TV shows with ads',
            'price': 0,
            'rating': 4.1,
            'users': '51M+',
            'isFree': true,
            'features': ['40k+ Titles', 'Originals', 'No Subscription'],
          },
          {
            'name': 'MX Player',
            'icon': Icons.play_circle,
            'color': const Color(0xFF1976D2),
            'description': 'Free streaming platform for India',
            'price': 0,
            'rating': 4.3,
            'users': '100M+',
            'isFree': true,
            'features': ['Regional Content', 'Web Series', 'Music Videos'],
          },
        ];
      case 'music':
        return [
          {
            'name': 'Spotify Free',
            'icon': Icons.music_note,
            'color': const Color(0xFF1DB954),
            'description': 'Free tier with shuffle-only playback',
            'price': 0,
            'rating': 4.5,
            'users': '300M+',
            'isFree': true,
            'features': ['Shuffle Play', 'Discover Weekly', 'Podcasts'],
          },
          {
            'name': 'YouTube Music Free',
            'icon': Icons.music_video,
            'color': const Color(0xFFFF0000),
            'description': 'Free music streaming with ads',
            'price': 0,
            'rating': 4.0,
            'users': '80M+',
            'isFree': true,
            'features': ['Music Videos', 'Playlists', 'Recommendations'],
          },
          {
            'name': 'SoundCloud',
            'icon': Icons.cloud,
            'color': const Color(0xFFFF5500),
            'description': 'Discover independent artists and tracks',
            'price': 0,
            'rating': 4.2,
            'users': '175M+',
            'isFree': true,
            'features': ['Indie Artists', 'Remixes', 'Upload Own Music'],
          },
        ];
      default:
        return [
          {
            'name': 'Open Source Alternative',
            'icon': Icons.code,
            'color': const Color(0xFF00BFA6),
            'description': 'Free and open source alternatives available',
            'price': 0,
            'rating': 4.0,
            'users': '10M+',
            'isFree': true,
            'features': ['Free', 'Open Source', 'Community'],
          },
        ];
    }
  }

  void _switchToAlternative(Map<String, dynamic> alt) {
    Get.snackbar(
      'Great Choice! 🎉',
      'Switching to ${alt['name']} could save you money',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: alt['color'],
      colorText: Colors.white,
    );
  }
}
