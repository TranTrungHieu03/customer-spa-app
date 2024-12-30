
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatMoney(String amount) {
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
  return formatter.format(double.parse(amount));
}

DateTime combineDateTime(DateTime date, TimeOfDay time) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}