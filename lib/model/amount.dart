class Amount {
  final double value;
  final String currency;

  Amount({required this.value, required this.currency});

  factory Amount.fromJson(Map<String, dynamic> json) {
    // Handle different possible JSON structures
    double amountValue;

    if (json['value'] != null) {
      amountValue = (json['value'] is num)
          ? json['value'].toDouble()
          : double.tryParse(json['value'].toString()) ?? 0.0;
    } else if (json['balanceAmount'] != null) {
      amountValue = (json['balanceAmount'] is num)
          ? json['balanceAmount'].toDouble()
          : double.tryParse(json['balanceAmount'].toString()) ?? 0.0;
    } else {
      amountValue = 0.0;
    }

    return Amount(
      value: amountValue,
      currency:
          json['currency'] ??
          json['balanceCurrency'] ??
          json['currencyCode'] ??
          'JOD',
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'currency': currency};
  }

  // Helper methods for common operations
  Amount operator +(Amount other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot add amounts with different currencies');
    }
    return Amount(value: value + other.value, currency: currency);
  }

  Amount operator -(Amount other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot subtract amounts with different currencies');
    }
    return Amount(value: value - other.value, currency: currency);
  }

  bool operator >(Amount other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot compare amounts with different currencies');
    }
    return value > other.value;
  }

  bool operator <(Amount other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot compare amounts with different currencies');
    }
    return value < other.value;
  }

  @override
  String toString() {
    return '$currency ${value.toStringAsFixed(2)}';
  }
}
