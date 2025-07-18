class Balance {
  final String accountId;
  final double availableBalance;
  final String currency;

  Balance({
    required this.accountId,
    required this.availableBalance,
    required this.currency,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    // Handle different possible structures (some might have availableBalance, some only currentBalance)
    final balanceData =
        json['availableBalance'] ?? json['currentBalance'] ?? {};
    final balanceAmount = balanceData['balanceAmount'] ?? 0.0;

    return Balance(
      accountId: json['accountId'] ?? 'Unknown',
      availableBalance: balanceAmount is num
          ? balanceAmount.toDouble()
          : double.tryParse(balanceAmount.toString()) ?? 0.0,
      currency:
          json['balanceCurrency'] ??
          json['currency'] ??
          json['currencyCode'] ??
          'JOD',
    );
  }
}
