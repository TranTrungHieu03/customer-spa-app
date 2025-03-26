import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_list_routine.dart';

part 'list_routine_event.dart';
part 'list_routine_state.dart';

class ListRoutineBloc extends Bloc<ListRoutineEvent, ListRoutineState> {
  final GetListRoutine _getListRoutine;

  ListRoutineBloc({required GetListRoutine getListRoutine})
      : _getListRoutine = getListRoutine,
        super(ListRoutineInitial()) {
    on<GetListRoutineEvent>(_onGetListRoutineEvent);
  }

  Future<void> _onGetListRoutineEvent(GetListRoutineEvent event, Emitter<ListRoutineState> emit) async {
    emit(ListRoutineLoading());
    final result = await _getListRoutine(NoParams());
    result.fold(
      (failure) => emit(ListRoutineError(failure.message)),
      (data) => emit(ListRoutineLoaded(data)),
    );
  }
}
