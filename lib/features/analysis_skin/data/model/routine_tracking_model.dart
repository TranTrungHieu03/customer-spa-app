import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';

class RoutineTrackingModel {
  final int userRoutineId;
  final int userId;
  final UserModel user;
  final int routineId;
  final RoutineModel routine;
  final String status;
  final String? progressNote;
  final String startDate;
  final String endDate;
  final List<RoutineStepModel> userRoutineSteps;

  RoutineTrackingModel({
    required this.userRoutineId,
    required this.userId,
    required this.user,
    required this.routineId,
    required this.routine,
    required this.status,
    this.progressNote,
    required this.startDate,
    required this.endDate,
    required this.userRoutineSteps,
  });

  // Convert JSON to Object
  factory RoutineTrackingModel.fromJson(Map<String, dynamic> json) {
    return RoutineTrackingModel(
      userRoutineId: json['userRoutineId'],
      userId: json['userId'],
      user: UserModel.fromJson(json['user']),
      routineId: json['routineId'],
      routine: RoutineModel.fromJson(json['routine']),
      status: json['status'],
      progressNote: json['progressNote'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      userRoutineSteps:
          (json['userRoutineSteps'] as List<dynamic>).map((step) => RoutineStepModel.fromJson(step['skinCareRoutineStep'])).toList(),
    );
  }
}
