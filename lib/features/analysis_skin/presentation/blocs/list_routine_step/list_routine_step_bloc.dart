import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_step.dart';

part 'list_routine_step_event.dart';
part 'list_routine_step_state.dart';

class ListRoutineStepBloc extends Bloc<ListRoutineStepEvent, ListRoutineStepState> {
  final GetRoutineStep _getRoutineStep;

  ListRoutineStepBloc({required GetRoutineStep getRoutineStep})
      : _getRoutineStep = getRoutineStep,
        super(ListRoutineStepInitial()) {
    on<GetRoutineStepEvent>(_onGetRoutineStepEvent);
  }

  Future<void> _onGetRoutineStepEvent(GetRoutineStepEvent event, Emitter<ListRoutineStepState> emit) async {
    emit(ListRoutineStepLoading());
    final result = await _getRoutineStep(GetRoutineStepParams(event.params.id));
    result.fold(
      (failure) => emit(ListRoutineStepError(failure.message)),
      (data) => emit(ListRoutineStepLoaded(data)),
    );
  }
}
