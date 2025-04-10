import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/product/data/model/product_feedback_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/feedback_product.dart';

part 'feedback_product_event.dart';
part 'feedback_product_state.dart';

class FeedbackProductBloc extends Bloc<FeedbackProductEvent, FeedbackProductState> {
  final FeedbackProduct _feedbackProduct;

  FeedbackProductBloc({required FeedbackProduct feedbackProduct})
      : _feedbackProduct = feedbackProduct,
        super(FeedbackProductInitial()) {
    on<SendFeedbackProductEvent>((event, emit) async {
      emit(FeedbackProductLoading());
      final result = await _feedbackProduct(event.params);
      result.fold((message) => emit(FeedbackProductError(message)), (data) => emit(FeedbackProductLoaded(data)));
    });
  }
}
