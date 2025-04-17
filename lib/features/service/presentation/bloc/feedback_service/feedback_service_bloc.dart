import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/service/data/model/service_feedback_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/feedback_service.dart';

part 'feedback_service_event.dart';
part 'feedback_service_state.dart';

class FeedbackServiceBloc extends Bloc<FeedbackServiceEvent, FeedbackServiceState> {
  final FeedbackService _feedbackService;

  FeedbackServiceBloc({required FeedbackService feedbackService})
      : _feedbackService = feedbackService,
        super(FeedbackServiceInitial()) {
    on<SendFeedbackServiceEvent>((event, emit) async {
      emit(FeedbackServiceLoading());
      final result = await _feedbackService(event.params);
      result.fold((message) => emit(FeedbackServiceError(message.toString())), (data) => emit(FeedbackServiceLoaded(data)));
    });
  }
}
