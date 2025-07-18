import 'package:yoweme/model/amount.dart';

class Transaction {
  final String transactionId;
  final Amount amount;
  final String creditDebitIndicator;
  final DateTime transactionDate;
  final String description;
  final String status;
  final String? accountId;
  final String? transactionChannel;
  final String? debtorName;
  final String? creditorName;

  Transaction({
    required this.transactionId,
    required this.amount,
    required this.creditDebitIndicator,
    required this.transactionDate,
    required this.description,
    required this.status,
    this.accountId,
    this.transactionChannel,
    this.debtorName,
    this.creditorName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Extract amount from transactionAmount
    final transactionAmount = json['transactionAmount'] ?? {};
    final amount = Amount(
      value: (transactionAmount['amount'] ?? 0.0).toDouble(),
      currency: transactionAmount['currency'] ?? 'JOD',
    );

    // Map transactionType to creditDebitIndicator
    final transactionType = json['transactionType'] ?? '';
    final creditDebitIndicator = transactionType.toLowerCase() == 'credit'
        ? 'CREDIT'
        : 'DEBIT';

    // Extract description from rmtInf.unstructured or use a fallback
    String description = 'Transaction';
    if (json['rmtInf'] != null && json['rmtInf']['unstructured'] != null) {
      final unstructured = json['rmtInf']['unstructured'] as List?;
      if (unstructured != null && unstructured.isNotEmpty) {
        description = unstructured.first.toString();
      }
    }

    // Use settlementDateTime or presentementDateTime for transaction date
    DateTime transactionDate = DateTime.now();
    if (json['settlementDateTime'] != null) {
      transactionDate = DateTime.parse(json['settlementDateTime']);
    } else if (json['presentementDateTime'] != null) {
      transactionDate = DateTime.parse(json['presentementDateTime']);
    }

    // Extract names
    String? debtorName;
    String? creditorName;

    if (json['debtor'] != null && json['debtor']['debtorPersonal'] != null) {
      debtorName = json['debtor']['debtorPersonal']['name'];
    }

    if (json['creditor'] != null &&
        json['creditor']['creditorPersonal'] != null) {
      creditorName = json['creditor']['creditorPersonal']['name'];
    }

    // Extract account ID
    String? accountId;
    if (transactionType.toLowerCase() == 'credit' && json['creditor'] != null) {
      accountId = json['creditor']['creditorAccount']?['accountId'];
    } else if (json['debtor'] != null) {
      accountId = json['debtor']['debtorAccount']?['accountId'];
    }

    return Transaction(
      transactionId: json['transactionId']?.toString() ?? '',
      amount: amount,
      creditDebitIndicator: creditDebitIndicator,
      transactionDate: transactionDate,
      description: description,
      status: json['transactionStatus'] ?? '',
      accountId: accountId,
      transactionChannel: json['transactionChannel']?['name'],
      debtorName: debtorName,
      creditorName: creditorName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'amount': {'value': amount.value, 'currency': amount.currency},
      'creditDebitIndicator': creditDebitIndicator,
      'transactionDate': transactionDate.toIso8601String(),
      'description': description,
      'status': status,
      'accountId': accountId,
      'transactionChannel': transactionChannel,
      'debtorName': debtorName,
      'creditorName': creditorName,
    };
  }
}
