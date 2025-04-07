import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_vouchers.dart';

part 'list_voucher_event.dart';
part 'list_voucher_state.dart';

class ListVoucherBloc extends Bloc<ListVoucherEvent, ListVoucherState> {
  final GetVouchers _getVouchers;

  ListVoucherBloc({
    required GetVouchers getVouchers,
  })  : _getVouchers = getVouchers,
        super(ListVoucherInitial()) {
    on<GetVoucherByDateEvent>((event, emit) async {
      emit(ListVoucherLoading());
      final result = await _getVouchers(GetVouchersParams(event.date));
      result.fold(
        (failure) => emit(ListVoucherError(failure.message)),
        (vouchers) => emit(ListVoucherLoaded(date: event.date, vouchers: vouchers)),
      );
    });
  }
}
