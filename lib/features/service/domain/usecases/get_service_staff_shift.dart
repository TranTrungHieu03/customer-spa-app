import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/staff_repository.dart';

class GetServiceStaffShiftParams {
  final List<int> serviceIds;
  final int branchId;
  final DateTime workDate;

  GetServiceStaffShiftParams({
    required this.serviceIds,
    required this.branchId,
    required this.workDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceIds': serviceIds,
      'branchId': branchId,
      'workDate': workDate.toIso8601String(),
    };
  }
}

class GetServiceStaffShift implements UseCase<Either, GetServiceStaffShiftParams> {
  final StaffRepository repository;

  const GetServiceStaffShift(this.repository);

  @override
  Future<Either> call(GetServiceStaffShiftParams params) async {
    return await repository.getServiceStaffShift(params);
  }
}
