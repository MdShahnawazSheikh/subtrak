import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/data/models/subscription_model.dart';
import '../../app/services/brand_logo_service.dart';
import 'premium_components.dart';
import 'brand_logo_widget.dart';

/// Premium subscription card with CRED-level aesthetics
class SubscriptionCard extends StatefulWidget {
  final SubscriptionModel subscription;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;
  final bool compact;
  final bool showNextBilling;
  final bool showCategory;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.compact = false,
    this.showNextBilling = true,
    this.showCategory = true,
  });

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sub = widget.subscription;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap?.call();
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          widget.onLongPress?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(
            horizontal: widget.compact ? 0 : 16,
            vertical: widget.compact ? 4 : 8,
          ),
          decoration: BoxDecoration(
            color: widget.selected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : (isDark ? const Color(0xFF1F2937) : Colors.white),
            borderRadius: BorderRadius.circular(widget.compact ? 12 : 16),
            border: Border.all(
              color: widget.selected
                  ? theme.colorScheme.primary
                  : (isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.grey.withOpacity(0.15)),
              width: widget.selected ? 2 : 1,
            ),
            boxShadow: [
              if (!widget.compact)
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: widget.compact
              ? _buildCompactContent(context, sub)
              : _buildFullContent(context, sub),
        ),
      ),
    );
  }

  Widget _buildCompactContent(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _buildLogo(sub, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.name,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatRecurrence(sub),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${sub.currency.symbol}${sub.amount.toStringAsFixed(0)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullContent(BuildContext context, SubscriptionModel sub) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogo(sub, size: 52),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sub.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusBadge(sub),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (widget.showCategory) ...[
                      Row(
                        children: [
                          Icon(
                            _getCategoryIcon(sub.category),
                            size: 14,
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            sub.category.name.capitalizeFirst ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.6),
                            ),
                          ),
                          if (sub.isTrial) ...[
                            const SizedBox(width: 8),
                            PremiumBadge(
                              text: 'Trial',
                              color: Colors.orange,
                              small: true,
                            ),
                          ],
                          if (sub.isTrialEndingSoon) ...[
                            const SizedBox(width: 8),
                            PremiumBadge(
                              text: 'Ending Soon!',
                              color: Colors.red,
                              small: true,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.03)
                  : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${sub.currency.symbol}${sub.amount.toStringAsFixed(sub.amount.truncateToDouble() == sub.amount ? 0 : 2)}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 2),
                          child: Text(
                            '/${_getRecurrenceShort(sub.recurrenceType)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (widget.showNextBilling) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Next billing',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (sub.isOverdue)
                            Icon(
                              Icons.warning_rounded,
                              size: 16,
                              color: Colors.red,
                            ),
                          const SizedBox(width: 4),
                          Text(
                            _formatNextBilling(sub),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: sub.isOverdue ? Colors.red : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (sub.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: sub.tags.take(3).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogo(SubscriptionModel sub, {required double size}) {
    // Use BrandLogoWidget with real company logos
    final brandId = _getBrandId(sub);

    return BrandLogoWidget(
      brandId: brandId,
      name: sub.name,
      iconName: sub.iconName,
      size: size,
      color: sub.color,
    );
  }

  /// Determines the brand ID from subscription data
  String _getBrandId(SubscriptionModel sub) {
    // First, try to use iconName if it's a valid brand ID
    if (sub.iconName != null && sub.iconName!.isNotEmpty) {
      final normalizedIconName = sub.iconName!.toLowerCase().replaceAll(
        ' ',
        '',
      );
      if (BrandLogoService.getBrand(normalizedIconName) != null) {
        return normalizedIconName;
      }
    }

    // Try to match by subscription name
    final normalizedName = sub.name.toLowerCase().replaceAll(' ', '');
    if (BrandLogoService.getBrand(normalizedName) != null) {
      return normalizedName;
    }

    // Try partial matching for common variations
    final brandMatches = {
      'netflix': ['netflix'],
      'spotify': ['spotify'],
      'youtube': ['youtube', 'ytpremium', 'youtubepremium', 'youtubemusic'],
      'amazon': ['amazon', 'prime', 'amazonprime', 'primevideo'],
      'disney': ['disney', 'disneyplus', 'disney+', 'hotstar'],
      'hbo': ['hbo', 'hbomax', 'max'],
      'apple': ['apple', 'applemusic', 'appletv', 'icloud', 'appleone'],
      'microsoft': [
        'microsoft',
        'office365',
        'm365',
        'microsoft365',
        'xbox',
        'gamepass',
      ],
      'adobe': ['adobe', 'creativecloud', 'adobecc', 'photoshop', 'lightroom'],
      'google': ['google', 'googleone', 'googledrive', 'workspace'],
      'notion': ['notion'],
      'figma': ['figma'],
      'slack': ['slack'],
      'zoom': ['zoom'],
      'dropbox': ['dropbox'],
      'github': ['github', 'copilot'],
      'chatgpt': ['chatgpt', 'openai'],
      'claude': ['claude', 'anthropic'],
      'canva': ['canva'],
      'grammarly': ['grammarly'],
    };

    for (final entry in brandMatches.entries) {
      for (final keyword in entry.value) {
        if (normalizedName.contains(keyword)) {
          return entry.key;
        }
      }
    }

    // Return the subscription name as fallback (will show letter avatar)
    return sub.name;
  }

  Widget _buildDefaultLogo(
    SubscriptionModel sub,
    double size,
    ThemeData theme,
  ) {
    final color = sub.color ?? theme.colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Center(
        child: Text(
          sub.name.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.45,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(SubscriptionModel sub) {
    Color color;

    switch (sub.status) {
      case SubscriptionStatus.active:
        color = const Color(0xFF00BFA6);
        break;
      case SubscriptionStatus.paused:
        color = Colors.orange;
        break;
      case SubscriptionStatus.cancelled:
        color = Colors.red;
        break;
      case SubscriptionStatus.expired:
        color = Colors.grey;
        break;
      case SubscriptionStatus.trial:
        color = const Color(0xFF7C4DFF);
        break;
      case SubscriptionStatus.pendingCancellation:
        color = Colors.orange;
        break;
      case SubscriptionStatus.paymentFailed:
        color = Colors.red;
        break;
      case SubscriptionStatus.gracePeriod:
        color = Colors.orange;
        break;
    }

    return StatusDot(
      color: color,
      animate: sub.status == SubscriptionStatus.trial,
    );
  }

  IconData _getCategoryIcon(SubscriptionCategory category) {
    switch (category) {
      case SubscriptionCategory.streaming:
        return Icons.movie_outlined;
      case SubscriptionCategory.music:
        return Icons.music_note_outlined;
      case SubscriptionCategory.gaming:
        return Icons.sports_esports_outlined;
      case SubscriptionCategory.productivity:
        return Icons.work_outline;
      case SubscriptionCategory.cloud:
        return Icons.cloud_outlined;
      case SubscriptionCategory.fitness:
        return Icons.fitness_center_outlined;
      case SubscriptionCategory.news:
        return Icons.newspaper_outlined;
      case SubscriptionCategory.education:
        return Icons.school_outlined;
      case SubscriptionCategory.food:
        return Icons.restaurant_outlined;
      case SubscriptionCategory.finance:
        return Icons.account_balance_outlined;
      case SubscriptionCategory.utilities:
        return Icons.electrical_services_outlined;
      case SubscriptionCategory.insurance:
        return Icons.security_outlined;
      case SubscriptionCategory.telecom:
        return Icons.phone_android_outlined;
      case SubscriptionCategory.software:
        return Icons.computer_outlined;
      case SubscriptionCategory.shopping:
        return Icons.shopping_bag_outlined;
      case SubscriptionCategory.social:
        return Icons.people_outline;
      case SubscriptionCategory.travel:
        return Icons.flight_outlined;
      case SubscriptionCategory.other:
        return Icons.category_outlined;
    }
  }

  String _formatRecurrence(SubscriptionModel sub) {
    switch (sub.recurrenceType) {
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.biWeekly:
        return 'Every 2 weeks';
      case RecurrenceType.monthly:
        return 'Monthly';
      case RecurrenceType.biMonthly:
        return 'Every 2 months';
      case RecurrenceType.quarterly:
        return 'Quarterly';
      case RecurrenceType.semiAnnual:
        return 'Every 6 months';
      case RecurrenceType.annual:
        return 'Yearly';
      case RecurrenceType.custom:
        return 'Custom';
      case RecurrenceType.oneTime:
        return 'One-time';
    }
  }

  String _getRecurrenceShort(RecurrenceType recurrence) {
    switch (recurrence) {
      case RecurrenceType.daily:
        return 'day';
      case RecurrenceType.weekly:
        return 'wk';
      case RecurrenceType.biWeekly:
        return '2wk';
      case RecurrenceType.monthly:
        return 'mo';
      case RecurrenceType.biMonthly:
        return '2mo';
      case RecurrenceType.quarterly:
        return 'qtr';
      case RecurrenceType.semiAnnual:
        return '6mo';
      case RecurrenceType.annual:
        return 'yr';
      case RecurrenceType.custom:
        return 'cust';
      case RecurrenceType.oneTime:
        return 'once';
    }
  }

  String _formatNextBilling(SubscriptionModel sub) {
    final nextBilling = sub.nextBillingDate;

    final now = DateTime.now();
    final difference = nextBilling.difference(now);

    if (difference.isNegative) {
      final days = difference.inDays.abs();
      if (days == 0) return 'Today';
      if (days == 1) return 'Yesterday';
      return '${days}d overdue';
    }

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Tomorrow';
    if (difference.inDays < 7) return 'In ${difference.inDays}d';

    return DateFormat('MMM d').format(nextBilling);
  }
}

/// Subscription list tile for compact lists
class SubscriptionListTile extends StatelessWidget {
  final SubscriptionModel subscription;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SubscriptionListTile({
    super.key,
    required this.subscription,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sub = subscription;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _buildAvatar(sub, theme),
      title: Text(
        sub.name,
        style: theme.textTheme.titleSmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _formatNextBilling(sub),
        style: theme.textTheme.bodySmall?.copyWith(
          color: sub.isOverdue ? Colors.red : null,
        ),
      ),
      trailing:
          trailing ??
          Text(
            '${sub.currency.symbol}${sub.amount.toStringAsFixed(0)}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
      onTap: onTap,
    );
  }

  Widget _buildAvatar(SubscriptionModel sub, ThemeData theme) {
    final color = sub.color ?? theme.colorScheme.primary;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          sub.name.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String _formatNextBilling(SubscriptionModel sub) {
    final nextBilling = sub.nextBillingDate;

    final now = DateTime.now();
    final difference = nextBilling.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    }

    if (difference.inDays == 0) return 'Due today';
    if (difference.inDays == 1) return 'Due tomorrow';
    if (difference.inDays < 7) return 'Due in ${difference.inDays} days';

    return 'Due ${DateFormat('MMM d').format(nextBilling)}';
  }
}
