import 'package:flutter/material.dart';

import '../constants/typography.dart';
import 'app_palette.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get crispAlabasterTheme {
    const palette = AppPalette.light;
    final colorScheme = ColorScheme.light(
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      secondary: palette.secondary,
      onSecondary: palette.textPrimary,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      error: Color(0xFFC75C5C),
      onError: palette.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: palette.background,
      textTheme: _themedTextTheme(palette),
      canvasColor: palette.background,
      cardColor: palette.surface,
      dividerColor: palette.outlineVariant.withValues(alpha: 0.24),
      extensions: const [palette],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        shadowColor: palette.shadow,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primaryContainer,
        foregroundColor: palette.onPrimary,
        elevation: 0,
        shape: const CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: palette.primary.withValues(alpha: 0.24),
          ),
        ),
        hintStyle: AppTypography.baseTextTheme.bodyMedium?.copyWith(
          color: palette.textMuted,
        ),
      ),
    );
  }

  static ThemeData get midnightLedgerTheme {
    const palette = AppPalette.dark;
    final colorScheme = ColorScheme.dark(
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      secondary: palette.secondary,
      onSecondary: palette.textPrimary,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      error: Color(0xFFFF8D8D),
      onError: Color(0xFF2C1111),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: palette.background,
      textTheme: _themedTextTheme(palette),
      canvasColor: palette.background,
      cardColor: palette.surface,
      dividerColor: palette.outlineVariant,
      extensions: const [palette],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        shadowColor: palette.shadow,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primaryContainer,
        foregroundColor: palette.onPrimary,
        elevation: 0,
        shape: const CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: palette.primary.withValues(alpha: 0.3)),
        ),
        hintStyle: AppTypography.baseTextTheme.bodyMedium?.copyWith(
          color: palette.textMuted,
        ),
      ),
    );
  }

  static TextTheme _themedTextTheme(AppPalette palette) {
    return AppTypography.baseTextTheme.copyWith(
      displayLarge: AppTypography.baseTextTheme.displayLarge?.copyWith(
        color: palette.textPrimary,
      ),
      displayMedium: AppTypography.baseTextTheme.displayMedium?.copyWith(
        color: palette.textPrimary,
      ),
      displaySmall: AppTypography.baseTextTheme.displaySmall?.copyWith(
        color: palette.textPrimary,
      ),
      headlineLarge: AppTypography.baseTextTheme.headlineLarge?.copyWith(
        color: palette.textPrimary,
      ),
      headlineMedium: AppTypography.baseTextTheme.headlineMedium?.copyWith(
        color: palette.textPrimary,
      ),
      titleLarge: AppTypography.baseTextTheme.titleLarge?.copyWith(
        color: palette.textPrimary,
      ),
      titleMedium: AppTypography.baseTextTheme.titleMedium?.copyWith(
        color: palette.textPrimary,
      ),
      bodyLarge: AppTypography.baseTextTheme.bodyLarge?.copyWith(
        color: palette.textPrimary,
      ),
      bodyMedium: AppTypography.baseTextTheme.bodyMedium?.copyWith(
        color: palette.textSecondary,
      ),
      bodySmall: AppTypography.baseTextTheme.bodySmall?.copyWith(
        color: palette.textMuted,
      ),
      labelLarge: AppTypography.baseTextTheme.labelLarge?.copyWith(
        color: palette.textPrimary,
      ),
      labelMedium: AppTypography.baseTextTheme.labelMedium?.copyWith(
        color: palette.textSecondary,
      ),
      labelSmall: AppTypography.baseTextTheme.labelSmall?.copyWith(
        color: palette.textMuted,
      ),
    );
  }
}
