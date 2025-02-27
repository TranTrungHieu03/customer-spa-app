import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';

class ListAppointmentModel {
  final List<AppointmentModel> data;
  final PaginationModel pagination;

  ListAppointmentModel({required this.data, required this.pagination});

  factory ListAppointmentModel.fromJson(List<dynamic>? json, Map<String, dynamic>? paginationJson) {
    return ListAppointmentModel(
        data: json != null ? json.map((appointmentJson) => AppointmentModel.fromJson(appointmentJson)).toList() : [],
        pagination: paginationJson != null ? PaginationModel.fromJson(paginationJson) : PaginationModel.isEmty());
  }
}
