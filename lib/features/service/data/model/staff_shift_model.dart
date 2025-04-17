import 'package:spa_mobile/features/service/data/model/shift_model.dart';
import 'package:spa_mobile/features/service/domain/entities/staff_shift.dart';

class StaffShiftModel extends StaffShift {
  final ShiftModel shift;

  // final UserModel staff;

  const StaffShiftModel(
      {required super.id,
      required super.staffId,
      required super.shiftId,
      required super.workDate,
      required super.status,
      required super.dayOfWeek,
      // required this.staff,
      required this.shift});

  factory StaffShiftModel.fromJson(Map<String, dynamic> json) {
    return StaffShiftModel(
      id: json['id'],
      staffId: json['staffId'],
      shiftId: json['shiftId'],
      workDate: DateTime.parse(json['workDate'] as String),
      status: json['status'] ?? "Active" as String,
      dayOfWeek: json['dayOfWeek'] as int,
      shift: ShiftModel.fromJson(json['shift']),
      // staff: UserModel.fromJson(json['staff']),
    );
  }
}
