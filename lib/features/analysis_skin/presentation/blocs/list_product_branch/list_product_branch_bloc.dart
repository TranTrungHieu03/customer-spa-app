import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/product/data/model/product_branch_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_branch_has_product.dart';

part 'list_product_branch_event.dart';
part 'list_product_branch_state.dart';

class ListProductBranchBloc extends Bloc<ListProductBranchEvent, ListProductBranchState> {
  final GetBranchHasProduct _getBranchHasProduct;

  ListProductBranchBloc({required GetBranchHasProduct getBranchHasProduct})
      : _getBranchHasProduct = getBranchHasProduct,
        super(ListProductBranchInitial()) {
    on<GetListProductBranchEvent>((event, emit) async {
      emit(ListProductBranchLoading());
      final result = await _getBranchHasProduct(event.params);
      result.fold((message) => emit(ListProductBranchError(message.message)), (data) => emit(ListProductBranchLoaded(data)));
    });
  }
}
