class Account {
  final String customerId;
  final DateTime openingDate;

  Account({required this.customerId, required this.openingDate});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      customerId: json['customerId'],
      openingDate: DateTime.parse(json['openingDate']),
    );
  }
}
