// import 'package:yoweme/services/balance_services.dart';

// import 'package:yoweme/model/trasnactions.dart';
// import 'package:yoweme/model/balance.dart';
// import 'package:yoweme/model/amount.dart';
// import 'package:yoweme/services/transactions_services.dart';

// class AccountManager {
//   final TransactionsService _transactionsService = TransactionsService();
//   final BalanceService _balanceService = BalanceService();

//   /// Get complete account overview with balance and recent transactions
//   Future<AccountOverview> getAccountOverview(String accountId) async {
//     try {
//       // Fetch balance and transactions concurrently
//       final futures = await Future.wait([
//         _balanceService.fetchBalanceForAccount(accountId),
//         _transactionsService.fetchTransactionsForSingleAccount(
//           int.parse(accountId),
//           limit: 10,
//         ),
//       ]);

//       final balance = futures[0] as Balance;
//       final transactions = futures[1] as List<Transaction>;

//       return AccountOverview(
//         accountId: accountId,
//         balance: balance,
//         recentTransactions: transactions,
//       );
//     } catch (e) {
//       throw Exception('Failed to fetch account overview: $e');
//     }
//   }

//   /// Calculate total balance across multiple accounts
//   Future<Amount> calculateTotalBalance(List<String> accountIds) async {
//     final balances = await _balanceService.fetchBalancesForAccounts(accountIds);

//     if (balances.isEmpty) {
//       return Amount(value: 0.0, currency: 'JOD');
//     }

//     // Use the first balance's currency as the base currency
//     final baseCurrency = balances.first.availableBalance.currency;
//     double totalValue = 0.0;

//     for (final balance in balances) {
//       if (balance.availableBalance.currency != baseCurrency) {
//         throw Exception('Cannot sum balances with different currencies');
//       }
//       totalValue += balance.availableBalance.value;
//     }

//     return Amount(value: totalValue, currency: baseCurrency);
//   }

//   /// Get spending analysis for an account
//   Future<SpendingAnalysis> getSpendingAnalysis(String accountId) async {
//     try {
//       final allTransactions = await _transactionsService
//           .fetchAllTransactionsForAccount(int.parse(accountId));

//       final credits = allTransactions
//           .where((t) => t.creditDebitIndicator.toLowerCase() == 'credit')
//           .toList();
//       final debits = allTransactions
//           .where((t) => t.creditDebitIndicator.toLowerCase() == 'debit')
//           .toList();

//       // Calculate totals
//       Amount totalCredits = credits.fold(
//         Amount(value: 0.0, currency: 'JOD'),
//         (sum, t) => sum + t.amount,
//       );

//       Amount totalDebits = debits.fold(
//         Amount(value: 0.0, currency: 'JOD'),
//         (sum, t) => sum + t.amount,
//       );

//       return SpendingAnalysis(
//         accountId: accountId,
//         totalCredits: totalCredits,
//         totalDebits: totalDebits,
//         netAmount: totalCredits - totalDebits,
//         creditCount: credits.length,
//         debitCount: debits.length,
//       );
//     } catch (e) {
//       throw Exception('Failed to calculate spending analysis: $e');
//     }
//   }

//   /// Search transactions by description
//   Future<List<Transaction>> searchTransactions(
//     String accountId,
//     String searchTerm,
//   ) async {
//     final allTransactions = await _transactionsService
//         .fetchAllTransactionsForAccount(int.parse(accountId));

//     return allTransactions
//         .where(
//           (transaction) => transaction.description.toLowerCase().contains(
//             searchTerm.toLowerCase(),
//           ),
//         )
//         .toList();
//   }
// }

// class AccountOverview {
//   final String accountId;
//   final Balance balance;
//   final List<Transaction> recentTransactions;

//   AccountOverview({
//     required this.accountId,
//     required this.balance,
//     required this.recentTransactions,
//   });

//   @override
//   String toString() {
//     return 'AccountOverview(accountId: $accountId, balance: $balance, transactions: ${recentTransactions.length})';
//   }
// }

// class SpendingAnalysis {
//   final String accountId;
//   final Amount totalCredits;
//   final Amount totalDebits;
//   final Amount netAmount;
//   final int creditCount;
//   final int debitCount;

//   SpendingAnalysis({
//     required this.accountId,
//     required this.totalCredits,
//     required this.totalDebits,
//     required this.netAmount,
//     required this.creditCount,
//     required this.debitCount,
//   });

//   double get averageCredit =>
//       creditCount > 0 ? totalCredits.value / creditCount : 0.0;
//   double get averageDebit =>
//       debitCount > 0 ? totalDebits.value / debitCount : 0.0;

//   @override
//   String toString() {
//     return '''
// SpendingAnalysis for Account $accountId:
//   Total Credits: $totalCredits ($creditCount transactions)
//   Total Debits: $totalDebits ($debitCount transactions)
//   Net Amount: $netAmount
//   Average Credit: ${totalCredits.currency} ${averageCredit.toStringAsFixed(2)}
//   Average Debit: ${totalDebits.currency} ${averageDebit.toStringAsFixed(2)}
//     ''';
//   }
// }

// // Usage example
// void main() async {
//   final accountManager = AccountManager();

//   try {
//     // Get complete account overview
//     final overview = await accountManager.getAccountOverview('123');
//     print(overview);

//     // Calculate total balance across multiple accounts
//     final totalBalance = await accountManager.calculateTotalBalance([
//       '123',
//       '456',
//       '789',
//     ]);
//     print('Total Balance: $totalBalance');

//     // Get spending analysis
//     final analysis = await accountManager.getSpendingAnalysis('123');
//     print(analysis);

//     // Search transactions
//     final searchResults = await accountManager.searchTransactions('123', 'ATM');
//     print('Found ${searchResults.length} ATM transactions');
//   } catch (e) {
//     print('Error: $e');
//   }
// }
