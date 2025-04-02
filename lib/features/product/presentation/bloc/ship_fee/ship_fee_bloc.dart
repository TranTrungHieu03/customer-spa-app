import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_available_service.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_fee_shipping.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_lead_time.dart';

part 'ship_fee_event.dart';
part 'ship_fee_state.dart';

class ShipFeeBloc extends Bloc<ShipFeeEvent, ShipFeeState> {
  final GetLeadTime _getLeadTime;
  final GetFeeShipping _feeShipping;
  final GetAvailableService _getAvailableService;

  ShipFeeBloc({required GetLeadTime getLeadTime, required GetFeeShipping getFeeShipping, required GetAvailableService getAvailableService})
      : _feeShipping = getFeeShipping,
        _getLeadTime = getLeadTime,
        _getAvailableService = getAvailableService,
        super(ShipFeeInitial()) {
    on<GetLeadTimeEvent>((event, emit) async {
      final currentState = state;
      AppLogger.info(currentState);
      if (currentState is ShipFeeLoaded) {
        AppLogger.info("go ShipFeeLoaded");
        final result = await _getLeadTime(event.params);
        result.fold((failure) => emit(ShipFeeError(failure.message)), (data) => emit(ShipFeeLoaded(fee: currentState.fee, leadTime: data)));
      } else {
        emit(ShipFeeLoading());
        final result = await _getLeadTime(event.params);
        result.fold((failure) => emit(ShipFeeError(failure.message)), (data) => emit(ShipFeeLoaded(fee: 0, leadTime: data)));
      }
    });
    on<GetShipFeeEvent>((event, emit) async {
      final currentState = state;
      AppLogger.info(currentState);
      if (currentState is ShipFeeLoaded) {
        AppLogger.info("go ShipFeeLoaded");
        final result = await _feeShipping(event.params);
        result.fold(
            (failure) => emit(ShipFeeError(failure.message)), (data) => emit(ShipFeeLoaded(fee: data, leadTime: currentState.leadTime)));
      } else {
        emit(ShipFeeLoading());
        final result = await _feeShipping(event.params);
        result.fold((failure) => emit(ShipFeeError(failure.message)), (data) => emit(ShipFeeLoaded(fee: data, leadTime: "")));
      }
    });
    on<GetAvailableServiceEvent>((event, emit) async {
      emit(ShipFeeLoading());
      final result = await _getAvailableService(event.params);
      result.fold((failure) => emit(ShipFeeError(failure.message)), (data) => emit(ShipFeeLoadedServiceId(data)));
    });
  }
}
