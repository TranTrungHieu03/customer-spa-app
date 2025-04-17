import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/staff_slot_working.dart';
import 'package:spa_mobile/features/service/domain/repository/staff_repository.dart';

class GetListSlotWorkingParams {
  final List<int> staffIds;
  final DateTime workDate;

  const GetListSlotWorkingParams({
    required this.staffIds,
    required this.workDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'staffIds': staffIds,
      'workDate': workDate.toIso8601String(),
    };
  }
}

class GetSlotWorking implements UseCase<Either, GetListSlotWorkingParams> {
  final StaffRepository repository;

  const GetSlotWorking(this.repository);

  @override
  Future<Either<Failure, List<StaffSlotWorkingModel>>> call(GetListSlotWorkingParams params) async {
    return await repository.getListSlotWorking(params);
  }
}
