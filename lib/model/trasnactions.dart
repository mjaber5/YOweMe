import 'package:yoweme/model/amount.dart';

class Transaction {
  final String transactionId;
  final Amount amount;
  final String creditDebitIndicator;
  final DateTime transactionDate;
  final String description;
  final String status;

  Transaction({
    required this.transactionId,
    required this.amount,
    required this.creditDebitIndicator,
    required this.transactionDate,
    required this.description,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'] ?? '',
      amount: Amount.fromJson(json['amount']),
      creditDebitIndicator: json['creditDebitIndicator'] ?? '',
      transactionDate: DateTime.parse(json['transactionDate']),
      description: json['description'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
