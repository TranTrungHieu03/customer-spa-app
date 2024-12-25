
import 'package:intl/intl.dart';

String formatMoney(String amount) {
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
  return formatter.format(double.parse(amount));
}