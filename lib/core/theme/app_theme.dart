import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme extends ThemeExtension<AppTheme> {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color onBackground;

  const AppTheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.onBackground,
  });

  static const defaultTheme = AppTheme(
    primary: Color(0xFF1E1B4B),
    secondary: Color(0xFF006C4B),
    accent: Color(0xFF64F9BC),
    background: Color(0xFFF8F9FA),
    onBackground: Color(0xFF191C1D),
  );

  @override
  ThemeExtension<AppTheme> copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? background,
    Color? onBackground,
  }) {
    return AppTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
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
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: defaultTheme.background,
      colorScheme: ColorScheme.light(
        primary: defaultTheme.primary,
        secondary: defaultTheme.secondary,
        surface: defaultTheme.background,
        onSurface: defaultTheme.onBackground,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 56, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 45, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 36, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 32, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 28, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.manrope(color: defaultTheme.onBackground, fontSize: 24, fontWeight: FontWeight.w600),
      ),
      extensions: [defaultTheme],
    );
  }
}
