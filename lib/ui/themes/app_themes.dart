import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Available app themes
enum AppTheme {
  midnightDark,
  snowLight,
  oceanBreeze,
  sunsetGlow,
  forestMist,
  lavenderDream,
  roseGold,
  neonCity,
  minimalMono,
  warmEarth,
}

/// Theme metadata for UI display
class ThemeMetadata {
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDark;
  final List<Color> previewColors;

  const ThemeMetadata({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isDark,
    required this.previewColors,
  });
}

/// Premium Multi-Theme System
class AppThemes {
  // ═══════════════════════════════════════════════════════════════════════════
  // THEME METADATA
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<AppTheme, ThemeMetadata> themeMetadata = {
    AppTheme.midnightDark: ThemeMetadata(
      name: 'Midnight',
      description: 'Elegant dark theme with teal accents',
      primaryColor: Color(0xFF00BFA6),
      secondaryColor: Color(0xFF1A1A2E),
      isDark: true,
      previewColors: [Color(0xFF1A1A2E), Color(0xFF00BFA6), Color(0xFF7C4DFF)],
    ),
    AppTheme.snowLight: ThemeMetadata(
      name: 'Snow',
      description: 'Clean and minimal light theme',
      primaryColor: Color(0xFF2563EB),
      secondaryColor: Color(0xFFF8FAFC),
      isDark: false,
      previewColors: [Color(0xFFF8FAFC), Color(0xFF2563EB), Color(0xFF10B981)],
    ),
    AppTheme.oceanBreeze: ThemeMetadata(
      name: 'Ocean Breeze',
      description: 'Calming blue tones inspired by the sea',
      primaryColor: Color(0xFF0891B2),
      secondaryColor: Color(0xFF0C4A6E),
      isDark: true,
      previewColors: [Color(0xFF0C4A6E), Color(0xFF0891B2), Color(0xFF22D3EE)],
    ),
    AppTheme.sunsetGlow: ThemeMetadata(
      name: 'Sunset Glow',
      description: 'Warm orange and pink gradients',
      primaryColor: Color(0xFFF97316),
      secondaryColor: Color(0xFF1C1917),
      isDark: true,
      previewColors: [Color(0xFF1C1917), Color(0xFFF97316), Color(0xFFEC4899)],
    ),
    AppTheme.forestMist: ThemeMetadata(
      name: 'Forest Mist',
      description: 'Natural green tones for relaxation',
      primaryColor: Color(0xFF10B981),
      secondaryColor: Color(0xFFF0FDF4),
      isDark: false,
      previewColors: [Color(0xFFF0FDF4), Color(0xFF10B981), Color(0xFF065F46)],
    ),
    AppTheme.lavenderDream: ThemeMetadata(
      name: 'Lavender Dream',
      description: 'Soft purple tones for a dreamy feel',
      primaryColor: Color(0xFF8B5CF6),
      secondaryColor: Color(0xFFFAF5FF),
      isDark: false,
      previewColors: [Color(0xFFFAF5FF), Color(0xFF8B5CF6), Color(0xFFEC4899)],
    ),
    AppTheme.roseGold: ThemeMetadata(
      name: 'Rose Gold',
      description: 'Luxurious pink and gold accents',
      primaryColor: Color(0xFFE11D48),
      secondaryColor: Color(0xFF1F1F1F),
      isDark: true,
      previewColors: [Color(0xFF1F1F1F), Color(0xFFE11D48), Color(0xFFFDA4AF)],
    ),
    AppTheme.neonCity: ThemeMetadata(
      name: 'Neon City',
      description: 'Vibrant cyberpunk-inspired colors',
      primaryColor: Color(0xFF00F5D4),
      secondaryColor: Color(0xFF0D0221),
      isDark: true,
      previewColors: [Color(0xFF0D0221), Color(0xFF00F5D4), Color(0xFFF72585)],
    ),
    AppTheme.minimalMono: ThemeMetadata(
      name: 'Minimal Mono',
      description: 'Clean black and white aesthetics',
      primaryColor: Color(0xFF18181B),
      secondaryColor: Color(0xFFFAFAFA),
      isDark: false,
      previewColors: [Color(0xFFFAFAFA), Color(0xFF18181B), Color(0xFF71717A)],
    ),
    AppTheme.warmEarth: ThemeMetadata(
      name: 'Warm Earth',
      description: 'Cozy brown and cream tones',
      primaryColor: Color(0xFFB45309),
      secondaryColor: Color(0xFFFEF3C7),
      isDark: false,
      previewColors: [Color(0xFFFEF3C7), Color(0xFFB45309), Color(0xFF78350F)],
    ),
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // GET THEME DATA
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData getTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.midnightDark:
        return _midnightDarkTheme;
      case AppTheme.snowLight:
        return _snowLightTheme;
      case AppTheme.oceanBreeze:
        return _oceanBreezeTheme;
      case AppTheme.sunsetGlow:
        return _sunsetGlowTheme;
      case AppTheme.forestMist:
        return _forestMistTheme;
      case AppTheme.lavenderDream:
        return _lavenderDreamTheme;
      case AppTheme.roseGold:
        return _roseGoldTheme;
      case AppTheme.neonCity:
        return _neonCityTheme;
      case AppTheme.minimalMono:
        return _minimalMonoTheme;
      case AppTheme.warmEarth:
        return _warmEarthTheme;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MIDNIGHT DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static final ThemeData _midnightDarkTheme = _buildTheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF00BFA6),
    secondary: const Color(0xFF7C4DFF),
    tertiary: const Color(0xFFFF6B35),
    background: const Color(0xFF0F0F1A),
    surface: const Color(0xFF1A1A2E),
    card: const Color(0xFF252542),
    error: const Color(0xFFFF5252),
    success: const Color(0xFF00C853),
    warning: const Color(0xFFFFB300),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SNOW LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static final ThemeData _snowLightTheme = _buildTheme(
    brightness: Brightness.light,
    primary: const Color(0xFF2563EB),
    secondary: const Color(0xFF7C3AED),
    tertiary: const Color(0xFF10B981),
    background: const Color(0xFFF8FAFC),
    surface: const Color(0xFFFFFFFF),
    card: const Color(0xFFF1F5F9),
    error: const Color(0xFFDC2626),
    success: const Color(0xFF16A34A),
    warning: const Color(0xFFF59E0B),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // OCEAN BREEZE THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static final ThemeData _oceanBreezeTheme = _buildTheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF0891B2),
    secondary: const Color(0xFF22D3EE),
    tertiary: const Color(0xFF06B6D4),
    background: const Color(0xFF0C4A6E),
    surface: const Color(0xFF164E63),
    card: const Color(0xFF1E5F74),
    error: const Color(0xFFF87171),
    success: const Color(0xFF34D399),
    warning: const Color(0xFFFBBF24),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SUNSET GLOW THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static final ThemeData _sunsetGlowTheme = _buildTheme(
    brightness: Brightness.dark,
    primary: const Color(0xFFF97316),
    secondary: const Color(0xFFEC4899),
    tertiary: const Color(0xFFFBBF24),
    background: const Color(0xFF1C1917),
    surface: const Color(0xFF292524),
    card: const Color(0xFF3D3733),
    error: const Color(0xFFF87171),
    success: const Color(0xFF4ADE80),
    warning: const Color(0xFFFDE047),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // FOREST MIST THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static final ThemeData _forestMistTheme = _buildTheme(
    brightness: Brightness.light,
    primary: const Color(0xFF10B981),
    secondary: const Color(0xFF065F46),
    tertiary: const Color(0xFF14B8A6),
    background: const Color(0xFFF0FDF4),
    surface: const Color(0xFFFFFFFF),
    card: const Color(0xFFDCFCE7),
    error: const Color(0xFFDC2626),
    success: const Color(0xFF16A34A),
    warning: const Color(0xFFEAB308),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LAVENDER DREAM THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static final ThemeData _lavenderDreamTheme = _buildTheme(
    brightness: Brightness.light,
    primary: const Color(0xFF8B5CF6),
    secondary: const Color(0xFFEC4899),
    tertiary: const Color(0xFFA855F7),
    background: const Color(0xFFFAF5FF),
    surface: const Color(0xFFFFFFFF),
    card: const Color(0xFFF3E8FF),
    error: const Color(0xFFE11D48),
    success: const Color(0xFF22C55E),
    warning: const Color(0xFFF59E0B),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // ROSE GOLD THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static final ThemeData _roseGoldTheme = _buildTheme(
    brightness: Brightness.dark,
    primary: const Color(0xFFE11D48),
    secondary: const Color(0xFFFDA4AF),
    tertiary: const Color(0xFFFB7185),
    background: const Color(0xFF1F1F1F),
    surface: const Color(0xFF2D2D2D),
    card: const Color(0xFF3A3A3A),
    error: const Color(0xFFF87171),
    success: const Color(0xFF4ADE80),
    warning: const Color(0xFFFDE047),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // NEON CITY THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static final ThemeData _neonCityTheme = _buildTheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF00F5D4),
    secondary: const Color(0xFFF72585),
    tertiary: const Color(0xFF7209B7),
    background: const Color(0xFF0D0221),
    surface: const Color(0xFF190535),
    card: const Color(0xFF2B0A4D),
    error: const Color(0xFFFF6B6B),
    success: const Color(0xFF00F5D4),
    warning: const Color(0xFFFEE440),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // MINIMAL MONO THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static final ThemeData _minimalMonoTheme = _buildTheme(
    brightness: Brightness.light,
    primary: const Color(0xFF18181B),
    secondary: const Color(0xFF52525B),
    tertiary: const Color(0xFF71717A),
    background: const Color(0xFFFAFAFA),
    surface: const Color(0xFFFFFFFF),
    card: const Color(0xFFF4F4F5),
    error: const Color(0xFFDC2626),
    success: const Color(0xFF16A34A),
    warning: const Color(0xFFF59E0B),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // WARM EARTH THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static final ThemeData _warmEarthTheme = _buildTheme(
    brightness: Brightness.light,
    primary: const Color(0xFFB45309),
    secondary: const Color(0xFF78350F),
    tertiary: const Color(0xFFD97706),
    background: const Color(0xFFFEF3C7),
    surface: const Color(0xFFFFFBEB),
    card: const Color(0xFFFDE68A),
    error: const Color(0xFFDC2626),
    success: const Color(0xFF16A34A),
    warning: const Color(0xFFD97706),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // THEME BUILDER
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color background,
    required Color surface,
    required Color card,
    required Color error,
    required Color success,
    required Color warning,
  }) {
    final isDark = brightness == Brightness.dark;
    final onPrimary = _contrastColor(primary);
    final onSurface = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final onSurfaceMuted = isDark ? Colors.white70 : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : Colors.black12;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,

      // Color Scheme
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: _contrastColor(secondary),
        tertiary: tertiary,
        onTertiary: _contrastColor(tertiary),
        error: error,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: card,
        outline: dividerColor,
      ),

      // Scaffold
      scaffoldBackgroundColor: background,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: onSurface,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: onSurface),
      ),

      // Card
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark ? BorderSide.none : BorderSide(color: dividerColor),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          color: onSurfaceMuted,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: onSurfaceMuted.withValues(alpha: 0.5),
          fontSize: 14,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceMuted.withValues(alpha: 0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        modalElevation: 16,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        contentTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          color: onSurfaceMuted,
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? card : const Color(0xFF323232),
        contentTextStyle: GoogleFonts.plusJakartaSans(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider
      dividerTheme: DividerThemeData(color: dividerColor, thickness: 1),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: card,
        selectedColor: primary.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: onSurface),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Text Theme
      textTheme: _buildTextTheme(brightness, onSurface, onSurfaceMuted),

      // Icon Theme
      iconTheme: IconThemeData(color: onSurfaceMuted),

      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: primary.withValues(alpha: 0.2),
        thumbColor: primary,
        overlayColor: primary.withValues(alpha: 0.1),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return isDark ? Colors.white60 : Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary.withValues(alpha: 0.3);
          }
          return isDark ? Colors.white24 : Colors.grey.shade300;
        }),
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.transparent,
        iconColor: onSurfaceMuted,
        textColor: onSurface,
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: onSurfaceMuted,
        indicatorColor: primary,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 14),
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? card : const Color(0xFF323232),
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontSize: 12,
        ),
      ),

      // Extensions for custom colors
      extensions: [
        CustomColors(
          success: success,
          warning: warning,
          gradient: LinearGradient(
            colors: [primary, secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ],
    );
  }

  static TextTheme _buildTextTheme(
    Brightness brightness,
    Color color,
    Color muted,
  ) {
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        color: color,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: color,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: color,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: color,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: color,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: muted,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: muted,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: muted,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: color,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: color,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: muted,
      ),
    );
  }

  static Color _contrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Custom colors extension for success, warning, and gradients
class CustomColors extends ThemeExtension<CustomColors> {
  final Color success;
  final Color warning;
  final LinearGradient gradient;

  const CustomColors({
    required this.success,
    required this.warning,
    required this.gradient,
  });

  @override
  CustomColors copyWith({
    Color? success,
    Color? warning,
    LinearGradient? gradient,
  }) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      gradient: LinearGradient.lerp(gradient, other.gradient, t)!,
    );
  }
}

/// Extension to easily access custom colors
extension CustomColorsExtension on ThemeData {
  CustomColors get customColors => extension<CustomColors>()!;
}
