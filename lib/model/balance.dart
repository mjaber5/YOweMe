// lib/models/balance.dart
class Balance {
  final String userId;
  final String friendId;
  final double
  amount; // positive means friend owes you, negative means you owe friend

  Balance({required this.userId, required this.friendId, required this.amount});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      userId: json['userId'],
      friendId: json['friendId'],
      amount: json['amount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'friendId': friendId, 'amount': amount};
  }
}
