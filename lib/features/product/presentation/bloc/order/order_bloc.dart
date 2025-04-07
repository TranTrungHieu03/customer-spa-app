import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/product/data/model/order_product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_order_product_detail.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrder _createOrder;
  final GetOrderProductDetail _getOrderProductDetail;

  OrderBloc({required CreateOrder createOrder, required GetOrderProductDetail getOrderProductDetail})
      : _createOrder = createOrder,
        _getOrderProductDetail = getOrderProductDetail,
        super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<GetOrderEvent>(_onGetOrderDetail);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await _createOrder(event.params);
    result.fold((failure) => emit(OrderError(failure.message)), (data) => emit(OrderSuccess(data)));
  }

  Future<void> _onGetOrderDetail(GetOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final result = await _getOrderProductDetail(event.params);
    result.fold((failure) => emit(OrderError(failure.message)), (data) => emit(OrderLoaded(data)));
  }
}
