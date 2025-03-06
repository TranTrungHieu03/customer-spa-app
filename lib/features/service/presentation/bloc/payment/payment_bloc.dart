import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PayFull _payFull;

  PaymentBloc({required PayFull payFull})
      : _payFull = payFull,
        super(PaymentInitial()) {
    on<PayFullEvent>(_onPayFull);
  }

  Future<void> _onPayFull(PayFullEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());

    final result =
        await _payFull(PayFullParams(totalAmount: event.params.totalAmount, orderId: event.params.orderId, request: event.params.request));
    result.fold((failure) => emit(PaymentError(failure.message)), (result) => emit(PaymentSuccess(result)));
  }
}
