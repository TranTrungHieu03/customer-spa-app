import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_product_by_product_id.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_product_detail.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductDetail _getProductDetail;
  final GetProductByProductId _getProductByProductId;

  ProductBloc({required GetProductDetail getProductDetail, required GetProductByProductId getProductByProductId})
      : _getProductDetail = getProductDetail,
        _getProductByProductId = getProductByProductId,
        super(ProductInitial()) {
    on<GetProductDetailEvent>(_onGetProductDetail);
    on<GetProductDetailByProductIdEvent>(_onGetProductDetailByProductId);
  }

  Future<void> _onGetProductDetail(
    GetProductDetailEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await _getProductDetail(GetProductDetailParams(event.productId));
    result.fold(
      (failure) => emit(ProductFailure(failure.message)),
      (product) => emit(ProductLoaded(product)),
    );
  }

  Future<void> _onGetProductDetailByProductId(
    GetProductDetailByProductIdEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await _getProductByProductId(event.productId);
    result.fold(
      (failure) => emit(ProductFailure(failure.message)),
      (product) => emit(ProductLoaded(product)),
    );
  }
}
