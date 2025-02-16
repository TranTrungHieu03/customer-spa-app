import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/service/data/datasources/staff_remote_data_source.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/repository/staff_repository.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource _staffRemoteDataSource;

  const StaffRepositoryImpl(this._staffRemoteDataSource);

  @override
  Future<Either<Failure, List<StaffModel>>> getListStaff(GetListStaffParams params) async {
    try {
      List<StaffModel> response = await _staffRemoteDataSource.getStaffs(params);
      AppLogger.debug("!!!!!!!!!!!!!!!!!!!!!!!!!!");
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
