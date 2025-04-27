import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/service/data/model/appointment_feedback_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment_feedback.dart';

part 'appointment_feedback_event.dart';
part 'appointment_feedback_state.dart';

class AppointmentFeedbackBloc extends Bloc<AppointmentFeedbackEvent, AppointmentFeedbackState> {
  final GetFeedback _getFeedback;

  AppointmentFeedbackBloc({required GetFeedback getFeedback})
      : _getFeedback = getFeedback,
        super(AppointmentFeedbackInitial()) {
    on<GetAppointmentFeedbackEvent>((event, emit) async {
      emit(AppointmentFeedbackLoading());
      final result = await _getFeedback(event.params);
      result.fold(
        (failure) => emit(AppointmentFeedbackError(failure.message)),
        (feedback) => emit(AppointmentFeedbackLoaded(feedback)),
      );
    });
  }
}
