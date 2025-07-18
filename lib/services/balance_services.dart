import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoweme/model/balance.dart';

class BalanceService {
  final List<String> accountIDs = List.generate(
    10,
    (index) => (1001 + index).toString(),
  );

  final String baseUrl =
      'https://jpcjofsdev.apigw-az-eu.webmethods.io/gateway/Balances/v0.4.3';

  /// Public method to fetch balances for preset account IDs
  Future<List<Balance>> fetchBalances() async {
    print('🔄 Fetching balances for preset accounts...');
    return await _fetchBalances(accountIDs);
  }

  /// Check and return only valid account IDs (based on API response)
  Future<List<String>> getValidAccountIds() async {
    final List<String> validIds = [];
    final testRange = List.generate(20, (index) => (1001 + index).toString());

    print('🔍 Checking which accounts are valid...');

    for (final accountId in testRange) {
      final balance = await _fetchBalanceForAccount(accountId);
      if (balance != null) {
        validIds.add(accountId);
        print('✅ $accountId is valid');
      }
    }

    print('📋 Found ${validIds.length} valid accounts: $validIds');
    return validIds;
  }

  /// Public method to fetch balances only for valid accounts
  Future<List<Balance>> fetchValidBalances() async {
    final validAccountIds = await getValidAccountIds();
    print('💰 Fetching balances for valid accounts...');
    return await _fetchBalances(validAccountIds);
  }

  /// Private helper to fetch balances for a list of account IDs
  Future<List<Balance>> _fetchBalances(List<String> accountIds) async {
    final List<Balance> balances = [];

    for (final accountId in accountIds) {
      final balance = await _fetchBalanceForAccount(accountId);
      if (balance != null) {
        balances.add(balance);
        print('✅ $accountId: ${balance.availableBalance} ${balance.currency}');
      }
    }

    print('📦 Total valid balances: ${balances.length}');
    return balances;
  }

  /// Private helper to fetch a single balance and parse it
  Future<Balance?> _fetchBalanceForAccount(String accountId) async {
    final url = Uri.parse('$baseUrl/accounts/$accountId/balances');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic> && jsonData.isNotEmpty) {
          return Balance.fromJson({...jsonData, 'accountId': accountId});
        }
      } else {
        print('❌ $accountId: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 Error fetching balance for $accountId: $e');
    }

    return null;
  }
}
