import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff_by_list_id.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_single_staff.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_staff_free_in_time.dart';

abstract class StaffRepository {
  const StaffRepository();

  Future<Either<Failure, List<StaffModel>>> getListStaff(GetListStaffParams param);

  Future<Either<Failure, List<StaffModel>>> getStaffFreeInTime(GetStaffFreeInTimeParams param);

  Future<Either<Failure, StaffModel>> getSingleStaff(GetSingleStaffParams param);

  Future<Either<Failure, List<StaffModel>>> getListStaffByListId(GetListStaffByListIdParams param);
}
