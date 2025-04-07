import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_list_products.dart';

part 'list_product_event.dart';
part 'list_product_state.dart';

class ListProductBloc extends Bloc<ListProductEvent, ListProductState> {
  final GetListProducts _getListProducts;

  ListProductBloc({required GetListProducts getListProducts})
      : _getListProducts = getListProducts,
        super(ListProductInitial()) {
    on<GetListProductsEvent>(_onGetListProductsEvent);
    on<RefreshListProductEvent>(_onRefreshListProductsEvent);
  }

  Future<void> _onGetListProductsEvent(GetListProductsEvent event, Emitter<ListProductState> emit) async {
    final currentState = state;
    if (currentState is ListProductLoaded && currentState.isLoadingMore) {
      return;
    }
    if (currentState is ListProductLoaded) {
      AppLogger.info("go here Loaded");
      emit(currentState.copyWith(isLoadingMore: true));
      final result = await _getListProducts(event.params);
      result.fold(
        (failure) => emit(ListProductFailure(failure.message)),
        (result) => emit(ListProductLoaded(
          products: currentState.products + result.products,
          pagination: result.pagination,
          isLoadingMore: false,
        )),
      );
    } else {
      AppLogger.info("go here Initial");
      emit(const ListProductLoading(isLoadingMore: false));
      final result = await _getListProducts(event.params);
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

  Future<void> _onRefreshListProductsEvent(RefreshListProductEvent event, Emitter<ListProductState> emit) async {
    emit(const ListProductLoading());
  }
}
