import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  static final TextTheme baseTextTheme = TextTheme(
    displayLarge: const TextStyle(
      fontSize: 40,
      height: 1.05,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.2,
    ),
    displayMedium: const TextStyle(
      fontSize: 32,
      height: 1.1,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
    ),
    displaySmall: const TextStyle(
      fontSize: 28,
      height: 1.1,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.6,
    ),
    headlineLarge: const TextStyle(
      fontSize: 28,
      height: 1.15,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.6,
    ),
    headlineMedium: const TextStyle(
      fontSize: 24,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      height: 1.2,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      height: 1.35,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      height: 1.45,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      height: 1.5,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: const TextStyle(
      fontSize: 12,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: const TextStyle(
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w700,
    ),
    labelMedium: const TextStyle(
      fontSize: 12,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
    ),
    labelSmall: const TextStyle(
      fontSize: 10,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.6,
    ),
  );
}
