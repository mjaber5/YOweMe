import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoweme/model/user.dart';

class ApiServiceAccounts {
  final String baseUrl =
      'https://jpcjofsdev.apigw-az-eu.webmethods.io/gateway/Accounts/v0.4.3/accounts';

  Future<List<Account>> fetchAccounts() async {
    final headers = {
      'x-jws-signature': '1',
      'x-idempotency-key': '1',
      'x-interactions-id': '1',
      'x-customer-user-agent': '1',
      'x-customer-ip-address': '1',
      'Authorization': '1',
    };

    // Generate customer IDs
    List<String> generateCustomerIDs(String prefix, int start, int end) {
      return List.generate(
        end - start + 1,
        (i) => '$prefix${(start + i).toString().padLeft(3, '0')}',
      );
    }

    final customerIDs = [
      ...generateCustomerIDs('IND_CUST_', 1, 8),
      ...generateCustomerIDs('IND_CUST_', 9, 14),
      ...generateCustomerIDs('IND_CUST_', 15, 18),
      ...generateCustomerIDs('IND_CUST_', 19, 22),
      ...generateCustomerIDs('CORP_CUST_', 1, 4),
      ...generateCustomerIDs('CORP_CUST_', 5, 7),
      ...generateCustomerIDs('CORP_CUST_', 8, 9),
      ...generateCustomerIDs('BUS_CUST_', 1, 4),
      ...generateCustomerIDs('BUS_CUST_', 5, 7),
    ];

    int getAccountId(int index) => 1000 + index + 1;

    final List<Account> allData = [];

    // Loop through customer IDs
    for (int i = 0; i < customerIDs.length; i++) {
      getAccountId(i).toString();
      final customerId = customerIDs[i];
      const limit = 10;
      int skip = 0;
      bool hasMore = true;

      while (hasMore) {
        final url = '$baseUrl?limit=$limit&skip=$skip';
        final response = await http.get(
          Uri.parse(url),
          headers: {...headers, 'x-customer-id': customerId},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data is Map && data.containsKey('data')) {
            final accounts = (data['data'] as List)
                .map(
                  (item) =>
                      Account.fromJson({...item, 'customerId': customerId}),
                )
                .toList();
            allData.addAll(accounts);

            // Check if there are more items to fetch
            hasMore = accounts.length == limit;
            skip += limit;
          } else {
            throw Exception('Unexpected response format for $customerId');
          }
        } else {
          throw Exception(
            'Failed to load accounts for $customerId: ${response.statusCode}',
          );
        }
      }
    }

    return allData;
  }
}
