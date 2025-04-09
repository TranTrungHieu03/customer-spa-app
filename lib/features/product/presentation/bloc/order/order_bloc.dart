import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/product/data/model/order_product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/cancel_order.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_order_product_detail.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrder _createOrder;
  final GetOrderProductDetail _getOrderProductDetail;
  final CancelOrder _cancelOrder;

  OrderBloc({required CreateOrder createOrder, required GetOrderProductDetail getOrderProductDetail, required CancelOrder cancelOrdder})
      : _createOrder = createOrder,
        _getOrderProductDetail = getOrderProductDetail,
        _cancelOrder = cancelOrdder,
        super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<GetOrderEvent>(_onGetOrderDetail);
    on<CancelOrderEvent>(_onCancelEvent);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await _createOrder(event.params);
    result.fold((failure) => emit(OrderError(failure.message)), (data) {
      AppLogger.info(data);
      emit(OrderSuccess(data));
      AppLogger.info('success');
    });
  }

  Future<void> _onGetOrderDetail(GetOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final result = await _getOrderProductDetail(event.params);
    result.fold((failure) => emit(OrderError(failure.message)), (data) => emit(OrderLoaded(data)));
  }

  Future<void> _onCancelEvent(CancelOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final result = await _cancelOrder(event.params);
    result.fold((failure) => emit(OrderError(failure.message)), (data) {
      AppLogger.info(data);
      emit(OrderCancelSuccess(orderId: event.params.orderId, message: data));
      // add(GetOrderEvent(GetOrderProductDetailParams(id: event.params.orderId)));
    });
  }
}
