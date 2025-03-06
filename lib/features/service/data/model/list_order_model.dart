import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/data/model/order_appointment_model.dart';

class ListOrderAppointmentModel {
  final List<OrderAppointmentModel> data;
  final PaginationModel pagination;

  ListOrderAppointmentModel({required this.data, required this.pagination});

  factory ListOrderAppointmentModel.fromJson(List<dynamic>? json, Map<String, dynamic>? paginationJson) {
    return ListOrderAppointmentModel(
        data: json != null ? json.map((appointmentJson) => OrderAppointmentModel.fromJson(appointmentJson)).toList() : [],
        pagination: paginationJson != null ? PaginationModel.fromJson(paginationJson) : PaginationModel.isEmty());
  }
}
