import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/product/data/model/product_feedback_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/list_feedback_product.dart';

part 'list_product_feedback_event.dart';
part 'list_product_feedback_state.dart';

class ListProductFeedbackBloc extends Bloc<ListProductFeedbackEvent, ListProductFeedbackState> {
  final GetListProductFeedback _getListProductFeedback;

  ListProductFeedbackBloc({required GetListProductFeedback getListProductFeedback})
      : _getListProductFeedback = getListProductFeedback,
        super(ListProductFeedbackInitial()) {
    on<GetListFeedbackProductEvent>((event, emit) async {
      // TODO: implement event handler
      emit(ListProductFeedbackLoading());
      final result = await _getListProductFeedback(event.params);
      result.fold((message) => emit(ListProductFeedbackError(message.toString())), (data) {
        double average = 5;
        if ((data as List<ProductFeedbackModel>).isNotEmpty) {
          final double totalRate = data.fold(0.0, (x, y) => x + (y.rating?.toDouble() ?? 5.0));
          average = totalRate / data.length;
        }
        emit(ListProductFeedbackLoaded(feedbacks: data, average: average));
      });
    });
  }
}
