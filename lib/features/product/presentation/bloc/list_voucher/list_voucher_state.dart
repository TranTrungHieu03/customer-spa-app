part of 'list_voucher_bloc.dart';

@immutable
sealed class ListVoucherState {}

final class ListVoucherInitial extends ListVoucherState {}

final class ListVoucherLoading extends ListVoucherState {}

final class ListVoucherLoaded extends ListVoucherState {
  final List<VoucherModel> vouchers;
  final String date;

  ListVoucherLoaded({
    required this.vouchers,
    required this.date,
  });
}

final class ListVoucherError extends ListVoucherState {
  final String message;

  ListVoucherError(this.message);
}