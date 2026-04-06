import 'package:flutter/material.dart';
import 'package:personal_finance_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/app_lock_gate.dart';
import 'core/widgets/main_scaffold.dart';
import 'features/auth/presentation/auth_screens.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'state/app_bootstrap_provider.dart';
import 'state/settings_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const FinanceApp();
  }
}

class FinanceApp extends ConsumerWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: AppTheme.crispAlabasterTheme,
      darkTheme: AppTheme.midnightLedgerTheme,
      themeMode: themeMode,
      themeAnimationDuration: Duration.zero,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        SettingsScreen.routeName: (_) => const SettingsScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        SignupScreen.routeName: (_) => const SignupScreen(),
      },
      builder: (context, child) => AppLockGate(
        authRequired: bootstrap.hasValue,
        child: child ?? const SizedBox.shrink(),
      ),
      home: bootstrap.when(
        data: (_) => const MainScaffold(),
        loading: () => const SplashScreen(),
        error: (error, _) => _BootstrapErrorScreen(message: error.toString()),
      ),
    );
  }
}

class _BootstrapErrorScreen extends StatelessWidget {
  const _BootstrapErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
