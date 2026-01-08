import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// MODERN UI DESIGN SYSTEM - HIGH FIDELITY COMPONENTS
/// Clean, minimal, professional design language
/// ═══════════════════════════════════════════════════════════════════════════

// Design tokens
class AppColors {
  // Primary accent colors
  static const primary = Color(0xFF6366F1); // Indigo
  static const secondary = Color(0xFF8B5CF6); // Violet
  static const accent = Color(0xFF06B6D4); // Cyan

  // Semantic colors
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  // Neutrals
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const full = 999.0;
}

/// ═══════════════════════════════════════════════════════════════════════════
/// MODERN SURFACE CARD
/// Clean card with subtle shadows and proper elevation
/// ═══════════════════════════════════════════════════════════════════════════

class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double borderRadius;
  final bool elevated;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderRadius = AppRadius.lg,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor =
        backgroundColor ??
        (isDark ? AppColors.slate800.withValues(alpha: 0.6) : Colors.white);

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.slate200.withValues(alpha: 0.8),
        ),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap != null
              ? () {
                  HapticFeedback.lightImpact();
                  onTap!();
                }
              : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// ACCENT CARD WITH SUBTLE GRADIENT
/// Used for hero/highlight sections
/// ═══════════════════════════════════════════════════════════════════════════

class AccentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color accentColor;
  final VoidCallback? onTap;

  const AccentCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.accentColor = AppColors.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor,
            Color.lerp(accentColor, AppColors.secondary, 0.6)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: InkWell(
          onTap: onTap != null
              ? () {
                  HapticFeedback.mediumImpact();
                  onTap!();
                }
              : null,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          splashColor: Colors.white.withValues(alpha: 0.1),
          highlightColor: Colors.white.withValues(alpha: 0.05),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// SECTION HEADER
/// Clean section title with optional action
/// ═══════════════════════════════════════════════════════════════════════════

class ModernSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? actionIcon;
  final EdgeInsets padding;

  const ModernSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.actionIcon,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      AppSpacing.xxl,
      AppSpacing.xl,
      AppSpacing.md,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actionText != null || actionIcon != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (actionText != null)
                    Text(
                      actionText!,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (actionIcon != null) ...[
                    if (actionText != null) const SizedBox(width: 4),
                    Icon(
                      actionIcon,
                      size: 16,
                      color: theme.colorScheme.primary,
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

/// ═══════════════════════════════════════════════════════════════════════════
/// STAT TILE
/// Clean stat display with icon
/// ═══════════════════════════════════════════════════════════════════════════

class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String? trend;
  final bool trendPositive;
  final VoidCallback? onTap;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.trend,
    this.trendPositive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveBgColor =
        iconBackgroundColor ??
        effectiveIconColor.withValues(alpha: isDark ? 0.15 : 0.1);

    return ModernCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: effectiveBgColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, size: 20, color: effectiveIconColor),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (trendPositive ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendPositive
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 12,
                        color: trendPositive
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: trendPositive
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// ACTION TILE
/// Settings-style list tile with clean design
/// ═══════════════════════════════════════════════════════════════════════════

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool destructive;
  final bool showChevron;

  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.iconColor,
    this.onTap,
    this.destructive = false,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveColor = destructive
        ? AppColors.error
        : (iconColor ?? theme.colorScheme.primary);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null
            ? () {
                HapticFeedback.lightImpact();
                onTap!();
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, size: 20, color: effectiveColor),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: destructive ? AppColors.error : null,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
              if (trailing == null && showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// TOGGLE TILE
/// Clean switch/toggle tile
/// ═══════════════════════════════════════════════════════════════════════════

class ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? iconColor;

  const ToggleTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ActionTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconColor: iconColor,
      showChevron: false,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// MODERN CHIP
/// Clean chip/tag design
/// ═══════════════════════════════════════════════════════════════════════════

class ModernChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool selected;
  final VoidCallback? onTap;
  final bool compact;

  const ModernChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.selected = false,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap != null
          ? () {
              HapticFeedback.lightImpact();
              onTap!();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 14,
          vertical: compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? effectiveColor
              : effectiveColor.withValues(alpha: isDark ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: selected
              ? null
              : Border.all(color: effectiveColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: compact ? 14 : 16,
                color: selected ? Colors.white : effectiveColor,
              ),
              SizedBox(width: compact ? 4 : 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: compact ? 12 : 13,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// MODERN BUTTON
/// Primary/Secondary button styles
/// ═══════════════════════════════════════════════════════════════════════════

class ModernButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool primary;
  final bool loading;
  final bool expanded;
  final Color? color;

  const ModernButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.primary = true,
    this.loading = false,
    this.expanded = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    final child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                primary ? Colors.white : effectiveColor,
              ),
            ),
          )
        else if (icon != null)
          Icon(icon, size: 18),
        if ((icon != null || loading) && label.isNotEmpty)
          const SizedBox(width: 8),
        if (label.isNotEmpty)
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
      ],
    );

    if (primary) {
      return ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: child,
      );
    }

    return OutlinedButton(
      onPressed: loading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: effectiveColor,
        side: BorderSide(color: effectiveColor.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      child: child,
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// PROGRESS BAR
/// Clean linear progress indicator
/// ═══════════════════════════════════════════════════════════════════════════

class ModernProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final bool showLabel;
  final String? label;

  const ModernProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.backgroundColor,
    this.height = 8,
    this.showLabel = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveColor = color ?? AppColors.primary;
    final bgColor =
        backgroundColor ?? (isDark ? AppColors.slate700 : AppColors.slate200);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel || label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              if (showLabel)
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: effectiveColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                      decoration: BoxDecoration(
                        color: effectiveColor,
                        borderRadius: BorderRadius.circular(height / 2),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// EMPTY STATE
/// Clean empty state placeholder
/// ═══════════════════════════════════════════════════════════════════════════

class ModernEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ModernEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.slate700 : AppColors.slate100),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.xl),
            ModernButton(label: actionLabel!, onPressed: onAction),
          ],
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// MODERN APP BAR
/// Clean sliver app bar
/// ═══════════════════════════════════════════════════════════════════════════

class ModernSliverAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final bool centerTitle;
  final double expandedHeight;
  final Widget? flexibleContent;

  const ModernSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.centerTitle = false,
    this.expandedHeight = 56,
    this.flexibleContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: flexibleContent != null ? expandedHeight : null,
      pinned: true,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading,
      title: subtitle != null
          ? Column(
              crossAxisAlignment: centerTitle
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            )
          : Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: actions,
      flexibleSpace: flexibleContent != null
          ? FlexibleSpaceBar(background: flexibleContent)
          : null,
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// INFO ROW
/// Clean key-value display row
/// ═══════════════════════════════════════════════════════════════════════════

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// DIVIDER
/// ═══════════════════════════════════════════════════════════════════════════

class ModernDivider extends StatelessWidget {
  final EdgeInsets? padding;
  final double? indent;

  const ModernDivider({super.key, this.padding, this.indent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Divider(
        height: 1,
        thickness: 1,
        indent: indent,
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : AppColors.slate200.withValues(alpha: 0.8),
      ),
    );
  }
}
