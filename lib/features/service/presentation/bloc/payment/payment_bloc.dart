import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_deposit.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PayFull _payFull;
  final PayDeposit _payDeposit;

  PaymentBloc({required PayFull payFull, required PayDeposit payDeposit})
      : _payFull = payFull,
        _payDeposit = payDeposit,
        super(PaymentInitial()) {
    on<PayFullEvent>(_onPayFull);
    on<PayDepositEvent>(_onPayDeposit);
  }

  Future<void> _onPayFull(PayFullEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());

    final result =
        await _payFull(PayFullParams(totalAmount: event.params.totalAmount, orderId: event.params.orderId, request: event.params.request));
    result.fold((failure) => emit(PaymentError(failure.message)), (result) => emit(PaymentSuccess(result)));
  }

  Future<void> _onPayDeposit(PayDepositEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());

    final result = await _payDeposit(PayDepositParams(
        totalAmount: event.params.totalAmount,
        orderId: event.params.orderId,
        request: event.params.request,
        percent: event.params.percent));
    result.fold((failure) => emit(PaymentError(failure.message)), (result) => emit(PaymentSuccess(result)));
  }
}
