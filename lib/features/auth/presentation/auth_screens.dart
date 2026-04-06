import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../state/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
      if (mounted) Navigator.of(context).pop();
    } on ApiException {
      if (mounted) setState(() => _errorMessage = context.l10n.loginErrorMessage);
    } catch (_) {
      if (mounted) setState(() => _errorMessage = context.l10n.loginErrorMessage);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.loginTitle, style: textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(l10n.loginSubtitle, style: textTheme.bodyMedium),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    prefixIcon: Icon(Icons.email_outlined, color: colors.textMuted),
                  ),
                  validator: (v) =>
                      (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    labelText: l10n.passwordLabel,
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: colors.textMuted),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: colors.textMuted,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
                ),
                const SizedBox(height: 12),
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.destructiveSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: textTheme.bodyMedium?.copyWith(color: colors.secondary),
                    ),
                  ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : AppPrimaryButton(
                          label: l10n.loginButton,
                          onPressed: _submit,
                          icon: Icons.login_rounded,
                        ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(SignupScreen.routeName),
                    child: Text(l10n.goToSignupLabel),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.continueOfflineLabel,
                      style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  static const routeName = '/signup';

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).signup(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
          );
      if (mounted) Navigator.of(context).pop();
    } on ApiException {
      if (mounted) setState(() => _errorMessage = context.l10n.signupErrorMessage);
    } catch (_) {
      if (mounted) setState(() => _errorMessage = context.l10n.signupErrorMessage);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.signupTitle, style: textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(l10n.signupSubtitle, style: textTheme.bodyMedium),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  autofillHints: const [AutofillHints.name],
                  decoration: InputDecoration(
                    labelText: l10n.nameLabel,
                    prefixIcon: Icon(Icons.person_outline_rounded, color: colors.textMuted),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    prefixIcon: Icon(Icons.email_outlined, color: colors.textMuted),
                  ),
                  validator: (v) =>
                      (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: InputDecoration(
                    labelText: l10n.passwordLabel,
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: colors.textMuted),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: colors.textMuted,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
                ),
                const SizedBox(height: 12),
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.destructiveSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: textTheme.bodyMedium?.copyWith(color: colors.secondary),
                    ),
                  ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : AppPrimaryButton(
                          label: l10n.signupButton,
                          onPressed: _submit,
                          icon: Icons.person_add_rounded,
                        ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName),
                    child: Text(l10n.goToLoginLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
