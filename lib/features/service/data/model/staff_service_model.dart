import 'package:spa_mobile/features/service/data/model/staff_model.dart';

class StaffServiceModel {
  final int? serviceCategoryId;
  final List<StaffModel> staffs;
  final int? serviceId;

  StaffServiceModel({this.serviceCategoryId, required this.staffs, this.serviceId});

  factory StaffServiceModel.fromJson(Map<String, dynamic> json) {
    return StaffServiceModel(
      serviceCategoryId: json['serviceCategoryId'] ?? 0,
      staffs: (json['staffs'] as List).map((x) => StaffModel.fromJson(x)).toList(),
      serviceId: json['serviceId'] ?? 0,
    );
  }
}
