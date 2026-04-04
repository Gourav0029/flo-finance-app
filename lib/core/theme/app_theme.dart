import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme extends ThemeExtension<AppTheme> {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color onBackground;
  final Color onSurfaceVariant;

  const AppTheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.onBackground,
    required this.onSurfaceVariant,
  });

  static const defaultTheme = AppTheme(
    primary: Color(0xFF1E1B4B),
    secondary: Color(0xFF006C4B),
    accent: Color(0xFF64F9BC),
    background: Color(0xFFF8F9FA),
    surface: Colors.white,
    onBackground: Color(0xFF191C1D),
    onSurfaceVariant: Color(0xFF757575),
  );

  static const darkCustomTheme = AppTheme(
    primary: Color(0xFF3D3A8C),
    secondary: Color(0xFF006C4B),
    accent: Color(0xFF64F9BC),
    background: Color(0xFF0F0F1A),
    surface: Color(0xFF1A1A2E),
    onBackground: Color(0xFFF8F9FA),
    onSurfaceVariant: Color(0xFF9E9E9E),
  );

  @override
  ThemeExtension<AppTheme> copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? background,
    Color? surface,
    Color? onBackground,
    Color? onSurfaceVariant,
  }) {
    return AppTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onBackground: onBackground ?? this.onBackground,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
    );
  }

  @override
  ThemeExtension<AppTheme> lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) return this;
    return AppTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: defaultTheme.background,
      colorScheme: ColorScheme.light(
        primary: defaultTheme.primary,
        secondary: defaultTheme.secondary,
        surface: defaultTheme.surface,
        onSurface: defaultTheme.onBackground,
        onSurfaceVariant: defaultTheme.onSurfaceVariant,
        surfaceContainerHighest: const Color(0xFFF5F5F5),
        surfaceContainerHigh: const Color(0xFFEEEEEE),
        surfaceContainer: Colors.white,
        shadow: Colors.black,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 56, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 45, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 36, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 32, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 28, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 24, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: defaultTheme.onBackground),
        bodyMedium: GoogleFonts.inter(color: defaultTheme.onBackground),
        titleMedium: GoogleFonts.inter(color: defaultTheme.onBackground),
        titleSmall: GoogleFonts.inter(color: defaultTheme.onSurfaceVariant),
      ),
      extensions: const [defaultTheme],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkCustomTheme.background,
      colorScheme: ColorScheme.dark(
        primary: darkCustomTheme.primary,
        secondary: const Color(0xFF64F9BC),
        surface: darkCustomTheme.surface,
        onSurface: darkCustomTheme.onBackground,
        onSurfaceVariant: darkCustomTheme.onSurfaceVariant,
        surfaceContainerHighest: const Color(0xFF1A1A2E),
        surfaceContainerHigh: const Color(0xFF252540),
        surfaceContainer: const Color(0xFF1E1E35),
        shadow: Colors.black,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E35),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Color(0xFF1E1E35),
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.manrope(color: darkCustomTheme.onBackground, fontSize: 56, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.manrope(color: darkCustomTheme.onBackground, fontSize: 45, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.manrope(color: darkCustomTheme.onBackground, fontSize: 36, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.manrope(color: darkCustomTheme.onBackground, fontSize: 32, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.manrope(color: darkCustomTheme.onBackground, fontSize: 28, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.manrope(color: darkCustomTheme.onBackground, fontSize: 24, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: darkCustomTheme.onBackground),
        bodyMedium: GoogleFonts.inter(color: darkCustomTheme.onBackground),
        titleMedium: GoogleFonts.inter(color: darkCustomTheme.onBackground),
        titleSmall: GoogleFonts.inter(color: darkCustomTheme.onSurfaceVariant),
      ),
      extensions: const [darkCustomTheme],
    );
  }
}

