import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/repository/staff_repository.dart';

class GetListStaff implements UseCase<Either, GetListStaffParams> {
  final StaffRepository _repository;

  GetListStaff(this._repository);

  @override
  Future<Either<Failure, List<StaffModel>>> call(GetListStaffParams params) async {
    return await _repository.getListStaff(params);
  }
}

class GetListStaffParams {
  final int id;

  GetListStaffParams({required this.id});
}
