import 'package:spa_mobile/features/service/data/model/staff_list_slot_working_model.dart';

class ServiceStaffShiftModel {
  final int serviceId;
  final List<StaffListSlotWorkingModel> workingStaffs;

  const ServiceStaffShiftModel({
    required this.serviceId,
    required this.workingStaffs,
  });

  factory ServiceStaffShiftModel.fromJson(Map<String, dynamic> json) {
    return ServiceStaffShiftModel(
      serviceId: json['serviceId'] as int,
      workingStaffs: (json['workingStaffs'] as List<dynamic>).map((e) => StaffListSlotWorkingModel.fromJson(e)).toList(),
    );
  }
}
