import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_product_detail.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductDetail _getProductDetail;

  ProductBloc({required GetProductDetail getProductDetail})
      : _getProductDetail = getProductDetail,
        super(ProductInitial()) {
    on<GetProductDetailEvent>(_onGetProductDetail);
  }

  Future<void> _onGetProductDetail(
    GetProductDetailEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result =
        await _getProductDetail.call(GetProductDetailParams(event.productId));
    result.fold(
      (failure) => emit(ProductFailure(failure.message)),
      (product) => emit(ProductLoaded(product)),
    );
  }
}
