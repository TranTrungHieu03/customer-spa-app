import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/datasources/routine_remote_data_source.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/list_order_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/order_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_tracking_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/book_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_current_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_history_order_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_list_appointment_by_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_order_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_history.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_step.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_tracking.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';

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

  @override
  Future<Either<Failure, int>> bookRoutine(BookRoutineParams params) async {
    try {
      int result = await _dataSource.bookRoutine(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, RoutineModel>> getCurrentRoutine(GetCurrentRoutineParams params) async {
    try {
      RoutineModel result = await _dataSource.getCurrentRoutine(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, RoutineTrackingModel>> getRoutineTracking(GetRoutineTrackingParams params) async {
    try {
      RoutineTrackingModel result = await _dataSource.getRoutineTracking(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<RoutineModel>>> getHistoryRoutine(GetRoutineHistoryParams params) async {
    try {
      List<RoutineModel> result = await _dataSource.getHistoryRoutine(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, OrderRoutineModel>> getOrderRoutine(GetOrderRoutineParams params) async {
    try {
      OrderRoutineModel result = await _dataSource.getOrderRoutine(params);
      AppLogger.wtf(result);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ListOrderRoutineModel>> getOrderRoutineHistory(GetHistoryOrderRoutineParams params) async {
    try {
      ListOrderRoutineModel result = await _dataSource.getHistoryOrderRoutine(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>> getListAppointmentsByRoutine(GetListAppointmentByRoutineParams params) async {
    try {
      List<AppointmentModel> result = await _dataSource.getAppointmentsByRoutine(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
