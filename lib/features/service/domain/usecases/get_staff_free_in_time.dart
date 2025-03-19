import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/staff_service_model.dart';
import 'package:spa_mobile/features/service/domain/repository/staff_repository.dart';

class GetStaffFreeInTime implements UseCase<Either, GetStaffFreeInTimeParams> {
  final StaffRepository _repository;

  GetStaffFreeInTime(this._repository);

  @override
  Future<Either<Failure, List<StaffServiceModel>>> call(GetStaffFreeInTimeParams params) async {
    return await _repository.getStaffFreeInTime(params);
  }
}

class GetStaffFreeInTimeParams {
  final int branchId;
  final List<int> serviceIds;
  final List<DateTime> startTimes;

  GetStaffFreeInTimeParams({required this.branchId, required this.serviceIds, required this.startTimes});

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'serviceIds': serviceIds,
      'startTimes': startTimes.map((time) => time.toIso8601String()).toList(),
    };
  }
}
