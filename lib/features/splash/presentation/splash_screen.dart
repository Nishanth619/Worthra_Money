import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../l10n/app_localizations.dart';

const _brandAssetPath = 'assets/logo.png';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _pulseController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _liftAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..forward();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutBack,
      ),
    );
    _liftAnimation = Tween<double>(
      begin: 18,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundTop = isDark
        ? const Color(0xFF07150F)
        : const Color(0xFF0C4A2E);
    final backgroundBottom = isDark
        ? const Color(0xFF020705)
        : const Color(0xFF052C1C);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundTop, backgroundBottom],
            ),
          ),
          child: SafeArea(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _entryController,
                _pulseController,
              ]),
              builder: (context, _) {
                final pulse = 0.5 + (math.sin(_pulseController.value * math.pi * 2) * 0.5);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _SplashBackdrop(
                      pulse: pulse,
                      primaryGlow: palette.primaryContainer,
                      accentGlow: palette.tertiary,
                    ),
                    Center(
                      child: Transform.translate(
                        offset: Offset(0, _liftAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value.clamp(0, 1),
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 360),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _BrandMark(
                                      pulse: pulse,
                                      glowColor: palette.primaryContainer,
                                    ),
                                    const SizedBox(height: 28),
                                    Text(
                                      l10n.appBrandName,
                                      textAlign: TextAlign.center,
                                      style: textTheme.titleMedium?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.78),
                                        letterSpacing: 3.2,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      l10n.appName,
                                      textAlign: TextAlign.center,
                                      style: textTheme.displaySmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      l10n.appTagline,
                                      textAlign: TextAlign.center,
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.74),
                                        height: 1.45,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    _LoadingBar(
                                      progress: pulse,
                                      trackColor: Colors.white.withValues(alpha: 0.12),
                                      fillColor: palette.primaryContainer,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashBackdrop extends StatelessWidget {
  const _SplashBackdrop({
    required this.pulse,
    required this.primaryGlow,
    required this.accentGlow,
  });

  final double pulse;
  final Color primaryGlow;
  final Color accentGlow;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -70,
          left: -30,
          child: _GlowOrb(
            size: 250 + (pulse * 24),
            color: primaryGlow.withValues(alpha: 0.18),
          ),
        ),
        Positioned(
          right: -60,
          bottom: 70,
          child: _GlowOrb(
            size: 220 + ((1 - pulse) * 22),
            color: accentGlow.withValues(alpha: 0.12),
          ),
        ),
        Positioned(
          left: 38,
          right: 38,
          bottom: 60,
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({
    required this.pulse,
    required this.glowColor,
  });

  final double pulse;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    final glowSize = 184 + (pulse * 18);

    return Semantics(
      label: 'Loading ${AppLocalizations.of(context).appName}',
      image: true,
      child: SizedBox(
        width: 204,
        height: 204,
        child: Stack(
          alignment: Alignment.center,
          children: [
            IgnorePointer(
              child: Container(
                width: glowSize,
                height: glowSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      glowColor.withValues(alpha: 0.28),
                      glowColor.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 34,
                    offset: Offset(0, 22),
                    spreadRadius: -18,
                  ),
                ],
              ),
              child: Image.asset(
                _brandAssetPath,
                width: 176,
                height: 176,
                fit: BoxFit.contain,
                gaplessPlayback: true,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 176,
                    height: 176,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF10AC84),
                          Color(0xFF006C51),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(36)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.trending_up_rounded,
                        color: Colors.white,
                        size: 84,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
  });

  final double progress;
  final Color trackColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    final widthFactor = 0.32 + (progress * 0.3);

    return Container(
      width: 144,
      height: 6,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: widthFactor.clamp(0.18, 0.9),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  fillColor.withValues(alpha: 0.72),
                  fillColor,
                ],
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }
}
