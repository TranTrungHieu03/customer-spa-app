import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/staff_time_model.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

class GetTimeSlotByDate implements UseCase<Either, GetTimeSlotByDateParams> {
  final AppointmentRepository _appointmentRepository;

  GetTimeSlotByDate(this._appointmentRepository);

  @override
  Future<Either<Failure, List<StaffTimeModel>>> call(GetTimeSlotByDateParams params) async {
    return await _appointmentRepository.getTimeSlots(params);
  }
}

class GetTimeSlotByDateParams {
  final List<int> staffId;
  final DateTime date;

  const GetTimeSlotByDateParams({required this.staffId, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'staffId': staffId,
      'date': date.toString(),
    };
  }
}
