import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../models/app_settings.dart';
import '../../../state/auth_provider.dart';
import '../../../state/settings_provider.dart';
import '../../../state/sync_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final settingsAsync = ref.watch(settingsProvider);
    final controllerState = ref.watch(settingsControllerProvider);
    final authUser = ref.watch(authControllerProvider).asData?.value;
    final syncStatus = ref.watch(syncControllerProvider).asData?.value;
    final l10n = context.l10n;

    ref.listen(settingsControllerProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    ref.listen(syncControllerProvider, (_, next) {
      next.whenData((status) {
        if (status == SyncStatus.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.syncSuccessMessage)));
        } else if (status == SyncStatus.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.syncErrorMessage)));
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: settingsAsync.when(
          data: (settings) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: colors.surfaceContainer,
                      foregroundColor: colors.textPrimary,
                    ),
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const Spacer(),
                  Text(l10n.settingsTitle, style: textTheme.headlineMedium),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () =>
                    _showProfileSheet(context, ref, authUser, settings),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          shape: BoxShape.circle,
                          gradient: authUser != null
                              ? LinearGradient(
                                  colors: [
                                    colors.primary,
                                    colors.primaryContainer,
                                  ],
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadowStrong,
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: authUser != null
                              ? Text(
                                  authUser.displayInitial,
                                  style: textTheme.displayMedium?.copyWith(
                                    color: colors.onPrimary,
                                  ),
                                )
                              : Icon(
                                  _kAvatars[settings.localUserAvatarIndex %
                                      _kAvatars.length],
                                  size: 48,
                                  color: colors.primary,
                                ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            authUser?.name ??
                                settings.localUserName ??
                                l10n.guestUserName,
                            style: textTheme.headlineMedium,
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: colors.textMuted,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authUser?.email ?? l10n.appTagline,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ------------- Sync -------------
              _SettingsSection(
                title: l10n.syncSection,
                children: [
                  _SettingsRow(
                    icon: syncStatus == SyncStatus.syncing
                        ? Icons.sync_rounded
                        : Icons.cloud_sync_rounded,
                    title: syncStatus == SyncStatus.syncing
                        ? l10n.syncingLabel
                        : l10n.syncNowLabel,
                    trailingText: _lastSyncedLabel(
                      settings,
                      l10n.neverSyncedLabel,
                    ),
                    onTap: syncStatus == SyncStatus.syncing
                        ? null
                        : () => ref
                              .read(syncControllerProvider.notifier)
                              .triggerSync(),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ───────────── Account (only shown when signed in) ─────────────
              if (authUser != null) ...[
                _SettingsSection(
                  title: l10n.accountSection,
                  children: [
                    _SettingsRow(
                      icon: Icons.person_outline_rounded,
                      title: authUser.email,
                    ),
                    _SettingsRow(
                      icon: Icons.logout_rounded,
                      title: l10n.signOutLabel,
                      onTap: () => _confirmSignOut(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],

              // ───────────── Preferences ─────────────
              _SettingsSection(
                title: l10n.preferencesSection,
                children: [
                  _ThemeRow(
                    selectedTheme: AppThemePreferenceX.fromStorage(
                      settings.themeMode,
                    ),
                    onThemeChanged: (theme) => ref
                        .read(settingsControllerProvider.notifier)
                        .setThemeMode(theme),
                  ),
                  _SettingsRow(
                    icon: Icons.payments_rounded,
                    title: l10n.currencyLabel,
                    trailingText:
                        '${settings.currencyCode} (${settings.currencySymbol})',
                    onTap: () => _showCurrencySheet(context, ref, settings),
                  ),
                  _SettingsRow(
                    icon: Icons.language_rounded,
                    title: l10n.languageLabel,
                    trailingText: AppLanguagePreferenceX.fromStorage(
                      settings.languageCode,
                    ).displayName,
                    onTap: () => _showLanguageSheet(context, ref, settings),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ───────────── Security & Data ─────────────
              _SettingsSection(
                title: l10n.remindersSection,
                children: [
                  _ToggleRow(
                    icon: Icons.notifications_active_rounded,
                    title: l10n.dailyReminderLabel,
                    value: settings.dailyReminderEnabled,
                    onChanged: controllerState.isLoading
                        ? null
                        : (value) => ref
                              .read(settingsControllerProvider.notifier)
                              .setDailyReminderEnabled(value),
                  ),
                  if (settings.dailyReminderEnabled)
                    _SettingsRow(
                      icon: Icons.schedule_rounded,
                      title: l10n.reminderTimeLabel,
                      trailingText: _formatReminderTime(context, settings),
                      onTap: controllerState.isLoading
                          ? null
                          : () => _pickReminderTime(context, ref, settings),
                    ),
                ],
              ),
              const SizedBox(height: 18),

              _SettingsSection(
                title: l10n.securityDataSection,
                children: [
                  _ToggleRow(
                    icon: Icons.fingerprint_rounded,
                    title: l10n.biometricLockLabel,
                    value: settings.biometricLockEnabled,
                    onChanged: controllerState.isLoading
                        ? null
                        : (value) => ref
                              .read(settingsControllerProvider.notifier)
                              .setBiometricLock(value),
                  ),
                  _SettingsRow(
                    icon: Icons.download_rounded,
                    title: controllerState.isLoading
                        ? l10n.exportingLabel
                        : l10n.exportCsvLabel,
                    onTap: controllerState.isLoading
                        ? null
                        : () => _exportTransactions(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ------------- About -------------
              _SettingsSection(
                title: l10n.aboutSection,
                children: [
                  _SettingsRow(
                    icon: Icons.shield_rounded,
                    title: l10n.privacyPolicyLabel,
                    onTap: () => _showInfoDialog(
                      context,
                      title: l10n.privacyPolicyLabel,
                      body: l10n.privacyPolicyBody,
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.description_rounded,
                    title: l10n.termsLabel,
                    onTap: () => _showInfoDialog(
                      context,
                      title: l10n.termsLabel,
                      body: l10n.termsBody,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: controllerState.isLoading
                    ? null
                    : () => _confirmDeleteAllData(context, ref),
                style: TextButton.styleFrom(
                  foregroundColor: colors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: colors.destructiveSoft.withValues(
                    alpha: 0.55,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text(l10n.deleteAccountButton),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  l10n.appVersion,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }

  String _lastSyncedLabel(AppSettings settings, String neverLabel) {
    final raw = settings.lastSyncAt;
    if (raw == null) return neverLabel;
    final dt = DateTime.tryParse(raw);
    if (dt == null) return neverLabel;
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _formatReminderTime(BuildContext context, AppSettings settings) {
    final time = TimeOfDay(
      hour: settings.dailyReminderHour,
      minute: settings.dailyReminderMinute,
    );
    return MaterialLocalizations.of(context).formatTimeOfDay(
      time,
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    this.trailingText,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: colors.primary),
      ),
      title: Text(title, style: textTheme.titleMedium),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText!, style: textTheme.bodyMedium),
          const SizedBox(width: 6),
          Icon(Icons.chevron_right_rounded, color: colors.textMuted),
        ],
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  const _ThemeRow({required this.selectedTheme, required this.onThemeChanged});

  final AppThemePreference selectedTheme;
  final ValueChanged<AppThemePreference> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.light_mode_rounded, color: colors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(l10n.themeLabel, style: textTheme.titleMedium)),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ThemeChip(
                  label: l10n.themeLightLabel,
                  selected: selectedTheme == AppThemePreference.light,
                  onTap: () => onThemeChanged(AppThemePreference.light),
                ),
                _ThemeChip(
                  label: l10n.themeDarkLabel,
                  selected: selectedTheme == AppThemePreference.dark,
                  onTap: () => onThemeChanged(AppThemePreference.dark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? colors.onPrimary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;

    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      title: Text(title, style: textTheme.titleMedium),
      secondary: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: colors.primary),
      ),
      activeThumbColor: colors.surfaceContainerLowest,
      activeTrackColor: colors.primary,
      inactiveTrackColor: colors.surfaceContainerHighest,
    );
  }
}

Future<void> _showCurrencySheet(
  BuildContext context,
  WidgetRef ref,
  AppSettings settings,
) async {
  final colors = context.appPalette;
  const currencyOptions = [
    ('USD', r'$'),
    ('INR', '\u20B9'),
    ('EUR', '\u20AC'),
    ('GBP', '\u00A3'),
  ];

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: currencyOptions.map((option) {
              final selected =
                  settings.currencyCode == option.$1 &&
                  settings.currencySymbol == option.$2;
              return ListTile(
                title: Text('${option.$1} (${option.$2})'),
                trailing: selected
                    ? Icon(Icons.check_rounded, color: colors.primary)
                    : null,
                onTap: () async {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .setCurrency(
                        currencyCode: option.$1,
                        currencySymbol: option.$2,
                      );
                  if (sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}

Future<void> _pickReminderTime(
  BuildContext context,
  WidgetRef ref,
  AppSettings settings,
) async {
  final selected = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(
      hour: settings.dailyReminderHour,
      minute: settings.dailyReminderMinute,
    ),
  );

  if (selected == null) {
    return;
  }

  await ref
      .read(settingsControllerProvider.notifier)
      .setDailyReminderTime(selected);
}

Future<void> _exportTransactions(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  try {
    final path = await ref
        .read(settingsControllerProvider.notifier)
        .exportTransactionsCsv();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.csvExportedMessage(path))));
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

void _showInfoDialog(
  BuildContext context, {
  required String title,
  required String body,
}) {
  final l10n = context.l10n;
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.closeButton),
          ),
        ],
      );
    },
  );
}

Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.signOutLabel),
          ),
        ],
      );
    },
  );

  if (confirmed != true) return;
  await ref.read(authControllerProvider.notifier).logout();
}

Future<void> _confirmDeleteAllData(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.deleteAllDataTitle),
        content: Text(l10n.deleteAllDataContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.deleteButton),
          ),
        ],
      );
    },
  );

  if (confirmed != true) {
    return;
  }

  try {
    await ref.read(settingsControllerProvider.notifier).clearAllData();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.dataClearedMessage)));
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

