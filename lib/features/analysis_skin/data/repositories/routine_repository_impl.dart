import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/analysis_skin/data/datasources/routine_remote_data_source.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_step.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_product_detail.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineRemoteDataSource _dataSource;

  RoutineRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<RoutineModel>>> getListSkinCareRoutine() async {
    try {
      List<RoutineModel> result = await _dataSource.getListSkinCare();
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, RoutineModel>> getRoutineDetail(GetRoutineDetailParams params) async {
    try {
      RoutineModel result = await _dataSource.getRoutineDetail(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<RoutineStepModel>>> getSkinCareRoutineStep(GetRoutineStepParams params) async {
    try {
      List<RoutineStepModel> result = await _dataSource.getRoutineStep(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
