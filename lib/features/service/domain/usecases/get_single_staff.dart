import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/repository/staff_repository.dart';

class GetSingleStaff implements UseCase<Either, GetSingleStaffParams> {
  final StaffRepository _repository;

  GetSingleStaff(this._repository);

  @override
  Future<Either<Failure, StaffModel>> call(GetSingleStaffParams params) async {
    return await _repository.getSingleStaff(params);
  }
}

class GetSingleStaffParams {
  final int staffId;

  GetSingleStaffParams({required this.staffId});
}