Future<void> _showLanguageSheet(
  BuildContext context,
  WidgetRef ref,
  AppSettings settings,
) async {
  final colors = context.appPalette;
  const languages = AppLanguagePreference.values;
  final current = AppLanguagePreferenceX.fromStorage(settings.languageCode);

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              final selected = lang == current;
              return ListTile(
                title: Text(lang.displayName),
                trailing: selected
                    ? Icon(Icons.check_rounded, color: colors.primary)
                    : null,
                onTap: () async {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .setLanguage(lang);
                  if (sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}

const List<IconData> _kAvatars = [
  Icons.face_rounded,
  Icons.sentiment_satisfied_rounded,
  Icons.pets_rounded,
  Icons.rocket_launch_rounded,
  Icons.local_florist_rounded,
  Icons.directions_car_rounded,
  Icons.sports_esports_rounded,
  Icons.coffee_rounded,
  Icons.music_note_rounded,
  Icons.star_rounded,
  Icons.wb_sunny_rounded,
  Icons.dark_mode_rounded,
];

Future<void> _showProfileSheet(
  BuildContext context,
  WidgetRef ref,
  AuthUser? authUser,
  AppSettings settings,
) async {
  final l10n = context.l10n;
  final colors = context.appPalette;
  final textTheme = Theme.of(context).textTheme;

  // Local state for the sheet
  var selectedAvatar = settings.localUserAvatarIndex;
  final nameController = TextEditingController(
    text: settings.localUserName ?? '',
  );

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AnimatedPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Edit Profile',
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      if (authUser != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: colors.primarySoft,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'You are signed in with the cloud. Your local avatar will only display when completely offline.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.primary,
                            ),
                          ),
                        ),
                      Text('Choose an Avatar', style: textTheme.labelMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(_kAvatars.length, (i) {
                          final isSelected = selectedAvatar == i;
                          return InkWell(
                            onTap: () => setState(() => selectedAvatar = i),
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colors.primary
                                    : colors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? colors.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                _kAvatars[i],
                                color: isSelected
                                    ? colors.onPrimary
                                    : colors.primary,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      Text('Display Name', style: textTheme.labelMedium),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: l10n.guestUserName,
                          filled: true,
                          fillColor: colors.surfaceContainerLowest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          await ref
                              .read(settingsControllerProvider.notifier)
                              .setLocalProfile(
                                name: nameController.text.trim().isEmpty
                                    ? null
                                    : nameController.text.trim(),
                                avatarIndex: selectedAvatar,
                              );
                          if (sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          }
                        },
                        child: const Text('Save Profile'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
