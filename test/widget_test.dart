import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/core/widgets/app_lock_gate.dart';
import 'package:personal_finance_app/features/splash/presentation/splash_screen.dart';
import 'package:personal_finance_app/main.dart';
import 'package:personal_finance_app/models/app_settings.dart';
import 'package:personal_finance_app/state/app_bootstrap_provider.dart';
import 'package:personal_finance_app/state/settings_provider.dart';

void main() {
  testWidgets('renders bootstrap splash state', (tester) async {
    final completer = Completer<void>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith((ref) => completer.future),
          settingsProvider.overrideWith((ref) async => AppSettings()),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(SplashScreen), findsOneWidget);
  });

  testWidgets('app lock gate passes through when biometric lock is disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith(
            (ref) async => AppSettings(biometricLockEnabled: false),
          ),
        ],
        child: const MaterialApp(
          home: AppLockGate(
            authRequired: true,
            child: Scaffold(body: Text('Unlocked')),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Unlocked'), findsOneWidget);
  });
}
