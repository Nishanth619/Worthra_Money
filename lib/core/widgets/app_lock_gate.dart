import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/local_auth_provider.dart';
import '../../state/settings_provider.dart';
import '../theme/theme_extensions.dart';

class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({
    super.key,
    required this.child,
    required this.authRequired,
  });

  final Widget child;
  final bool authRequired;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  bool _isUnlocked = false;
  bool _isAuthenticating = false;
  bool _promptScheduled = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final biometricLockEnabled = ref
        .read(settingsProvider)
        .maybeWhen(
          data: (settings) => settings.biometricLockEnabled,
          orElse: () => false,
        );

    if (!widget.authRequired || !biometricLockEnabled) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (_isUnlocked || _errorMessage != null) {
        setState(() {
          _isUnlocked = false;
          _errorMessage = null;
          _promptScheduled = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(settingsProvider, (_, next) {
      next.whenData((settings) {
        if (!mounted) {
          return;
        }

        if (!settings.biometricLockEnabled) {
          if (!_isUnlocked || _errorMessage != null || _promptScheduled) {
            setState(() {
              _isUnlocked = true;
              _errorMessage = null;
              _promptScheduled = false;
            });
          }
          return;
        }
      });
    });

    if (!widget.authRequired) {
      return widget.child;
    }

    final settingsAsync = ref.watch(settingsProvider);
    return settingsAsync.when(
      data: (settings) {
        if (!settings.biometricLockEnabled) {
          _isUnlocked = true;
          _errorMessage = null;
          _promptScheduled = false;
          return widget.child;
        }

        if (_isUnlocked) {
          return widget.child;
        }

        if (!_isAuthenticating && !_promptScheduled) {
          _promptScheduled = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _authenticate();
            }
          });
        }

        return _LockedView(
          isAuthenticating: _isAuthenticating,
          errorMessage: _errorMessage,
          onRetry: _authenticate,
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) {
      return;
    }

    final authService = ref.read(localAuthServiceProvider);

    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    try {
      await authService.ensureBiometricsAvailable();
      final result = await authService.authenticate(
        reason: 'Authenticate to unlock your finance vault.',
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _isAuthenticating = false;
        _isUnlocked = result.isAuthenticated;
        _errorMessage = result.isAuthenticated ? null : result.message;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isAuthenticating = false;
        _isUnlocked = false;
        _errorMessage = error.toString();
      });
    }
  }
}

class _LockedView extends StatelessWidget {
  const _LockedView({
    required this.isAuthenticating,
    required this.errorMessage,
    required this.onRetry,
  });

  final bool isAuthenticating;
  final String? errorMessage;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: colors.primarySoft,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Icon(
                        Icons.fingerprint_rounded,
                        size: 36,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Vault Locked',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage ??
                          'Use your enrolled biometrics to unlock the app.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: isAuthenticating ? null : onRetry,
                      icon: isAuthenticating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.lock_open_rounded),
                      label: Text(
                        isAuthenticating ? 'Authenticating...' : 'Unlock App',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
