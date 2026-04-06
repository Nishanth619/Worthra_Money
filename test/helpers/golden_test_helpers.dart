import 'package:flutter/material.dart';
import 'package:personal_finance_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:personal_finance_app/core/theme/app_theme.dart';
import 'package:personal_finance_app/core/theme/app_palette.dart';

/// Fixed viewport matching iPhone 14 logical resolution.
const kGoldenSize = Size(390, 844);

/// Pumps [widget] wrapped in a fully-themed [MaterialApp] + [ProviderScope]
/// at the canonical golden viewport.
///
/// Pass [dark] to render via [AppTheme.midnightLedgerTheme].
/// Pass [overrides] to inject Riverpod provider stubs.
Future<void> pumpGoldenWidget(
  WidgetTester tester,
  Widget widget, {
  bool dark = false,
  List overrides = const [],
}) async {
  tester.view.physicalSize = kGoldenSize * tester.view.devicePixelRatio;
  tester.view.devicePixelRatio = 1.0;

  addTearDown(tester.view.reset);

  final palette = dark ? AppPalette.dark : AppPalette.light;
  final theme =
      dark ? AppTheme.midnightLedgerTheme : AppTheme.crispAlabasterTheme;

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides.cast(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          backgroundColor: palette.background,
          body: Center(child: widget),
        ),
      ),
    ),
  );

  // Settle animations and async frames
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
}

/// Same as [pumpGoldenWidget] but renders against the dark theme.
Future<void> pumpDarkGoldenWidget(
  WidgetTester tester,
  Widget widget, {
  List overrides = const [],
}) =>
    pumpGoldenWidget(tester, widget, dark: true, overrides: overrides);
