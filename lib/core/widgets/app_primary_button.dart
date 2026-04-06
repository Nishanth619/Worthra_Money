import 'package:flutter/material.dart';

import '../theme/theme_extensions.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.padding,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appPalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [colors.primary, colors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
        child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: colors.onPrimary,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.onPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
