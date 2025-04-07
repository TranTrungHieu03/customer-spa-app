part of 'list_voucher_bloc.dart';

@immutable
sealed class ListVoucherEvent {}

final class GetVoucherByDateEvent extends ListVoucherEvent {
  final String date;

  GetVoucherByDateEvent(this.date);
}
