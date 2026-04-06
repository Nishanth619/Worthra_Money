import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/goals/presentation/goals_screen.dart';
import '../../features/insights/presentation/insights_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/transactions/presentation/transaction_history_screen.dart';
import '../../features/transactions/widgets/add_transaction_sheet.dart';
import '../theme/theme_extensions.dart';
import '../utils/l10n_extension.dart';
import '../../state/goals_provider.dart';
import '../../state/transactions_provider.dart';
import 'app_bottom_nav_bar.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _currentIndex = 0;

  bool get _showsTransactionFab => _currentIndex == 0 || _currentIndex == 1;

  void _openSettings() {
    Navigator.of(context).pushNamed(SettingsScreen.routeName);
  }

  void _openAddTransactionSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }

  void _openTransactionsTab() {
    setState(() => _currentIndex = 1);
  }

  void _openStatusSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final colors = context.appPalette;
          final l10n = context.l10n;
          final transactionsAsync = ref.watch(transactionsProvider);
          final goalsAsync = ref.watch(allGoalsProvider);

          return SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.vaultStatusTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  _StatusRow(
                    label: l10n.transactionsLabel,
                    value: transactionsAsync.maybeWhen(
                      data: (items) => '${items.length}',
                      orElse: () => '...',
                    ),
                  ),
                  _StatusRow(
                    label: l10n.goalsLabel,
                    value: goalsAsync.maybeWhen(
                      data: (items) => '${items.length}',
                      orElse: () => '...',
                    ),
                  ),
                  _StatusRow(
                    label: l10n.storageLabel,
                    value: l10n.localStorageValue,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        onAvatarTap: _openSettings,
        onViewAllTap: _openTransactionsTab,
        onStatusTap: _openStatusSheet,
      ),
      const TransactionHistoryScreen(),
      const GoalsScreen(),
      const InsightsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      floatingActionButton: _showsTransactionFab
          ? FloatingActionButton(
              onPressed: _openAddTransactionSheet,
              child: const Icon(Icons.add_rounded, size: 30),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
