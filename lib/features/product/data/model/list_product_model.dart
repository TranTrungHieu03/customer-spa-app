import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';

class ListProductModel {
  final List<ProductModel> products;
  final PaginationModel pagination;

  ListProductModel({required this.products, required this.pagination});

  factory ListProductModel.fromJson(
      List<dynamic>? json, Map<String, dynamic>? paginationJson) {
    return ListProductModel(
        products: json != null
            ? json
                .map((productJson) => ProductModel.fromJson(productJson))
                .toList()
            : [],
        pagination: paginationJson != null
            ? PaginationModel.fromJson(paginationJson)
            : PaginationModel.isEmty());
  }
}
