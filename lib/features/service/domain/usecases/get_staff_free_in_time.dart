import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/repository/staff_repository.dart';

class GetStaffFreeInTime implements UseCase<Either, GetStaffFreeInTimeParams> {
  final StaffRepository _repository;

  GetStaffFreeInTime(this._repository);

  @override
  Future<Either<Failure, List<StaffModel>>> call(GetStaffFreeInTimeParams params) async {
    return await _repository.getStaffFreeInTime(params);
  }
}

class GetStaffFreeInTimeParams {
  final int branchId;
  final int serviceId;
  final String startTime;

  GetStaffFreeInTimeParams({required this.branchId, required this.serviceId, required this.startTime});
}
