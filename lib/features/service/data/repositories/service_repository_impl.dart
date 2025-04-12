import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/network/connection_checker.dart';
import 'package:spa_mobile/features/service/data/datasources/service_remote_data_source.dart';
import 'package:spa_mobile/features/service/data/model/list_service_model.dart';
import 'package:spa_mobile/features/service/data/model/service_feedback_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/domain/repository/service_repository.dart';
import 'package:spa_mobile/features/service/domain/usecases/feedback_service.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_feedback_service.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_services.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_service_detail.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSrc _serviceRemoteDataSrc;
  final ConnectionChecker _connectionChecker;

  ServiceRepositoryImpl(this._serviceRemoteDataSrc, this._connectionChecker);

  @override
  Future<Either<Failure, ServiceModel>> getServiceDetail(GetServiceDetailParams params) async {
    try {
      ServiceModel result = await _serviceRemoteDataSrc.getServiceDetail(params);

      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ListServiceModel>> getServices(GetListServiceParams param) async {
    try {
      ListServiceModel result = await _serviceRemoteDataSrc.getServices(param);

      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ListServiceModel>> getServicesByBranch(GetListServiceParams param) async {
    try {
      ListServiceModel result = await _serviceRemoteDataSrc.getServicesByBranch(param);

      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ServiceFeedbackModel>> feedbackService(FeedbackServiceParams params) async {
    try {
      ServiceFeedbackModel result = await _serviceRemoteDataSrc.feedbackService(params);

      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ServiceFeedbackModel>>> getFeedbackServices(GetListFeedbackServiceParams params) async {
    try {
      List<ServiceFeedbackModel> result = await _serviceRemoteDataSrc.getListFeedbackService(params);

      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
