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

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
  return formatter.format(date);
}

String formatDuration(int totalMinutes) {
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;

  String result = '';
  if (hours > 0) result += '$hours giờ';
  if (minutes > 0) {
    if (result.isNotEmpty) result += ' ';
    result += '$minutes phút';
  }

  return result.isNotEmpty ? result : '0 phút';
}

String formatDateTime(DateTime input, {String locale = 'vi'}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final inputDate = DateTime(input.year, input.month, input.day);

  final timePart = DateFormat('HH:mm', locale).format(input);

  if (inputDate == today) {
    return locale == 'vi' ? 'Hôm nay, $timePart' : 'Today, $timePart';
  } else if (inputDate == yesterday) {
    return locale == 'vi' ? 'Hôm qua, $timePart' : 'Yesterday, $timePart';
  } else {
    final datePart = DateFormat('dd/MM/yyyy', locale).format(input);
    return '$datePart, $timePart';
  }
}

double normalizeWinkle(int forehead, int crowFeet, int glabella, int nasolable) {
  return 1.0 - (forehead == 1 ? 0.2 : 0) - (crowFeet == 1 ? 0.2 : 0) - (glabella == 1 ? 0.2 : 0) - (nasolable == 1 ? 0.2 : 0);
}

double normalizeSpot(int spot) {
  return 1.0 - spot / 20;
}

double normalizeAcne(int acne, int close_comedone, int blackHead) {
  return 1.0 - (acne + close_comedone + blackHead * 5) / 100;
}

double normalizePore(int left, int right, int jaw, int forehead) {
  return 1.0 - (left == 1 ? 0.2 : 0) - (right == 1 ? 0.2 : 0) - (jaw == 1 ? 0.2 : 0) - (forehead == 1 ? 0.2 : 0);
}
