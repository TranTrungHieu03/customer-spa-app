import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';

abstract class StaffRepository {
  const StaffRepository();

  Future<Either<Failure, List<StaffModel>>> getListStaff(GetListStaffParams param);
}
