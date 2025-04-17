import 'package:spa_mobile/features/service/data/model/staff_shift_model.dart';

class StaffSlotWorkingModel {
  final int staffId;
  final List<StaffShiftModel> workSchedules;

  const StaffSlotWorkingModel({
    required this.staffId,
    required this.workSchedules,
  });

  factory StaffSlotWorkingModel.fromJson(Map<String, dynamic> json) {
    return StaffSlotWorkingModel(
      staffId: json['staffId'] as int,
      workSchedules: (json['workSchedules'] as List<dynamic>).map((e) => StaffShiftModel.fromJson(e)).toList(),
    );
  }
}
