import 'package:flutter/widgets.dart';
import 'package:personal_finance_app/l10n/app_localizations.dart';

/// Provides a concise `context.l10n` accessor instead of the verbose
/// `AppLocalizations.of(context)` call throughout the UI layer.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
