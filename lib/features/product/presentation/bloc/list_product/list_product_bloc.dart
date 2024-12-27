import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/repository/product_repository.dart';

part 'list_product_event.dart';
part 'list_product_state.dart';

class ListProductBloc extends Bloc<ListProductEvent, ListProductState> {
  final ProductRepository _productRepository;

  ListProductBloc(this._productRepository) : super(ListProductInitial()) {
    on<GetListProductsEvent>(_onGetListProductsEvent);
  }

  Future<void> _onGetListProductsEvent(
      GetListProductsEvent event, Emitter<ListProductState> emit) async {
    final currentState = state;
    if (currentState is ListProductLoaded && currentState.isLoadingMore) {
      return;
    }
    if (currentState is ListProductLoaded) {
      emit(currentState.copyWith(isLoadingMore: true));
      final result = await _productRepository.getProducts(event.page);
      result.fold(
        (failure) => emit(ListProductFailure(failure.message)),
        (result) => emit(ListProductLoaded(
          products: currentState.products + result.products,
          pagination: result.pagination,
          isLoadingMore: false,
        )),
      );
    } else {
      emit(const ListProductLoading(isLoadingMore: false));
      final result = await _productRepository.getProducts(event.page);
      result.fold(
        (failure) => emit(ListProductFailure(failure.message)),
        (result) {
          if (result.products.isEmpty) {
            emit(ListProductEmpty());
          } else {
            emit(ListProductLoaded(
              products: result.products,
              pagination: result.pagination,
            ));
          }
        },
      );
    }
  }
}
