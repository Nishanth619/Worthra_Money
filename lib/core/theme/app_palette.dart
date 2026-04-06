import 'package:flutter/material.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerLow,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceContainerLowest,
    required this.outlineVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.primary,
    required this.primaryContainer,
    required this.primarySoft,
    required this.onPrimary,
    required this.secondary,
    required this.secondarySoft,
    required this.tertiary,
    required this.tertiarySoft,
    required this.warning,
    required this.success,
    required this.shadow,
    required this.shadowStrong,
    required this.navBackground,
    required this.navSelectedBackground,
    required this.destructiveSoft,
    required this.backdrop,
  });

  final Color background;
  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerLow;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceContainerLowest;
  final Color outlineVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color primary;
  final Color primaryContainer;
  final Color primarySoft;
  final Color onPrimary;
  final Color secondary;
  final Color secondarySoft;
  final Color tertiary;
  final Color tertiarySoft;
  final Color warning;
  final Color success;
  final Color shadow;
  final Color shadowStrong;
  final Color navBackground;
  final Color navSelectedBackground;
  final Color destructiveSoft;
  final Color backdrop;

  static const light = AppPalette(
    background: Color(0xFFF8F9FA),
    surface: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF3F4F5),
    surfaceContainerHigh: Color(0xFFE4E8E6),
    surfaceContainerHighest: Color(0xFFEDEEEF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    outlineVariant: Color(0xFFBCCAC2),
    textPrimary: Color(0xFF191C1D),
    textSecondary: Color(0xFF3D4A43),
    textMuted: Color(0xFF6E7C74),
    primary: Color(0xFF006C51),
    primaryContainer: Color(0xFF10AC84),
    primarySoft: Color(0xFFD8F5EC),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFE8776B),
    secondarySoft: Color(0xFFFCE1DD),
    tertiary: Color(0xFF6B7CFF),
    tertiarySoft: Color(0xFFE7EAFF),
    warning: Color(0xFFFFB85C),
    success: Color(0xFF10AC84),
    shadow: Color(0x14191C1D),
    shadowStrong: Color(0x1F191C1D),
    navBackground: Color(0xEBFFFFFF),
    navSelectedBackground: Color(0xFFD8F5EC),
    destructiveSoft: Color(0xFFFCE1DD),
    backdrop: Color(0xF2F8F9FA),
  );

  static const dark = AppPalette(
    background: Color(0xFF131313),
    surface: Color(0xFF201F1F),
    surfaceContainer: Color(0xFF201F1F),
    surfaceContainerLow: Color(0xFF1C1B1B),
    surfaceContainerHigh: Color(0xFF2A2A2A),
    surfaceContainerHighest: Color(0xFF353534),
    surfaceContainerLowest: Color(0xFF0E0E0E),
    outlineVariant: Color(0xFF3C4A42),
    textPrimary: Color(0xFFE5E2E1),
    textSecondary: Color(0xFFBBCABF),
    textMuted: Color(0xFF86948A),
    primary: Color(0xFF4EDEA3),
    primaryContainer: Color(0xFF10B981),
    primarySoft: Color(0x1A4EDEA3),
    onPrimary: Color(0xFF003824),
    secondary: Color(0xFFFFB3B0),
    secondarySoft: Color(0x1F881D24),
    tertiary: Color(0xFFC0C1FF),
    tertiarySoft: Color(0x269699FF),
    warning: Color(0xFFFFB85C),
    success: Color(0xFF10B981),
    shadow: Color(0x66000000),
    shadowStrong: Color(0x99000000),
    navBackground: Color(0xCC201F1F),
    navSelectedBackground: Color(0xFF353534),
    destructiveSoft: Color(0x26881D24),
    backdrop: Color(0xCC0E0E0E),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceContainer,
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? surfaceContainerLowest,
    Color? outlineVariant,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? primary,
    Color? primaryContainer,
    Color? primarySoft,
    Color? onPrimary,
    Color? secondary,
    Color? secondarySoft,
    Color? tertiary,
    Color? tertiarySoft,
    Color? warning,
    Color? success,
    Color? shadow,
    Color? shadowStrong,
    Color? navBackground,
    Color? navSelectedBackground,
    Color? destructiveSoft,
    Color? backdrop,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      primarySoft: primarySoft ?? this.primarySoft,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      secondarySoft: secondarySoft ?? this.secondarySoft,
      tertiary: tertiary ?? this.tertiary,
      tertiarySoft: tertiarySoft ?? this.tertiarySoft,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      shadow: shadow ?? this.shadow,
      shadowStrong: shadowStrong ?? this.shadowStrong,
      navBackground: navBackground ?? this.navBackground,
      navSelectedBackground:
          navSelectedBackground ?? this.navSelectedBackground,
      destructiveSoft: destructiveSoft ?? this.destructiveSoft,
      backdrop: backdrop ?? this.backdrop,
    );
  }

  @override
  ThemeExtension<AppPalette> lerp(
    covariant ThemeExtension<AppPalette>? other,
    double t,
  ) {
    if (other is! AppPalette) {
      return this;
    }

    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t) ?? a;

    return AppPalette(
      background: lerpColor(background, other.background),
      surface: lerpColor(surface, other.surface),
      surfaceContainer: lerpColor(surfaceContainer, other.surfaceContainer),
      surfaceContainerLow: lerpColor(
        surfaceContainerLow,
        other.surfaceContainerLow,
      ),
      surfaceContainerHigh: lerpColor(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
      ),
      surfaceContainerHighest: lerpColor(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
      ),
      surfaceContainerLowest: lerpColor(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
      ),
      outlineVariant: lerpColor(outlineVariant, other.outlineVariant),
      textPrimary: lerpColor(textPrimary, other.textPrimary),
      textSecondary: lerpColor(textSecondary, other.textSecondary),
      textMuted: lerpColor(textMuted, other.textMuted),
      primary: lerpColor(primary, other.primary),
      primaryContainer: lerpColor(primaryContainer, other.primaryContainer),
      primarySoft: lerpColor(primarySoft, other.primarySoft),
      onPrimary: lerpColor(onPrimary, other.onPrimary),
      secondary: lerpColor(secondary, other.secondary),
      secondarySoft: lerpColor(secondarySoft, other.secondarySoft),
      tertiary: lerpColor(tertiary, other.tertiary),
      tertiarySoft: lerpColor(tertiarySoft, other.tertiarySoft),
      warning: lerpColor(warning, other.warning),
      success: lerpColor(success, other.success),
      shadow: lerpColor(shadow, other.shadow),
      shadowStrong: lerpColor(shadowStrong, other.shadowStrong),
      navBackground: lerpColor(navBackground, other.navBackground),
      navSelectedBackground: lerpColor(
        navSelectedBackground,
        other.navSelectedBackground,
      ),
      destructiveSoft: lerpColor(destructiveSoft, other.destructiveSoft),
      backdrop: lerpColor(backdrop, other.backdrop),
    );
  }
}
