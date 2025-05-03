import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_logger_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_feedback_steps.dart';

part 'list_routine_logger_event.dart';
part 'list_routine_logger_state.dart';

class ListRoutineLoggerBloc extends Bloc<ListRoutineLoggerEvent, ListRoutineLoggerState> {
  final GetFeedbackStep _getFeedbackStep;

  ListRoutineLoggerBloc({required GetFeedbackStep getFeedbackStep})
      : _getFeedbackStep = getFeedbackStep,
        super(ListRoutineLoggerInitial()) {
    on<GetListRoutineLoggerEvent>((event, emit) async {
      emit(ListRoutineLoggerLoading());
      final result = await _getFeedbackStep(event.params);
      result.fold((message) => emit(ListRoutineLoggerError(message.message)), (data) => emit(ListRoutineLoggerLoaded(data)));
    });
  }
}
