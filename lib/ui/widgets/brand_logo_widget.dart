import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/services/brand_logo_service.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// BRAND LOGO WIDGET - Premium Logo with Real Company Branding
/// ═══════════════════════════════════════════════════════════════════════════

class BrandLogoWidget extends StatefulWidget {
  final String? brandId;
  final String name;
  final String? iconName;
  final Color? color;
  final double size;
  final bool showShadow;
  final bool rounded;
  final double borderRadius;

  const BrandLogoWidget({
    super.key,
    this.brandId,
    required this.name,
    this.iconName,
    this.color,
    this.size = 48,
    this.showShadow = true,
    this.rounded = false,
    this.borderRadius = 12,
  });

  @override
  State<BrandLogoWidget> createState() => _BrandLogoWidgetState();
}

class _BrandLogoWidgetState extends State<BrandLogoWidget> {
  bool _imageLoadFailed = false;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final brandData = BrandLogoService.getBrand(
      widget.brandId ?? widget.iconName ?? widget.name,
    );
    final logoUrl = brandData?.logoUrl;
    final brandColor =
        widget.color ?? brandData?.primaryColor ?? const Color(0xFF7C4DFF);

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: widget.rounded
            ? BorderRadius.circular(widget.size / 2)
            : BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.showShadow
            ? [
                BoxShadow(
                  color: brandColor.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: widget.rounded
            ? BorderRadius.circular(widget.size / 2)
            : BorderRadius.circular(widget.borderRadius),
        child: _buildContent(logoUrl, brandColor, brandData),
      ),
    );
  }

  Widget _buildContent(
    String? logoUrl,
    Color brandColor,
    BrandData? brandData,
  ) {
    // Try network image first if available
    if (logoUrl != null && !_imageLoadFailed) {
      return Stack(
        children: [
          // Background gradient for loading
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    brandData?.gradientColors ??
                    [brandColor, brandColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Network image with caching
          Image.network(
            logoUrl,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.cover,
            cacheWidth: (widget.size * 2).toInt(),
            cacheHeight: (widget.size * 2).toInt(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                if (_isLoading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _isLoading = false);
                  });
                }
                return child;
              }
              return _buildLoadingIndicator(brandColor);
            },
            errorBuilder: (context, error, stackTrace) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _imageLoadFailed = true);
              });
              return _buildFallbackLogo(brandColor, brandData);
            },
          ),
        ],
      );
    }

    return _buildFallbackLogo(brandColor, brandData);
  }

  Widget _buildLoadingIndicator(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: widget.size * 0.35,
          height: widget.size * 0.35,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.8)),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackLogo(Color color, BrandData? brandData) {
    final displayChar =
        brandData?.iconChar ?? widget.name.substring(0, 1).toUpperCase();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          displayChar,
          style: TextStyle(
            color: Colors.white,
            fontSize: widget.size * 0.45,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// QUICK STATS ROW
/// ═══════════════════════════════════════════════════════════════════════════

class QuickStatsRow extends StatelessWidget {
  final int activeCount;
  final int pausedCount;
  final int trialsCount;
  final VoidCallback? onActiveTap;
  final VoidCallback? onPausedTap;
  final VoidCallback? onTrialsTap;

  const QuickStatsRow({
    super.key,
    required this.activeCount,
    required this.pausedCount,
    required this.trialsCount,
    this.onActiveTap,
    this.onPausedTap,
    this.onTrialsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 95,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _QuickStatCard(
              icon: Icons.check_circle_outline,
              label: 'Active',
              value: activeCount,
              color: const Color(0xFF00BFA6),
              onTap: onActiveTap,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickStatCard(
              icon: Icons.pause_circle_outline,
              label: 'Paused',
              value: pausedCount,
              color: Colors.orange,
              onTap: onPausedTap,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickStatCard(
              icon: Icons.hourglass_empty,
              label: 'Trials',
              value: trialsCount,
              color: const Color(0xFF7C4DFF),
              onTap: onTrialsTap,
              isDark: isDark,
              isPulsing: trialsCount > 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;
  final VoidCallback? onTap;
  final bool isDark;
  final bool isPulsing;

  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
    required this.isDark,
    this.isPulsing = false,
  });

  @override
  State<_QuickStatCard> createState() => _QuickStatCardState();
}

class _QuickStatCardState extends State<_QuickStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isPulsing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_QuickStatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing != oldWidget.isPulsing) {
      if (widget.isPulsing) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isPulsing ? _pulseAnimation.value : 1.0,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: widget.isDark
                ? widget.color.withOpacity(0.15)
                : widget.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.color.withOpacity(0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.color, size: 20),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.value.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: widget.color,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.color.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// INSIGHTS SUMMARY BAR
/// ═══════════════════════════════════════════════════════════════════════════

class InsightsSummaryBar extends StatelessWidget {
  final List<dynamic> insights;
  final VoidCallback? onViewAll;

  const InsightsSummaryBar({super.key, required this.insights, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (insights.isEmpty) return const SizedBox.shrink();

    final criticalCount = insights.where((i) => i.priority.index == 0).length;
    final savingsTotal = insights.fold<double>(
      0,
      (sum, i) => sum + (i.potentialSavings ?? 0),
    );

    return GestureDetector(
      onTap: onViewAll,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF7C4DFF).withOpacity(0.18),
              const Color(0xFF00BFA6).withOpacity(0.18),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF7C4DFF).withOpacity(0.35),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF9C7DFF)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C4DFF).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
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
                    '${insights.length} Smart Insights',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    savingsTotal > 0
                        ? 'Save up to ₹${savingsTotal.toStringAsFixed(0)}/mo'
                        : 'Tap to view recommendations',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF00BFA6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (criticalCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$criticalCount',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// CATEGORY BREAKDOWN
/// ═══════════════════════════════════════════════════════════════════════════

class CategoryBreakdown extends StatelessWidget {
  final Map<String, double> categorySpend;
  final String currency;

  const CategoryBreakdown({
    super.key,
    required this.categorySpend,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sortedCategories = categorySpend.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = categorySpend.values.fold<double>(0, (a, b) => a + b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
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
                'Spending by Category',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C4DFF), Color(0xFF00BFA6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$currency${total.toStringAsFixed(0)}/mo',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...sortedCategories.take(5).map((entry) {
            final percentage = total > 0 ? (entry.value / total) : 0.0;
            final color = _getCategoryColor(entry.key);

            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color, color.withOpacity(0.7)],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            entry.key.capitalizeFirst ?? entry.key,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '$currency${entry.value.toStringAsFixed(0)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${(percentage * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          height: 10,
                          width:
                              MediaQuery.of(context).size.width *
                              percentage *
                              0.6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color, color.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
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
          }),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'streaming': const Color(0xFFE50914),
      'music': const Color(0xFF1DB954),
      'gaming': const Color(0xFF107C10),
      'productivity': const Color(0xFF0078D4),
      'cloud': const Color(0xFF4285F4),
      'fitness': const Color(0xFFFF3F6C),
      'news': const Color(0xFF333333),
      'education': const Color(0xFF0056D2),
      'finance': const Color(0xFF00C853),
      'utilities': const Color(0xFF607D8B),
      'shopping': const Color(0xFFFF9800),
      'social': const Color(0xFF1DA1F2),
      'food': const Color(0xFFFC8019),
      'travel': const Color(0xFF00BCD4),
      'insurance': const Color(0xFF4CAF50),
      'telecom': const Color(0xFFE40000),
      'software': const Color(0xFF333333),
    };
    return colors[category.toLowerCase()] ?? const Color(0xFF7C4DFF);
  }
}
