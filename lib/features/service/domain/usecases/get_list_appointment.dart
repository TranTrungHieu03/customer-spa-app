import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

final class GetListAppointmentParams {
  final String startTime;
  final String endTime;

  GetListAppointmentParams({
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startTime,
      'endDate': endTime,
    };
  }
}

final class GetListAppointment implements UseCase<Either, GetListAppointmentParams> {
  final AppointmentRepository _repository;

  GetListAppointment(this._repository);

  @override
  Future<Either> call(GetListAppointmentParams params) async {
    return await _repository.getHistoryBooking(params);
  }
}
