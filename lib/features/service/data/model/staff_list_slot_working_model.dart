import 'package:spa_mobile/features/service/data/model/shift_model.dart';

class StaffListSlotWorkingModel {
  final int staffId;
  final List<ShiftModel> shifts;

  const StaffListSlotWorkingModel({
    required this.staffId,
    required this.shifts,
  });

  factory StaffListSlotWorkingModel.fromJson(Map<String, dynamic> json) {
    return StaffListSlotWorkingModel(
      staffId: json['staffId'] as int,
      shifts: (json['shifts'] as List<dynamic>).map((e) => ShiftModel.fromJson(e)).toList(),
    );
  }
}
