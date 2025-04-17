import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class GetListAppointmentByRoutineParams {
  final String id;

  const GetListAppointmentByRoutineParams({required this.id});

  Map<String, dynamic> toJson() {
    return {
      'routineId': id,
    };
  }
}

class GetAppointmentsByRoutine implements UseCase<Either, GetListAppointmentByRoutineParams> {
  final RoutineRepository repository;

  const GetAppointmentsByRoutine(this.repository);

  @override
  Future<Either> call(GetListAppointmentByRoutineParams params) async {
    return await repository.getListAppointmentsByRoutine(params);
  }
}
