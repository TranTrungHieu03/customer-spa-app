import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrder _createOrder;

  OrderBloc({required CreateOrder createOrder})
      : _createOrder = createOrder,
        super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await _createOrder(event.params);
    result.fold((failure) => emit(OrderError(failure.message)), (data) => emit(OrderLoaded()));
  }
}
