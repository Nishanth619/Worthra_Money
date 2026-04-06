import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Worthra'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Money, made clear'**
  String get appTagline;

  /// No description provided for @appBrandName.
  ///
  /// In en, this message translates to:
  /// **'WORTHRA'**
  String get appBrandName;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version 1.0.0'**
  String get appVersion;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get navGoals;

  /// No description provided for @navInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navInsights;

  /// No description provided for @portfolioLabel.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolioLabel;

  /// No description provided for @guestUserName.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUserName;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String dashboardGreeting(String name);

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here is a clear view of your money today.'**
  String get dashboardSubtitle;

  /// No description provided for @currentBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT BALANCE'**
  String get currentBalanceLabel;

  /// No description provided for @monthlyIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get monthlyIncomeLabel;

  /// No description provided for @monthlyExpensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly Expenses'**
  String get monthlyExpensesLabel;

  /// No description provided for @weeklySpendingTrendLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly Spending Trend'**
  String get weeklySpendingTrendLabel;

  /// No description provided for @last7DaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7DaysLabel;

  /// No description provided for @recentTransactionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactionsLabel;

  /// No description provided for @viewAllButton.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAllButton;

  /// No description provided for @emptyDashboardMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a transaction to start tracking your money.'**
  String get emptyDashboardMessage;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @vaultStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Local Data Status'**
  String get vaultStatusTitle;

  /// No description provided for @transactionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsLabel;

  /// No description provided for @goalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goalsLabel;

  /// No description provided for @storageLabel.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storageLabel;

  /// No description provided for @localStorageValue.
  ///
  /// In en, this message translates to:
  /// **'Stored on this device'**
  String get localStorageValue;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @themeLightLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLightLabel;

  /// No description provided for @themeDarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDarkLabel;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @remindersSection.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersSection;

  /// No description provided for @dailyReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminderLabel;

  /// No description provided for @reminderTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTimeLabel;

  /// No description provided for @securityDataSection.
  ///
  /// In en, this message translates to:
  /// **'Security & Data'**
  String get securityDataSection;

  /// No description provided for @biometricLockLabel.
  ///
  /// In en, this message translates to:
  /// **'Biometric App Lock'**
  String get biometricLockLabel;

  /// No description provided for @exportCsvLabel.
  ///
  /// In en, this message translates to:
  /// **'Export Data (CSV)'**
  String get exportCsvLabel;

  /// No description provided for @exportingLabel.
  ///
  /// In en, this message translates to:
  /// **'Exporting Data...'**
  String get exportingLabel;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @privacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLabel;

  /// No description provided for @privacyPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this device unless you choose to export it or enable sync later.'**
  String get privacyPolicyBody;

  /// No description provided for @termsLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsLabel;

  /// No description provided for @termsBody.
  ///
  /// In en, this message translates to:
  /// **'This app uses offline-first local storage. Keep exported files safe if you move them outside the app.'**
  String get termsBody;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account & Data'**
  String get deleteAccountButton;

  /// No description provided for @deleteAllDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data?'**
  String get deleteAllDataTitle;

  /// No description provided for @deleteAllDataContent.
  ///
  /// In en, this message translates to:
  /// **'This will remove your transactions, goals, reminders, and app settings from this device.'**
  String get deleteAllDataContent;

  /// No description provided for @dataClearedMessage.
  ///
  /// In en, this message translates to:
  /// **'All local data has been cleared.'**
  String get dataClearedMessage;

  /// No description provided for @csvExportedMessage.
  ///
  /// In en, this message translates to:
  /// **'CSV exported to {path}'**
  String csvExportedMessage(String path);

  /// No description provided for @syncSection.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncSection;

  /// No description provided for @lastSyncedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Synced'**
  String get lastSyncedLabel;

  /// No description provided for @syncNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNowLabel;

  /// No description provided for @syncingLabel.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncingLabel;

  /// No description provided for @syncSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Sync completed successfully.'**
  String get syncSuccessMessage;

  /// No description provided for @syncErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Will retry when online.'**
  String get syncErrorMessage;

  /// No description provided for @neverSyncedLabel.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get neverSyncedLabel;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @signOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutLabel;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Your local data will remain on this device.'**
  String get signOutConfirmContent;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your finances securely.'**
  String get loginSubtitle;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your finances privately.'**
  String get signupSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get nameLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupButton;

  /// No description provided for @goToSignupLabel.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get goToSignupLabel;

  /// No description provided for @goToLoginLabel.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get goToLoginLabel;

  /// No description provided for @loginErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again.'**
  String get loginErrorMessage;

  /// No description provided for @signupErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed. Please try again.'**
  String get signupErrorMessage;

  /// No description provided for @continueOfflineLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue without account'**
  String get continueOfflineLabel;

  /// No description provided for @goalsHeaderTracker.
  ///
  /// In en, this message translates to:
  /// **'PROGRESS TRACKER'**
  String get goalsHeaderTracker;

  /// No description provided for @goalsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'My Goals'**
  String get goalsHeaderTitle;

  /// No description provided for @goalsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track savings goals and daily streaks in one place.'**
  String get goalsHeaderSubtitle;

  /// No description provided for @goalsSectionSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get goalsSectionSavings;

  /// No description provided for @goalsSectionStreaks.
  ///
  /// In en, this message translates to:
  /// **'Streak Challenges'**
  String get goalsSectionStreaks;

  /// No description provided for @goalStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get goalStatusCompleted;

  /// No description provided for @goalStatusDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Done today'**
  String get goalStatusDoneToday;

  /// No description provided for @goalStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get goalStatusActive;

  /// No description provided for @goalStatusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started yet'**
  String get goalStatusNotStarted;

  /// No description provided for @goalStatusBroken.
  ///
  /// In en, this message translates to:
  /// **'Streak broken'**
  String get goalStatusBroken;

  /// No description provided for @goalsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first goal'**
  String get goalsEmptyTitle;

  /// No description provided for @goalsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with a savings goal or a streak challenge.'**
  String get goalsEmptySubtitle;

  /// No description provided for @goalAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get goalAddLabel;

  /// No description provided for @goalLabelDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get goalLabelDays;

  /// No description provided for @insightsHeaderIntelligence.
  ///
  /// In en, this message translates to:
  /// **'FINANCIAL INTELLIGENCE'**
  String get insightsHeaderIntelligence;

  /// No description provided for @insightsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending Insights'**
  String get insightsHeaderTitle;

  /// No description provided for @insightsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See where your money goes and spot spending patterns.'**
  String get insightsHeaderSubtitle;

  /// No description provided for @insightsTabWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get insightsTabWeekly;

  /// No description provided for @insightsTabMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get insightsTabMonthly;

  /// No description provided for @insightsIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get insightsIncome;

  /// No description provided for @insightsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get insightsExpenses;

  /// No description provided for @insightsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get insightsSaved;

  /// No description provided for @insightsGreenBanner.
  ///
  /// In en, this message translates to:
  /// **'You are on track'**
  String get insightsGreenBanner;

  /// No description provided for @insightsRedBanner.
  ///
  /// In en, this message translates to:
  /// **'You spent more than you earned'**
  String get insightsRedBanner;

  /// No description provided for @insightsSurplus.
  ///
  /// In en, this message translates to:
  /// **'Net surplus:'**
  String get insightsSurplus;

  /// No description provided for @insightsDeficit.
  ///
  /// In en, this message translates to:
  /// **'Net deficit:'**
  String get insightsDeficit;

  /// No description provided for @insightsThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'this period'**
  String get insightsThisPeriod;

  /// No description provided for @insightsCategoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category Breakdown'**
  String get insightsCategoryBreakdown;

  /// No description provided for @insightsOfExpenses.
  ///
  /// In en, this message translates to:
  /// **'of expenses'**
  String get insightsOfExpenses;

  /// No description provided for @insightsTopBadge.
  ///
  /// In en, this message translates to:
  /// **'TOP'**
  String get insightsTopBadge;

  /// No description provided for @insightsTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart tip'**
  String get insightsTipTitle;

  /// No description provided for @insightsTipEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add a few expense transactions to unlock helpful tips.'**
  String get insightsTipEmpty;

  /// No description provided for @insightsTipMoreThanHalf.
  ///
  /// In en, this message translates to:
  /// **'{category} makes up {percentage}% of your spending. Consider trimming this category first.'**
  String insightsTipMoreThanHalf(String category, String percentage);

  /// No description provided for @insightsTipLeads.
  ///
  /// In en, this message translates to:
  /// **'{category} leads at {percentage}%. A monthly cap could help keep it in check.'**
  String insightsTipLeads(String category, String percentage);

  /// No description provided for @insightsTipBalanced.
  ///
  /// In en, this message translates to:
  /// **'Your spending looks balanced across categories. Keep it up.'**
  String get insightsTipBalanced;

  /// No description provided for @insightsTipTop.
  ///
  /// In en, this message translates to:
  /// **'{category} is your top spending category at {percentage}%. Keep an eye on it this period.'**
  String insightsTipTop(String category, String percentage);

  /// No description provided for @insightsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No spending data'**
  String get insightsEmptyTitle;

  /// No description provided for @insightsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add some expense transactions and come back to see your spending breakdown.'**
  String get insightsEmptySubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
