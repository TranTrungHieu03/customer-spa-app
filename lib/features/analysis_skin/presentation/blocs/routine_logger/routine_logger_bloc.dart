import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/feedback_step.dart';

part 'routine_logger_event.dart';
part 'routine_logger_state.dart';

class RoutineLoggerBloc extends Bloc<RoutineLoggerEvent, RoutineLoggerState> {
  final FeedbackStep _feedbackStep;

  RoutineLoggerBloc({required FeedbackStep feedbackStep})
      : _feedbackStep = feedbackStep,
        super(RoutineLoggerInitial()) {
    on<CreateRoutineLoggerEvent>((event, emit) async {
      emit(RoutineLoggerLoading());
      final result = await _feedbackStep(event.params);
      result.fold((message) => emit(RoutineLoggerError(message.toString())), (data) => emit(RoutineLoggerCreated()));
    });
  }
}
