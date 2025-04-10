import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/order_routine_model.dart';

class ListOrderRoutineModel {
  final List<OrderRoutineModel> data;
  final PaginationModel pagination;

  ListOrderRoutineModel({required this.data, required this.pagination});

  factory ListOrderRoutineModel.fromJson(List<dynamic>? json, Map<String, dynamic>? paginationJson) {
    return ListOrderRoutineModel(
        data: json != null ? json.map((appointmentJson) => OrderRoutineModel.fromJson(appointmentJson)).toList() : [],
        pagination: paginationJson != null ? PaginationModel.fromJson(paginationJson) : PaginationModel.isEmty());
  }
}
