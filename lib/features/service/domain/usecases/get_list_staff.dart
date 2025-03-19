import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/staff_service_model.dart';
import 'package:spa_mobile/features/service/domain/repository/staff_repository.dart';

class GetListStaff implements UseCase<Either, GetListStaffParams> {
  final StaffRepository _repository;

  GetListStaff(this._repository);

  @override
  Future<Either<Failure, List<StaffServiceModel>>> call(GetListStaffParams params) async {
    return await _repository.getListStaff(params);
  }
}

class GetListStaffParams {
  final int branchId;
  final List<int> serviceCategoryIds;

  GetListStaffParams({required this.branchId, required this.serviceCategoryIds});

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'serviceCategoryIds': serviceCategoryIds,
    };
  }
}
