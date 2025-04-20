import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/datasources/staff_remote_data_source.dart';
import 'package:spa_mobile/features/service/data/model/service_staff_shift_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_service_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_slot_working.dart';
import 'package:spa_mobile/features/service/domain/repository/staff_repository.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_slot_working.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff_by_list_id.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_service_staff_shift.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_single_staff.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_staff_free_in_time.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource _staffRemoteDataSource;

  const StaffRepositoryImpl(this._staffRemoteDataSource);

  @override
  Future<Either<Failure, List<StaffServiceModel>>> getListStaff(GetListStaffParams params) async {
    try {
      List<StaffServiceModel> response = await _staffRemoteDataSource.getStaffs(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StaffModel>>> getListStaffByListId(GetListStaffByListIdParams param) async {
    try {
      List<StaffModel> response = await _staffRemoteDataSource.getStaffByListIds(param);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StaffModel>> getSingleStaff(GetSingleStaffParams param) async {
    try {
      StaffModel response = await _staffRemoteDataSource.getSingleStaff(param);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StaffServiceModel>>> getStaffFreeInTime(GetStaffFreeInTimeParams param) async {
    try {
      List<StaffServiceModel> response = await _staffRemoteDataSource.getStaffFreeInTime(param);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StaffSlotWorkingModel>>> getListSlotWorking(GetListSlotWorkingParams param) async {
    try {
      List<StaffSlotWorkingModel> response = await _staffRemoteDataSource.getStaffShift(param);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceStaffShiftModel>>> getServiceStaffShift(GetServiceStaffShiftParams param) async {
    try {
      List<ServiceStaffShiftModel> response = await _staffRemoteDataSource.getServiceStaffShift(param);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
