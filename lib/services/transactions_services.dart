import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoweme/model/trasnactions.dart';

class TransactionsService {
  final String baseUrl = 'https://jpcjofsdev.apigw-az-eu.webmethods.io/gateway';
  final String apiPath = '/Transactions/v0.4.3/accounts';

  final Map<String, String> headers = {
    'accept': 'application/json',
    'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Replace with your real token
  };

  /// Fetches transactions for a range of account IDs and returns them as Transaction objects
  Future<List<AccountTransactions>> fetchTransactionsForAccounts({
    required int startAccountId,
    required int endAccountId,
  }) async {
    List<AccountTransactions> allTransactions = [];

    for (
      int accountId = startAccountId;
      accountId <= endAccountId;
      accountId++
    ) {
      try {
        final transactions = await fetchTransactionsForSingleAccount(accountId);
        allTransactions.add(
          AccountTransactions(accountId: accountId, transactions: transactions),
        );
      } catch (e) {
        allTransactions.add(
          AccountTransactions(
            accountId: accountId,
            transactions: [],
            error: e.toString(),
          ),
        );
      }
    }

    return allTransactions;
  }

  /// Fetches transactions for a single account
  Future<List<Transaction>> fetchTransactionsForSingleAccount(
    int accountId, {
    int skip = 0,
    int limit = 10,
    String sort = 'desc',
  }) async {
    final uri = Uri.parse(
      '$baseUrl$apiPath/$accountId/transactions?skip=$skip&sort=$sort&limit=$limit',
    );

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Handle different possible response structures
      final List<dynamic> transactionsData =
          data['transactions'] ?? data['data'] ?? (data is List ? data : []);

      return transactionsData
          .map((json) => Transaction.fromJson(json))
          .toList();
    } else {
      throw Exception(
        'Failed to fetch transactions: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Fetches a single transaction by ID
  Future<Transaction?> fetchTransactionById(
    int accountId,
    String transactionId,
  ) async {
    final uri = Uri.parse(
      '$baseUrl$apiPath/$accountId/transactions/$transactionId',
    );

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Transaction.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception(
        'Failed to fetch transaction: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Fetches all transactions for a single account (handles pagination)
  Future<List<Transaction>> fetchAllTransactionsForAccount(
    int accountId,
  ) async {
    List<Transaction> allTransactions = [];
    int skip = 0;
    const int limit = 100;
    bool hasMore = true;

    while (hasMore) {
      try {
        final transactions = await fetchTransactionsForSingleAccount(
          accountId,
          skip: skip,
          limit: limit,
        );

        if (transactions.isEmpty) {
          hasMore = false;
        } else {
          allTransactions.addAll(transactions);
          skip += limit;

          // If we got less than the limit, we've reached the end
          if (transactions.length < limit) {
            hasMore = false;
          }
        }
      } catch (e) {
        throw Exception(
          'Failed to fetch all transactions for account $accountId: $e',
        );
      }
    }

    return allTransactions;
  }
}

/// Helper class to group transactions by account
class AccountTransactions {
  final int accountId;
  final List<Transaction> transactions;
  final String? error;

  AccountTransactions({
    required this.accountId,
    required this.transactions,
    this.error,
  });

  bool get hasError => error != null;
  bool get hasTransactions => transactions.isNotEmpty;

  @override
  String toString() {
    if (hasError) {
      return 'AccountTransactions(accountId: $accountId, error: $error)';
    }
    return 'AccountTransactions(accountId: $accountId, transactions: ${transactions.length})';
  }
}
