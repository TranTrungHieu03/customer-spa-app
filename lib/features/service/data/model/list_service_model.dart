import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';

class ListServiceModel {
  final List<ServiceModel> services;
  final PaginationModel pagination;

  ListServiceModel({required this.services, required this.pagination});
}
