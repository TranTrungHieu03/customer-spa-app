import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';

part 'routine_event.dart';
part 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final GetRoutineDetail _getRoutineDetail;

  RoutineBloc({required GetRoutineDetail getRoutineDetail})
      : _getRoutineDetail = getRoutineDetail,
        super(RoutineInitial()) {
    on<GetRoutineDetailEvent>(_onGetRoutineDetailEvent);
  }

  Future<void> _onGetRoutineDetailEvent(GetRoutineDetailEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoading());
    final result = await _getRoutineDetail(event.params);
    result.fold(
      (failure) => emit(RoutineError(failure.message)),
      (data) => emit(RoutineLoaded(data)),
    );
  }
}
