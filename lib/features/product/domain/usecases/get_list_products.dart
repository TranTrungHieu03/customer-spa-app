import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/data/model/list_product_model.dart';
import 'package:spa_mobile/features/product/domain/repository/product_repository.dart';

class GetListProducts implements UseCase<Either, GetListProductParams> {
  final ProductRepository _productRepository;

  GetListProducts(this._productRepository);

  @override
  Future<Either<Failure, ListProductModel>> call(GetListProductParams params) async {
    return await _productRepository.getProducts(params);
  }
}

class GetListProductParams {
  final int branchId;
  final String brand;
  final List<int>? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String sortBy;
  final int page;
  final int pageSize;

  GetListProductParams({
    required this.brand,
    required this.page,
    required this.branchId,
    required this.categoryId,
    required this.minPrice,
    required this.maxPrice,
    required this.pageSize,
    required String sortBy,
  }) : sortBy = sortBy.isEmpty ? sortBy : (sortBy == "0" ? SortBy.priceAsc.value : SortBy.priceDesc.value);

  factory GetListProductParams.empty(int branchId) {
    return GetListProductParams(
        brand: "", page: 1, branchId: branchId, categoryId: [], minPrice: -1.0, maxPrice: -1.0, sortBy: "", pageSize: 20);
  }

  GetListProductParams copyWith(
      {int? branchId, String? brand, List<int>? categoryId, double? minPrice, double? maxPrice, String? sortBy, int? page, int? pageSize}) {
    return GetListProductParams(
        branchId: branchId ?? this.branchId,
        brand: brand ?? this.brand,
        categoryId: categoryId ?? this.categoryId,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        sortBy: sortBy ?? this.sortBy,
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize);
  }
}

enum SortBy {
  priceAsc("price_asc"),
  priceDesc("price_desc");

  final String value;

  const SortBy(this.value);
}
