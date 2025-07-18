import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'YOweMe - Smart Expense Splitting'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @overall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get overall;

  /// No description provided for @iOwe.
  ///
  /// In en, this message translates to:
  /// **'I owe'**
  String get iOwe;

  /// No description provided for @owesMe.
  ///
  /// In en, this message translates to:
  /// **'Owes me'**
  String get owesMe;

  /// No description provided for @youOwe.
  ///
  /// In en, this message translates to:
  /// **'YOU OWE'**
  String get youOwe;

  /// No description provided for @owesYou.
  ///
  /// In en, this message translates to:
  /// **'OWES YOU'**
  String get owesYou;

  /// No description provided for @noBalance.
  ///
  /// In en, this message translates to:
  /// **'NO BALANCE'**
  String get noBalance;

  /// No description provided for @noAccountsFound.
  ///
  /// In en, this message translates to:
  /// **'No accounts found'**
  String get noAccountsFound;

  /// No description provided for @addAccountToSplitwise.
  ///
  /// In en, this message translates to:
  /// **'Add account to splitwise'**
  String get addAccountToSplitwise;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterExpenseDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter expense description'**
  String get enterExpenseDescription;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @splitWith.
  ///
  /// In en, this message translates to:
  /// **'Split with'**
  String get splitWith;

  /// No description provided for @selectAllFriends.
  ///
  /// In en, this message translates to:
  /// **'Select All Friends'**
  String get selectAllFriends;

  /// No description provided for @splitOptions.
  ///
  /// In en, this message translates to:
  /// **'Split Options'**
  String get splitOptions;

  /// No description provided for @equalSplit.
  ///
  /// In en, this message translates to:
  /// **'Equal Split'**
  String get equalSplit;

  /// No description provided for @customSplit.
  ///
  /// In en, this message translates to:
  /// **'Custom Split'**
  String get customSplit;

  /// No description provided for @percentageSplit.
  ///
  /// In en, this message translates to:
  /// **'Percentage Split'**
  String get percentageSplit;

  /// No description provided for @equalSplitDesc.
  ///
  /// In en, this message translates to:
  /// **'Split equally among all participants'**
  String get equalSplitDesc;

  /// No description provided for @customSplitDesc.
  ///
  /// In en, this message translates to:
  /// **'Set custom amounts for each person'**
  String get customSplitDesc;

  /// No description provided for @percentageSplitDesc.
  ///
  /// In en, this message translates to:
  /// **'Split by percentage'**
  String get percentageSplitDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @expenseAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Expense added successfully!'**
  String get expenseAddedSuccessfully;

  /// No description provided for @pleaseSelectAtLeastOneFriend.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one friend'**
  String get pleaseSelectAtLeastOneFriend;

  /// No description provided for @receiptImage.
  ///
  /// In en, this message translates to:
  /// **'Receipt Image'**
  String get receiptImage;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @aiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get aiInsights;

  /// No description provided for @welcomeToYOweMe.
  ///
  /// In en, this message translates to:
  /// **'Welcome to YOweMe'**
  String get welcomeToYOweMe;

  /// No description provided for @enterPhoneNumberToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue'**
  String get enterPhoneNumberToContinue;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumberHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @enterOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit OTP'**
  String get enterOtpHint;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceiveCode;

  /// No description provided for @otpSentToPhone.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to your phone!'**
  String get otpSentToPhone;

  /// No description provided for @otpVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully!'**
  String get otpVerifiedSuccessfully;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtp;

  /// No description provided for @secureAndPrivate.
  ///
  /// In en, this message translates to:
  /// **'Secure & Private'**
  String get secureAndPrivate;

  /// No description provided for @securityDescription.
  ///
  /// In en, this message translates to:
  /// **'We use OTP verification to keep your account secure. Your phone number is never shared.'**
  String get securityDescription;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo Mode'**
  String get demoMode;

  /// No description provided for @demoModeDesc.
  ///
  /// In en, this message translates to:
  /// **'For demo purposes, use \"0000\" as the OTP code.'**
  String get demoModeDesc;

  /// No description provided for @quickLogin.
  ///
  /// In en, this message translates to:
  /// **'Quick Login'**
  String get quickLogin;

  /// No description provided for @tapForBiometric.
  ///
  /// In en, this message translates to:
  /// **'Tap to login with biometric'**
  String get tapForBiometric;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social;

  /// No description provided for @paymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get paymentReceived;

  /// No description provided for @reminderSent.
  ///
  /// In en, this message translates to:
  /// **'Reminder Sent'**
  String get reminderSent;

  /// No description provided for @newExpenseAdded.
  ///
  /// In en, this message translates to:
  /// **'New Expense Added'**
  String get newExpenseAdded;

  /// No description provided for @paymentRequest.
  ///
  /// In en, this message translates to:
  /// **'Payment Request'**
  String get paymentRequest;

  /// No description provided for @friendJoined.
  ///
  /// In en, this message translates to:
  /// **'Friend Joined YOweMe'**
  String get friendJoined;

  /// No description provided for @settlementComplete.
  ///
  /// In en, this message translates to:
  /// **'Settlement Complete'**
  String get settlementComplete;

  /// No description provided for @paymentReminder.
  ///
  /// In en, this message translates to:
  /// **'Payment Reminder'**
  String get paymentReminder;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get markAllAsRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No {filter} notifications'**
  String noNotifications(String filter);

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up! Check back later for updates.'**
  String get allCaughtUp;

  /// No description provided for @financialMetrics.
  ///
  /// In en, this message translates to:
  /// **'Financial Metrics'**
  String get financialMetrics;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @avgMonth.
  ///
  /// In en, this message translates to:
  /// **'Avg/Month'**
  String get avgMonth;

  /// No description provided for @topCategory.
  ///
  /// In en, this message translates to:
  /// **'Top Category'**
  String get topCategory;

  /// No description provided for @mostActive.
  ///
  /// In en, this message translates to:
  /// **'Most Active'**
  String get mostActive;

  /// No description provided for @monthlySpendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly Spending Trend'**
  String get monthlySpendingTrend;

  /// No description provided for @categoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category Breakdown'**
  String get categoryBreakdown;

  /// No description provided for @quickInsights.
  ///
  /// In en, this message translates to:
  /// **'Quick Insights'**
  String get quickInsights;

  /// No description provided for @financialPredictions.
  ///
  /// In en, this message translates to:
  /// **'Financial Predictions'**
  String get financialPredictions;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @downloadFullReport.
  ///
  /// In en, this message translates to:
  /// **'Download Full Report'**
  String get downloadFullReport;

  /// No description provided for @shareReport.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get shareReport;

  /// No description provided for @reportDetails.
  ///
  /// In en, this message translates to:
  /// **'Report Details'**
  String get reportDetails;

  /// No description provided for @generated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get generated;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @categoriesAnalyzed.
  ///
  /// In en, this message translates to:
  /// **'Categories Analyzed'**
  String get categoriesAnalyzed;

  /// No description provided for @executiveSummary.
  ///
  /// In en, this message translates to:
  /// **'Executive Summary'**
  String get executiveSummary;

  /// No description provided for @aiPoweredInsights.
  ///
  /// In en, this message translates to:
  /// **'AI-powered financial insights'**
  String get aiPoweredInsights;

  /// No description provided for @keyFindings.
  ///
  /// In en, this message translates to:
  /// **'Key Findings'**
  String get keyFindings;

  /// No description provided for @spendingIncreased.
  ///
  /// In en, this message translates to:
  /// **'Spending increased by 12.5% this month'**
  String get spendingIncreased;

  /// No description provided for @foodDiningTop.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining is your top expense category'**
  String get foodDiningTop;

  /// No description provided for @potentialSavings.
  ///
  /// In en, this message translates to:
  /// **'Potential savings of \$324 identified'**
  String get potentialSavings;

  /// No description provided for @onTrackBudget.
  ///
  /// In en, this message translates to:
  /// **'On track to meet annual budget goals'**
  String get onTrackBudget;

  /// No description provided for @nextMonthForecast.
  ///
  /// In en, this message translates to:
  /// **'Next Month Forecast'**
  String get nextMonthForecast;

  /// No description provided for @yearEndProjection.
  ///
  /// In en, this message translates to:
  /// **'Year-end Projection'**
  String get yearEndProjection;

  /// No description provided for @savingsOpportunity.
  ///
  /// In en, this message translates to:
  /// **'Savings Opportunity'**
  String get savingsOpportunity;

  /// No description provided for @basedOnSpendingPatterns.
  ///
  /// In en, this message translates to:
  /// **'Based on your spending patterns'**
  String get basedOnSpendingPatterns;

  /// No description provided for @estimatedTotalAnnual.
  ///
  /// In en, this message translates to:
  /// **'Estimated total annual expenses'**
  String get estimatedTotalAnnual;

  /// No description provided for @potentialMonthlySavings.
  ///
  /// In en, this message translates to:
  /// **'Potential monthly savings identified'**
  String get potentialMonthlySavings;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @perPerson.
  ///
  /// In en, this message translates to:
  /// **'Per Person'**
  String get perPerson;

  /// No description provided for @expenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get expenseDetails;

  /// No description provided for @paidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get paidBy;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'people'**
  String get people;

  /// No description provided for @totalSplitAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Split Amount'**
  String get totalSplitAmount;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @markPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark Paid'**
  String get markPaid;

  /// No description provided for @paymentTimeline.
  ///
  /// In en, this message translates to:
  /// **'Payment Timeline'**
  String get paymentTimeline;

  /// No description provided for @expenseCreated.
  ///
  /// In en, this message translates to:
  /// **'Expense Created'**
  String get expenseCreated;

  /// No description provided for @paymentBy.
  ///
  /// In en, this message translates to:
  /// **'Payment by {name}'**
  String paymentBy(String name);

  /// No description provided for @pendingSettlements.
  ///
  /// In en, this message translates to:
  /// **'Pending Settlements'**
  String get pendingSettlements;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remaining;

  /// No description provided for @sendReminder.
  ///
  /// In en, this message translates to:
  /// **'Send Reminder'**
  String get sendReminder;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @expenseOptions.
  ///
  /// In en, this message translates to:
  /// **'Expense Options'**
  String get expenseOptions;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @modifyDetails.
  ///
  /// In en, this message translates to:
  /// **'Modify details, amount, or participants'**
  String get modifyDetails;

  /// No description provided for @duplicateExpense.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Expense'**
  String get duplicateExpense;

  /// No description provided for @createSimilar.
  ///
  /// In en, this message translates to:
  /// **'Create a similar expense'**
  String get createSimilar;

  /// No description provided for @manageParticipants.
  ///
  /// In en, this message translates to:
  /// **'Manage Participants'**
  String get manageParticipants;

  /// No description provided for @addRemovePeople.
  ///
  /// In en, this message translates to:
  /// **'Add or remove people from this expense'**
  String get addRemovePeople;

  /// No description provided for @exportDetails.
  ///
  /// In en, this message translates to:
  /// **'Export Details'**
  String get exportDetails;

  /// No description provided for @downloadReport.
  ///
  /// In en, this message translates to:
  /// **'Download expense report as PDF'**
  String get downloadReport;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get deleteExpense;

  /// No description provided for @permanentlyRemove.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove this expense'**
  String get permanentlyRemove;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this expense? This action cannot be undone and will affect all participants.'**
  String get deleteConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @foodAndDining.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get foodAndDining;

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportation;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @billsAndUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bills & Utilities'**
  String get billsAndUtilities;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @healthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get healthcare;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @groceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get groceries;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
