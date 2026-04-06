// Golden test for the balance card section of the dashboard, tested via
// provider overrides on DashboardScreen.
//
// Run with:
//   flutter test --update-goldens test/goldens/balance_card_golden_test.dart

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:personal_finance_app/models/transaction.dart';
import 'package:personal_finance_app/state/dashboard_state.dart';
import 'package:personal_finance_app/state/dashboard_summary.dart';
import 'package:personal_finance_app/state/settings_provider.dart';
import 'package:personal_finance_app/state/transactions_provider.dart';
import 'package:personal_finance_app/features/dashboard/presentation/dashboard_screen.dart'
    show DashboardScreen, authUserNameProvider;

import '../helpers/golden_test_helpers.dart';

// ---------------------------------------------------------------------------
// Fake notifiers
// ---------------------------------------------------------------------------

/// A [DashboardStateNotifier] that skips the Isar repository and returns a
/// fixed [DashboardSummary] value immediately.
class _FakeDataNotifier extends DashboardStateNotifier {
  _FakeDataNotifier(this._summary);
  final DashboardSummary _summary;

  @override
  Future<DashboardSummary> build() async => _summary;
}

/// A [DashboardStateNotifier] that stays indefinitely in loading state,
/// useful for testing skeleton / shimmer UI.
class _FakeLoadingNotifier extends DashboardStateNotifier {
  @override
  Future<DashboardSummary> build() => Completer<DashboardSummary>().future;
}

// ---------------------------------------------------------------------------
// Helpers: shared test summary & common overrides
// ---------------------------------------------------------------------------

const _kTestSummary = DashboardSummary(
  currentBalance: 4570.50,
  monthlyIncome: 5850.00,
  monthlyExpense: 1279.50,
);

/// Provider overrides shared by every dashboard golden test.
List _dashboardOverrides({
  required DashboardStateNotifier Function() notifierFactory,
}) {
  return [
    dashboardStateProvider.overrideWith(notifierFactory),
    // transactionsProvider is a FutureProvider — override with empty list so
    // the TrendCard renders its fallback shape without hitting the database.
    transactionsProvider.overrideWith((ref) async => <Transaction>[]),
    currencySymbolProvider.overrideWithValue(r'$'),
    authUserNameProvider.overrideWith((ref) => 'Nishanth'),
  ];
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('BalanceCard golden (via DashboardScreen override)', () {
    testWidgets('light — positive balance', (tester) async {
      await pumpGoldenWidget(
        tester,
        const DashboardScreen(
          onAvatarTap: _noop,
          onViewAllTap: _noop,
          onStatusTap: _noop,
        ),
        overrides: _dashboardOverrides(
          notifierFactory: () => _FakeDataNotifier(_kTestSummary),
        ),
      );
      await expectLater(
        find.byType(DashboardScreen),
        matchesGoldenFile('goldens/balance_card_light_positive.png'),
      );
    });

    testWidgets('dark — positive balance', (tester) async {
      await pumpDarkGoldenWidget(
        tester,
        const DashboardScreen(
          onAvatarTap: _noop,
          onViewAllTap: _noop,
          onStatusTap: _noop,
        ),
        overrides: _dashboardOverrides(
          notifierFactory: () => _FakeDataNotifier(_kTestSummary),
        ),
      );
      await expectLater(
        find.byType(DashboardScreen),
        matchesGoldenFile('goldens/balance_card_dark_positive.png'),
      );
    });

    testWidgets('light — loading state', (tester) async {
      await pumpGoldenWidget(
        tester,
        const DashboardScreen(
          onAvatarTap: _noop,
          onViewAllTap: _noop,
          onStatusTap: _noop,
        ),
        overrides: _dashboardOverrides(
          notifierFactory: _FakeLoadingNotifier.new,
        ),
      );
      await expectLater(
        find.byType(DashboardScreen),
        matchesGoldenFile('goldens/balance_card_light_loading.png'),
      );
    });
  });
}

void _noop() {}
