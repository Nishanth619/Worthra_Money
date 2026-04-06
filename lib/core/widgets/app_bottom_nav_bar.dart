import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/theme_extensions.dart';
import '../utils/l10n_extension.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final colors = context.appPalette;
    final l10n = context.l10n;

    final items = [
      _NavItem(label: l10n.navHome, icon: Icons.home_rounded),
      _NavItem(label: l10n.navHistory, icon: Icons.receipt_long_rounded),
      _NavItem(label: l10n.navGoals, icon: Icons.track_changes_rounded),
      _NavItem(label: l10n.navInsights, icon: Icons.insights_rounded),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset == 0 ? 12 : 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.navBackground,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 34,
                    offset: const Offset(0, 12),
                  ),
                ],
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.18),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final selected = index == currentIndex;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => onTap(index),
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? colors.navSelectedBackground
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  item.icon,
                                  size: 22,
                                  color: selected
                                      ? colors.primary
                                      : colors.textMuted,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: selected
                                            ? colors.primary
                                            : colors.textMuted,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
