import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class UpdateAppointmentRoutineParams {
  final int orderId;
  final int fromStep;
  final DateTime startTime;
  final int routineId;
  final int userId;

  UpdateAppointmentRoutineParams({
    required this.orderId,
    required this.fromStep,
    required this.startTime,
    required this.routineId,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "fromStep": fromStep,
        "startTime": startTime.toIso8601String(),
      };
}

class UpdateAppointmentRoutine implements UseCase<Either, UpdateAppointmentRoutineParams> {
  final RoutineRepository _repository;

  UpdateAppointmentRoutine(this._repository);

  @override
  Future<Either> call(UpdateAppointmentRoutineParams params) async {
    return await _repository.updateAppointmentRoutine(params);
  }
}
