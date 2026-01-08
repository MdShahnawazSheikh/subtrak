import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/data/models/subscription_model.dart';
import '../widgets/modern_ui_components.dart';

/// Subscription Comparison Screen - Modern Redesign
class SubscriptionComparisonScreen extends StatefulWidget {
  const SubscriptionComparisonScreen({super.key});

  @override
  State<SubscriptionComparisonScreen> createState() =>
      _SubscriptionComparisonScreenState();
}

class _SubscriptionComparisonScreenState
    extends State<SubscriptionComparisonScreen> {
  final SubscriptionController _controller = Get.find();
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildComparisonSummary(context)),
          SliverToBoxAdapter(child: _buildCategoryFilter(context)),
          SliverToBoxAdapter(child: _buildComparisonList(context)),
          SliverToBoxAdapter(child: _buildAlternatives(context)),
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
        'Compare & Save',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildComparisonSummary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AccentCard(
        accentColor: AppColors.accent,
        padding: const EdgeInsets.all(24),
        child: Column(
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
                    Icons.compare_arrows_rounded,
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
                        'Potential Savings',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₹2,840/year',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _ComparisonStat(
                    label: 'Subscriptions',
                    value: '3',
                    subtext: 'with alternatives',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _ComparisonStat(
                    label: 'Better Deals',
                    value: '5',
                    subtext: 'available',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final categories = ['All', 'Streaming', 'Productivity', 'Storage', 'Music'];

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ModernChip(
              label: category,
              selected: category == _selectedCategory,
              onTap: () => setState(() => _selectedCategory = category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildComparisonList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(
          title: 'Your Subscriptions',
          subtitle: 'Compared with alternatives',
        ),
        _ComparisonCard(
          currentName: 'Netflix Premium',
          currentPrice: 649,
          alternateName: 'Netflix Standard',
          alternatePrice: 499,
          savings: 1800,
          savingsPeriod: 'year',
        ),
        _ComparisonCard(
          currentName: 'Dropbox Plus',
          currentPrice: 999,
          alternateName: 'Google One 200GB',
          alternatePrice: 179,
          savings: 9840,
          savingsPeriod: 'year',
        ),
        _ComparisonCard(
          currentName: 'Adobe CC All Apps',
          currentPrice: 4599,
          alternateName: 'Affinity Suite',
          alternatePrice: 170,
          savings: 4429,
          savingsPeriod: 'month',
          isOneTime: true,
        ),
      ],
    );
  }

  Widget _buildAlternatives(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(
          title: 'Recommended Alternatives',
          subtitle: 'Popular options to consider',
        ),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              _AlternativeCard(
                name: 'Plex',
                description: 'Free media server',
                price: 'Free',
                color: Color(0xFFE5A00D),
              ),
              _AlternativeCard(
                name: 'Bitwarden',
                description: 'Password manager',
                price: '₹0/mo',
                color: Color(0xFF175DDC),
              ),
              _AlternativeCard(
                name: 'Notion',
                description: 'Notes & docs',
                price: '₹0/mo',
                color: Color(0xFF000000),
              ),
              _AlternativeCard(
                name: 'Canva',
                description: 'Design tool',
                price: '₹0/mo',
                color: Color(0xFF00C4CC),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Helper widgets
class _ComparisonStat extends StatelessWidget {
  final String label;
  final String value;
  final String subtext;

  const _ComparisonStat({
    required this.label,
    required this.value,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' $subtext',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final String currentName;
  final double currentPrice;
  final String alternateName;
  final double alternatePrice;
  final double savings;
  final String savingsPeriod;
  final bool isOneTime;

  const _ComparisonCard({
    required this.currentName,
    required this.currentPrice,
    required this.alternateName,
    required this.alternatePrice,
    required this.savings,
    required this.savingsPeriod,
    this.isOneTime = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ModernCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current subscription
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.remove_circle_outline,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Current',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${currentPrice.toStringAsFixed(0)}/mo',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Alternative
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alternateName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      isOneTime ? 'One-time purchase' : 'Alternative',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                isOneTime
                    ? '₹${alternatePrice.toStringAsFixed(0)}'
                    : '₹${alternatePrice.toStringAsFixed(0)}/mo',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Savings banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Potential savings',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '₹${savings.toStringAsFixed(0)}/$savingsPeriod',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlternativeCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final Color color;

  const _AlternativeCard({
    required this.name,
    required this.description,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            description,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
