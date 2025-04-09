import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_list_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_history.dart';

part 'list_routine_event.dart';
part 'list_routine_state.dart';

class ListRoutineBloc extends Bloc<ListRoutineEvent, ListRoutineState> {
  final GetListRoutine _getListRoutine;
  final GetHistoryRoutine _getHistoryRoutine;

  ListRoutineBloc({required GetListRoutine getListRoutine, required GetHistoryRoutine getHistoryRoutine})
      : _getListRoutine = getListRoutine,
        _getHistoryRoutine = getHistoryRoutine,
        super(ListRoutineInitial()) {
    on<GetListRoutineEvent>(_onGetListRoutineEvent);
    on<GetHistoryRoutineEvent>(_onGetHistory);
  }

  Future<void> _onGetListRoutineEvent(GetListRoutineEvent event, Emitter<ListRoutineState> emit) async {
    emit(ListRoutineLoading());
    final result = await _getListRoutine(NoParams());
    result.fold(
      (failure) => emit(ListRoutineError(failure.message)),
      (data) => emit(ListRoutineLoaded(data)),
    );
  }

  Future<void> _onGetHistory(GetHistoryRoutineEvent event, Emitter<ListRoutineState> emit) async {
    final currentState = state;
    if (currentState is ListRoutineHistoryLoaded) {
      emit(ListRoutineHistoryLoading(
          active: event.params.status == 'active' ? [] : currentState.active,
          cancelled: event.params.status == 'cancelled' ? [] : currentState.cancelled,
          completed: event.params.status == 'completed' ? [] : currentState.completed));
      final result = await _getHistoryRoutine(event.params);
      result.fold(
        (failure) => emit(ListRoutineError(failure.message)),
        (data) => emit(ListRoutineHistoryLoaded(
            active: event.params.status == 'active' ? data : currentState.active,
            cancelled: event.params.status == 'cancelled' ? data : currentState.cancelled,
            completed: event.params.status == 'completed' ? data : currentState.completed)),
      );
    } else {
      emit(ListRoutineHistoryLoading(active: [], cancelled: [], completed: []));
      final result = await _getHistoryRoutine(event.params);
      result.fold(
        (failure) => emit(ListRoutineError(failure.message)),
        (data) => emit(ListRoutineHistoryLoaded(
            active: event.params.status == 'active' ? data : [],
            cancelled: event.params.status == 'cancelled' ? data : [],
            completed: event.params.status == 'completed' ? data : [])),
      );
    }
  }
}
