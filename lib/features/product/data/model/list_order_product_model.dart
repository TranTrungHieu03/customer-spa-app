import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/product/data/model/order_product_model.dart';

class ListOrderProductModel {
  final List<OrderProductModel> data;
  final PaginationModel pagination;

  ListOrderProductModel({required this.data, required this.pagination});

  factory ListOrderProductModel.fromJson(List<dynamic>? json, Map<String, dynamic>? paginationJson) {
    return ListOrderProductModel(
        data: json != null ? json.map((appointmentJson) => OrderProductModel.fromJson(appointmentJson)).toList() : [],
        pagination: paginationJson != null ? PaginationModel.fromJson(paginationJson) : PaginationModel.isEmty());
  }
}
