import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_tracking_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_tracking.dart';

part 'routine_tracking_event.dart';
part 'routine_tracking_state.dart';

class RoutineTrackingBloc extends Bloc<RoutineTrackingEvent, RoutineTrackingState> {
  final GetRoutineTracking _getRoutineTracking;

  RoutineTrackingBloc({required GetRoutineTracking getRoutineTracking})
      : _getRoutineTracking = getRoutineTracking,
        super(RoutineTrackingInitial()) {
    on<GetRoutineTrackingEvent>(_onGetRoutineTrackingEvent);
  }

  Future<void> _onGetRoutineTrackingEvent(GetRoutineTrackingEvent event, Emitter<RoutineTrackingState> emit) async {
    emit(RoutineTrackingLoading());
    final result = await _getRoutineTracking(event.params);
    result.fold(
      (failure) => emit(RoutineTrackingError(failure.message)),
      (data) => emit(RoutineTracking(data)),
    );
  }
}
