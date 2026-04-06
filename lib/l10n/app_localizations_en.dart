// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Worthra';

  @override
  String get appTagline => 'Money, made clear';

  @override
  String get appBrandName => 'WORTHRA';

  @override
  String get appVersion => 'App Version 1.0.0';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String get closeButton => 'Close';

  @override
  String get saveButton => 'Save';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navGoals => 'Goals';

  @override
  String get navInsights => 'Insights';

  @override
  String get portfolioLabel => 'Portfolio';

  @override
  String get guestUserName => 'Guest User';

  @override
  String dashboardGreeting(String name) {
    return 'Good morning, $name';
  }

  @override
  String get dashboardSubtitle => 'Here is a clear view of your money today.';

  @override
  String get currentBalanceLabel => 'CURRENT BALANCE';

  @override
  String get monthlyIncomeLabel => 'Monthly Income';

  @override
  String get monthlyExpensesLabel => 'Monthly Expenses';

  @override
  String get weeklySpendingTrendLabel => 'Weekly Spending Trend';

  @override
  String get last7DaysLabel => 'Last 7 Days';

  @override
  String get recentTransactionsLabel => 'Recent Transactions';

  @override
  String get viewAllButton => 'View All';

  @override
  String get emptyDashboardMessage =>
      'Add a transaction to start tracking your money.';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get vaultStatusTitle => 'Local Data Status';

  @override
  String get transactionsLabel => 'Transactions';

  @override
  String get goalsLabel => 'Goals';

  @override
  String get storageLabel => 'Storage';

  @override
  String get localStorageValue => 'Stored on this device';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeLightLabel => 'Light';

  @override
  String get themeDarkLabel => 'Dark';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get languageLabel => 'Language';

  @override
  String get remindersSection => 'Reminders';

  @override
  String get dailyReminderLabel => 'Daily Reminder';

  @override
  String get reminderTimeLabel => 'Reminder Time';

  @override
  String get securityDataSection => 'Security & Data';

  @override
  String get biometricLockLabel => 'Biometric App Lock';

  @override
  String get exportCsvLabel => 'Export Data (CSV)';

  @override
  String get exportingLabel => 'Exporting Data...';

  @override
  String get aboutSection => 'About';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get privacyPolicyBody =>
      'Your data stays on this device unless you choose to export it or enable sync later.';

  @override
  String get termsLabel => 'Terms & Conditions';

  @override
  String get termsBody =>
      'This app uses offline-first local storage. Keep exported files safe if you move them outside the app.';

  @override
  String get deleteAccountButton => 'Delete Account & Data';

  @override
  String get deleteAllDataTitle => 'Delete all local data?';

  @override
  String get deleteAllDataContent =>
      'This will remove your transactions, goals, reminders, and app settings from this device.';

  @override
  String get dataClearedMessage => 'All local data has been cleared.';

  @override
  String csvExportedMessage(String path) {
    return 'CSV exported to $path';
  }

  @override
  String get syncSection => 'Sync';

  @override
  String get lastSyncedLabel => 'Last Synced';

  @override
  String get syncNowLabel => 'Sync Now';

  @override
  String get syncingLabel => 'Syncing...';

  @override
  String get syncSuccessMessage => 'Sync completed successfully.';

  @override
  String get syncErrorMessage => 'Sync failed. Will retry when online.';

  @override
  String get neverSyncedLabel => 'Never';

  @override
  String get accountSection => 'Account';

  @override
  String get signOutLabel => 'Sign Out';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get signOutConfirmContent =>
      'Your local data will remain on this device.';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to sync your finances securely.';

  @override
  String get signupTitle => 'Create account';

  @override
  String get signupSubtitle => 'Start tracking your finances privately.';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get nameLabel => 'Full Name';

  @override
  String get loginButton => 'Sign In';

  @override
  String get signupButton => 'Create Account';

  @override
  String get goToSignupLabel => 'Don\'t have an account? Sign up';

  @override
  String get goToLoginLabel => 'Already have an account? Sign in';

  @override
  String get loginErrorMessage =>
      'Invalid email or password. Please try again.';

  @override
  String get signupErrorMessage => 'Sign up failed. Please try again.';

  @override
  String get continueOfflineLabel => 'Continue without account';

  @override
  String get goalsHeaderTracker => 'PROGRESS TRACKER';

  @override
  String get goalsHeaderTitle => 'My Goals';

  @override
  String get goalsHeaderSubtitle =>
      'Track savings goals and daily streaks in one place.';

  @override
  String get goalsSectionSavings => 'Savings Goals';

  @override
  String get goalsSectionStreaks => 'Streak Challenges';

  @override
  String get goalStatusCompleted => 'Completed';

  @override
  String get goalStatusDoneToday => 'Done today';

  @override
  String get goalStatusActive => 'Active';

  @override
  String get goalStatusNotStarted => 'Not started yet';

  @override
  String get goalStatusBroken => 'Streak broken';

  @override
  String get goalsEmptyTitle => 'Create your first goal';

  @override
  String get goalsEmptySubtitle =>
      'Start with a savings goal or a streak challenge.';

  @override
  String get goalAddLabel => 'Add';

  @override
  String get goalLabelDays => 'days';

  @override
  String get insightsHeaderIntelligence => 'FINANCIAL INTELLIGENCE';

  @override
  String get insightsHeaderTitle => 'Spending Insights';

  @override
  String get insightsHeaderSubtitle =>
      'See where your money goes and spot spending patterns.';

  @override
  String get insightsTabWeekly => 'Weekly';

  @override
  String get insightsTabMonthly => 'Monthly';

  @override
  String get insightsIncome => 'Income';

  @override
  String get insightsExpenses => 'Expenses';

  @override
  String get insightsSaved => 'Saved';

  @override
  String get insightsGreenBanner => 'You are on track';

  @override
  String get insightsRedBanner => 'You spent more than you earned';

  @override
  String get insightsSurplus => 'Net surplus:';

  @override
  String get insightsDeficit => 'Net deficit:';

  @override
  String get insightsThisPeriod => 'this period';

  @override
  String get insightsCategoryBreakdown => 'Category Breakdown';

  @override
  String get insightsOfExpenses => 'of expenses';

  @override
  String get insightsTopBadge => 'TOP';

  @override
  String get insightsTipTitle => 'Smart tip';

  @override
  String get insightsTipEmpty =>
      'Add a few expense transactions to unlock helpful tips.';

  @override
  String insightsTipMoreThanHalf(String category, String percentage) {
    return '$category makes up $percentage% of your spending. Consider trimming this category first.';
  }

  @override
  String insightsTipLeads(String category, String percentage) {
    return '$category leads at $percentage%. A monthly cap could help keep it in check.';
  }

  @override
  String get insightsTipBalanced =>
      'Your spending looks balanced across categories. Keep it up.';

  @override
  String insightsTipTop(String category, String percentage) {
    return '$category is your top spending category at $percentage%. Keep an eye on it this period.';
  }

  @override
  String get insightsEmptyTitle => 'No spending data';

  @override
  String get insightsEmptySubtitle =>
      'Add some expense transactions and come back to see your spending breakdown.';
}
