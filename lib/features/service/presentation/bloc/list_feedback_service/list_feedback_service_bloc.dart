import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/service/data/model/service_feedback_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_feedback_service.dart';

part 'list_feedback_service_event.dart';
part 'list_feedback_service_state.dart';

class ListFeedbackServiceBloc extends Bloc<ListFeedbackServiceEvent, ListFeedbackServiceState> {
  final GetListServiceFeedback _getListServiceFeedback;

  ListFeedbackServiceBloc({required GetListServiceFeedback getListServiceFeedback})
      : _getListServiceFeedback = getListServiceFeedback,
        super(ListFeedbackServiceInitial()) {
    on<GetListFeedbackServiceEvent>((event, emit) async {
      emit(ListFeedbackServiceLoading());
      final result = await _getListServiceFeedback(event.params);
      result.fold((message) => emit(ListFeedbackServiceError(message.toString())), (data) {
        double average = 5.0;
        if ((data as List<ServiceFeedbackModel>).isNotEmpty) {
          average = data.fold(0.0, (average, x) => average + (x.rating?.toDouble() ?? 0.0)) / data.length;
        }
        emit(ListFeedbackServiceLoaded(feedbacks: data..sort((a, b) => b.createdAt.compareTo(a.createdAt)), average: average));
      });
    });
  }
}
