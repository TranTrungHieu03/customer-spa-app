import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';

class ListServiceModel {
  final List<ServiceModel> services;
  final PaginationModel pagination;

  ListServiceModel({required this.services, required this.pagination});

  factory ListServiceModel.fromJson(List<dynamic>? json, Map<String, dynamic>? paginationJson) {
    return ListServiceModel(
        services: json != null ? json.map((productJson) => ServiceModel.fromJson(productJson)).toList() : [],
        pagination: paginationJson != null ? PaginationModel.fromJson(paginationJson) : PaginationModel.isEmty());
  }
}
