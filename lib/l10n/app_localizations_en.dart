// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'YOweMe - Smart Expense Splitting';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get profile => 'Profile';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get balance => 'Balance';

  @override
  String get overall => 'Overall';

  @override
  String get iOwe => 'I owe';

  @override
  String get owesMe => 'Owes me';

  @override
  String get youOwe => 'YOU OWE';

  @override
  String get owesYou => 'OWES YOU';

  @override
  String get noBalance => 'NO BALANCE';

  @override
  String get noAccountsFound => 'No accounts found';

  @override
  String get addAccountToSplitwise => 'Add account to splitwise';

  @override
  String get account => 'Account';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get description => 'Description';

  @override
  String get enterExpenseDescription => 'Enter expense description';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get splitWith => 'Split with';

  @override
  String get selectAllFriends => 'Select All Friends';

  @override
  String get splitOptions => 'Split Options';

  @override
  String get equalSplit => 'Equal Split';

  @override
  String get customSplit => 'Custom Split';

  @override
  String get percentageSplit => 'Percentage Split';

  @override
  String get equalSplitDesc => 'Split equally among all participants';

  @override
  String get customSplitDesc => 'Set custom amounts for each person';

  @override
  String get percentageSplitDesc => 'Split by percentage';

  @override
  String get cancel => 'Cancel';

  @override
  String get expenseAddedSuccessfully => 'Expense added successfully!';

  @override
  String get pleaseSelectAtLeastOneFriend =>
      'Please select at least one friend';

  @override
  String get receiptImage => 'Receipt Image';

  @override
  String get friends => 'Friends';

  @override
  String get insights => 'Insights';

  @override
  String get activity => 'Activity';

  @override
  String get notifications => 'Notifications';

  @override
  String get aiInsights => 'AI Insights';

  @override
  String get welcomeToYOweMe => 'Welcome to YOweMe';

  @override
  String get enterPhoneNumberToContinue =>
      'Enter your phone number to continue';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhoneNumberHint => 'Enter your phone number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get enterOtpHint => 'Enter 4-digit OTP';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get didntReceiveCode => 'Didn\'t receive the code?';

  @override
  String get otpSentToPhone => 'OTP sent to your phone!';

  @override
  String get otpVerifiedSuccessfully => 'OTP verified successfully!';

  @override
  String get invalidOtp => 'Invalid OTP. Please try again.';

  @override
  String get secureAndPrivate => 'Secure & Private';

  @override
  String get securityDescription =>
      'We use OTP verification to keep your account secure. Your phone number is never shared.';

  @override
  String get demoMode => 'Demo Mode';

  @override
  String get demoModeDesc => 'For demo purposes, use \"0000\" as the OTP code.';

  @override
  String get quickLogin => 'Quick Login';

  @override
  String get tapForBiometric => 'Tap to login with biometric';

  @override
  String get transactions => 'Transactions';

  @override
  String get all => 'All';

  @override
  String get payments => 'Payments';

  @override
  String get reminders => 'Reminders';

  @override
  String get updates => 'Updates';

  @override
  String get social => 'Social';

  @override
  String get paymentReceived => 'Payment Received';

  @override
  String get reminderSent => 'Reminder Sent';

  @override
  String get newExpenseAdded => 'New Expense Added';

  @override
  String get paymentRequest => 'Payment Request';

  @override
  String get friendJoined => 'Friend Joined YOweMe';

  @override
  String get settlementComplete => 'Settlement Complete';

  @override
  String get paymentReminder => 'Payment Reminder';

  @override
  String get payNow => 'Pay Now';

  @override
  String get viewDetails => 'View Details';

  @override
  String get addFriend => 'Add Friend';

  @override
  String get markAllAsRead => 'Mark All as Read';

  @override
  String noNotifications(String filter) {
    return 'No $filter notifications';
  }

  @override
  String get allCaughtUp =>
      'You\'re all caught up! Check back later for updates.';

  @override
  String get financialMetrics => 'Financial Metrics';

  @override
  String get thisMonth => 'This Month';

  @override
  String get avgMonth => 'Avg/Month';

  @override
  String get topCategory => 'Top Category';

  @override
  String get mostActive => 'Most Active';

  @override
  String get monthlySpendingTrend => 'Monthly Spending Trend';

  @override
  String get categoryBreakdown => 'Category Breakdown';

  @override
  String get quickInsights => 'Quick Insights';

  @override
  String get financialPredictions => 'Financial Predictions';

  @override
  String get reports => 'Reports';

  @override
  String get downloadFullReport => 'Download Full Report';

  @override
  String get shareReport => 'Share Report';

  @override
  String get reportDetails => 'Report Details';

  @override
  String get generated => 'Generated';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get categoriesAnalyzed => 'Categories Analyzed';

  @override
  String get executiveSummary => 'Executive Summary';

  @override
  String get aiPoweredInsights => 'AI-powered financial insights';

  @override
  String get keyFindings => 'Key Findings';

  @override
  String get spendingIncreased => 'Spending increased by 12.5% this month';

  @override
  String get foodDiningTop => 'Food & Dining is your top expense category';

  @override
  String get potentialSavings => 'Potential savings of \$324 identified';

  @override
  String get onTrackBudget => 'On track to meet annual budget goals';

  @override
  String get nextMonthForecast => 'Next Month Forecast';

  @override
  String get yearEndProjection => 'Year-end Projection';

  @override
  String get savingsOpportunity => 'Savings Opportunity';

  @override
  String get basedOnSpendingPatterns => 'Based on your spending patterns';

  @override
  String get estimatedTotalAnnual => 'Estimated total annual expenses';

  @override
  String get potentialMonthlySavings => 'Potential monthly savings identified';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get perPerson => 'Per Person';

  @override
  String get expenseDetails => 'Expense Details';

  @override
  String get paidBy => 'Paid by';

  @override
  String get date => 'Date';

  @override
  String get status => 'Status';

  @override
  String get notes => 'Notes';

  @override
  String get participants => 'Participants';

  @override
  String get people => 'people';

  @override
  String get totalSplitAmount => 'Total Split Amount';

  @override
  String get paid => 'Paid';

  @override
  String get pending => 'Pending';

  @override
  String get markPaid => 'Mark Paid';

  @override
  String get paymentTimeline => 'Payment Timeline';

  @override
  String get expenseCreated => 'Expense Created';

  @override
  String paymentBy(String name) {
    return 'Payment by $name';
  }

  @override
  String get pendingSettlements => 'Pending Settlements';

  @override
  String get remaining => 'remaining';

  @override
  String get sendReminder => 'Send Reminder';

  @override
  String get share => 'Share';

  @override
  String get expenseOptions => 'Expense Options';

  @override
  String get editExpense => 'Edit Expense';

  @override
  String get modifyDetails => 'Modify details, amount, or participants';

  @override
  String get duplicateExpense => 'Duplicate Expense';

  @override
  String get createSimilar => 'Create a similar expense';

  @override
  String get manageParticipants => 'Manage Participants';

  @override
  String get addRemovePeople => 'Add or remove people from this expense';

  @override
  String get exportDetails => 'Export Details';

  @override
  String get downloadReport => 'Download expense report as PDF';

  @override
  String get deleteExpense => 'Delete Expense';

  @override
  String get permanentlyRemove => 'Permanently remove this expense';

  @override
  String get deleteConfirmation =>
      'Are you sure you want to delete this expense? This action cannot be undone and will affect all participants.';

  @override
  String get delete => 'Delete';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get foodAndDining => 'Food & Dining';

  @override
  String get transportation => 'Transportation';

  @override
  String get entertainment => 'Entertainment';

  @override
  String get shopping => 'Shopping';

  @override
  String get billsAndUtilities => 'Bills & Utilities';

  @override
  String get travel => 'Travel';

  @override
  String get healthcare => 'Healthcare';

  @override
  String get education => 'Education';

  @override
  String get groceries => 'Groceries';

  @override
  String get other => 'Other';
}
