import 'package:spa_mobile/features/analysis_skin/domain/entities/routine_logger.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';

class RoutineLoggerModel extends RoutineLogger {
  final UserModel? staff;
  final UserModel? customer;

  RoutineLoggerModel(
      {required super.userRoutineLoggerId,
      required super.stepId,
      required super.staffId,
      required super.userId,
      required super.actionDate,
      required super.status,
      required super.stepLogger,
      required super.notes,
      required super.createdDate,
      required super.updatedDate,
      this.staff,
      this.customer});

  factory RoutineLoggerModel.fromJson(Map<String, dynamic> json) => RoutineLoggerModel(
      userRoutineLoggerId: json["userRoutineLoggerId"],
      stepId: json["stepId"],
      staffId: json["managerId"] ?? 0,
      userId: json["userId"] ?? 0,
      actionDate: DateTime.parse(json["actionDate"]),
      status: json["status"],
      stepLogger: json["step_Logger"],
      notes: json["notes"],
      createdDate: DateTime.parse(json["createdDate"]),
      updatedDate: DateTime.parse(json["updatedDate"]),
      staff: json['manager'] != null ? UserModel.fromJson(json['manager']) : null,
      customer: json['user'] != null ? UserModel.fromJson(json['user']) : null);
}
