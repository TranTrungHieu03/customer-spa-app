import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/book_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_current_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';

part 'routine_event.dart';
part 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final GetRoutineDetail _getRoutineDetail;
  final BookRoutine _bookRoutine;
  final GetCurrentRoutine _getCurrentRoutine;

  RoutineBloc({
    required GetRoutineDetail getRoutineDetail,
    required BookRoutine bookRoutine,
    required GetCurrentRoutine getCurrentRoutine,
  })  : _getRoutineDetail = getRoutineDetail,
        _bookRoutine = bookRoutine,
        _getCurrentRoutine = getCurrentRoutine,
        super(RoutineInitial()) {
    on<GetRoutineDetailEvent>(_onGetRoutineDetailEvent);
    on<BookRoutineDetailEvent>(_onBookRoutineEvent);
    on<RefreshRoutineEvent>(_onRefresh);

    on<GetCurrentRoutineEvent>(_onGetCurrentRoutineEvent);
  }

  Future<void> _onGetRoutineDetailEvent(GetRoutineDetailEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoading());
    final result = await _getRoutineDetail(event.params);
    result.fold(
      (failure) => emit(RoutineError(failure.message)),
      (data) => emit(RoutineLoaded(data)),
    );
  }

  Future<void> _onBookRoutineEvent(BookRoutineDetailEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoading());
    final result = await _bookRoutine(event.params);
    result.fold(
      (failure) => emit(RoutineError(failure.message)),
      (data) => emit(RoutineBook(data)),
    );
  }

  Future<void> _onRefresh(RefreshRoutineEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineInitial());
  }

  Future<void> _onGetCurrentRoutineEvent(GetCurrentRoutineEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoading());
    final result = await _getCurrentRoutine(event.params);
    result.fold(
      (failure) => emit(RoutineError(failure.message)),
      (data) => emit(RoutineLoaded(data)),
    );
  }
}
