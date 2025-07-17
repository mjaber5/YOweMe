// lib/models/expense.dart
class Expense {
  final String id;
  final String description;
  final double amount;
  final String paidBy;
  final List<String> participants;
  final String category;
  final DateTime createdAt;
  final String? imageUrl;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.participants,
    required this.category,
    required this.createdAt,
    this.imageUrl,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      paidBy: json['paidBy'],
      participants: List<String>.from(json['participants']),
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'paidBy': paidBy,
      'participants': participants,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}
