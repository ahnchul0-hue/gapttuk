import 'package:flutter/foundation.dart';

@immutable
class MonthlyPrice {
  final DateTime yearMonth;
  final int avgPrice;

  const MonthlyPrice({required this.yearMonth, required this.avgPrice});

  factory MonthlyPrice.fromJson(Map<String, dynamic> json) {
    return MonthlyPrice(
      yearMonth: DateTime.parse(json['year_month'] as String),
      avgPrice: json['avg_price'] as int,
    );
  }
}
