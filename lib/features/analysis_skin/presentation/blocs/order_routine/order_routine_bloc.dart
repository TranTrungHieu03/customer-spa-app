import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/order_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_order_routine.dart';

part 'order_routine_event.dart';
part 'order_routine_state.dart';

class OrderRoutineBloc extends Bloc<OrderRoutineEvent, OrderRoutineState> {
  final GetOrderRoutine _getOrderRoutine;

  OrderRoutineBloc({required GetOrderRoutine getOrderRoutine})
      : _getOrderRoutine = getOrderRoutine,
        super(OrderRoutineInitial()) {
    on<GetOrderRoutineDetailEvent>((event, emit) async {
      emit(OrderRoutineLoading());
      final result = await _getOrderRoutine(event.params);
      result.fold((message) {
        AppLogger.info(message);
        emit(OrderRoutineError(message));
      }, (data) {
        AppLogger.info(data);
        emit(OrderRoutineLoaded(data));
      });
    });
  }
}
