import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/user/data/model/list_service_product_model.dart';
import 'package:spa_mobile/features/user/domain/usecases/get_recommend.dart';

part 'recommend_event.dart';
part 'recommend_state.dart';

class RecommendBloc extends Bloc<RecommendEvent, RecommendState> {
  final GetRecommend _getRecommend;

  RecommendBloc({required GetRecommend getRcm})
      : _getRecommend = getRcm,
        super(RecommendInitial()) {
    on<GetListRecommendEvent>((event, emit) async {
      emit(RecommendLoading());
      final result = await _getRecommend(event.params);
      result.fold((message) => emit(RecommendError(message.message)), (data) => emit(RecommendLoaded(data)));
    });
  }
}
