import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoweme/model/amount.dart';
import 'package:yoweme/model/trasnactions.dart';

class TransactionService {
  static const String baseUrl =
      'https://jpcjofsdev.apigw-az-eu.webmethods.io/gateway/Transactions/v0.4.3';

  // Fetch transactions for a specific account
  Future<List<Transaction>> fetchTransactionsByAccountId(
    String accountId,
  ) async {
    try {
      print('🔄 Fetching transactions for account: $accountId');

      final url =
          '$baseUrl/accounts/$accountId/transactions?skip=0&sort=desc&limit=20';
      print('📡 API URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Add authentication headers if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      print('📊 Response status: ${response.statusCode}');
      print(
        '📋 Response body preview: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Extract the data array from the response
        final List<dynamic> transactionData = jsonResponse['data'] ?? [];

        print('✅ Found ${transactionData.length} transactions in API response');

        // Convert each transaction to Transaction object
        final List<Transaction> transactions = transactionData
            .map((json) {
              try {
                return Transaction.fromJson(json);
              } catch (e) {
                print('⚠️ Error parsing transaction: $e');
                print('📄 Problematic JSON: $json');
                return null;
              }
            })
            .where((transaction) => transaction != null)
            .cast<Transaction>()
            .toList();

        print('✅ Successfully parsed ${transactions.length} transactions');
        return transactions;
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('📄 Error body: ${response.body}');
        throw Exception(
          'Failed to load transactions: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('❌ Network/Parse Error: $e');
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  // Fetch all transactions (you might not need this with your current API structure)
  Future<List<Transaction>> fetchTransactions() async {
    // Since your API is account-specific, this method would need to fetch for all accounts
    // For now, we'll just return an empty list
    print(
      '⚠️ fetchTransactions() called - use fetchTransactionsByAccountId() instead',
    );
    return [];
  }

  // Alternative method to filter transactions locally (not needed with your API structure)
  Future<List<Transaction>> fetchTransactionsByAccountIdFiltered(
    String accountId,
  ) async {
    // Your API already filters by account, so this just calls the main method
    return fetchTransactionsByAccountId(accountId);
  }

  // For testing: Generate mock transactions that match your API structure
  Future<List<Transaction>> generateMockTransactions(String accountId) async {
    print('🎭 Generating mock transactions for account: $accountId');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final mockTransactions = [
      Transaction(
        transactionId: '1',
        amount: Amount(value: 4971.6, currency: 'JOD'),
        creditDebitIndicator: 'CREDIT',
        transactionDate: DateTime.parse('2023-12-24T05:35:51.612Z'),
        description: 'Bonus payment',
        status: 'settled',
        accountId: accountId,
        transactionChannel: 'Automated Clearing House',
        debtorName: 'Nora Abdullah Al-Rashid',
        creditorName: 'Ahmed Mohammed Al-Ahmad',
      ),
      Transaction(
        transactionId: '2',
        amount: Amount(value: 250.75, currency: 'JOD'),
        creditDebitIndicator: 'DEBIT',
        transactionDate: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Restaurant payment',
        status: 'settled',
        accountId: accountId,
        transactionChannel: 'Online Banking',
        debtorName: 'Ahmed Mohammed Al-Ahmad',
        creditorName: 'Tony\'s Pizza Restaurant',
      ),
      Transaction(
        transactionId: '3',
        amount: Amount(value: 45.50, currency: 'JOD'),
        creditDebitIndicator: 'DEBIT',
        transactionDate: DateTime.now().subtract(const Duration(days: 5)),
        description: 'Gas station payment',
        status: 'settled',
        accountId: accountId,
        transactionChannel: 'Card Payment',
        debtorName: 'Ahmed Mohammed Al-Ahmad',
        creditorName: 'Shell Gas Station',
      ),
      Transaction(
        transactionId: '4',
        amount: Amount(value: 12.25, currency: 'JOD'),
        creditDebitIndicator: 'DEBIT',
        transactionDate: DateTime.now().subtract(const Duration(days: 7)),
        description: 'Coffee shop payment',
        status: 'pending',
        accountId: accountId,
        transactionChannel: 'Mobile App',
        debtorName: 'Ahmed Mohammed Al-Ahmad',
        creditorName: 'Starbucks Coffee',
      ),
      Transaction(
        transactionId: '5',
        amount: Amount(value: 189.99, currency: 'JOD'),
        creditDebitIndicator: 'DEBIT',
        transactionDate: DateTime.now().subtract(const Duration(days: 10)),
        description: 'Grocery shopping',
        status: 'settled',
        accountId: accountId,
        transactionChannel: 'Card Payment',
        debtorName: 'Ahmed Mohammed Al-Ahmad',
        creditorName: 'Carrefour Supermarket',
      ),
    ];

    print('✅ Generated ${mockTransactions.length} mock transactions');
    return mockTransactions;
  }

  // Test API connectivity
  Future<bool> testApiConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/1001/transactions?skip=0&limit=1'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('🔗 API Test - Status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('🔗 API Test Failed: $e');
      return false;
    }
  }
}
