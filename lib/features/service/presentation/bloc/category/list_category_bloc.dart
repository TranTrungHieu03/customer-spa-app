import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/category_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_categories.dart';

part 'list_category_event.dart';
part 'list_category_state.dart';

class ListCategoryBloc extends Bloc<ListCategoryEvent, ListCategoryState> {
  final GetListCategories _getListCategories;

  ListCategoryBloc({required GetListCategories getListCategories})
      : _getListCategories = getListCategories,
        super(ListCategoryInitial()) {
    on<GetListCategoriesEvent>(_onGetListCategories);
  }

  Future<void> _onGetListCategories(GetListCategoriesEvent event, Emitter<ListCategoryState> emit) async {
    final currentState = state;
    if (currentState is ListCategoryLoaded) {
      return;
    } else {
      emit(ListCategoryLoading());
      final result = await _getListCategories(NoParams());
      result.fold((failure) => emit(ListCategoryError(failure.message)), (result) {
        if (result.isEmpty) {
          emit(ListCategoryEmpty());
        } else {
          emit(ListCategoryLoaded(result));
        }
      });
    }
  }
}
