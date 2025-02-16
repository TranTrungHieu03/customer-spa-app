import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

class GetListAppointment implements UseCase<Either, GetListAppointmentParams> {
  final AppointmentRepository _repository;

  GetListAppointment(this._repository);

  @override
  Future<Either<Failure, List<AppointmentModel>>> call(GetListAppointmentParams params) async {
    return await _repository.getHistoryBooking(params);
  }
}

class GetListAppointmentParams {
  final int page;
  final String status;

  GetListAppointmentParams({required this.page, required this.status});
}
