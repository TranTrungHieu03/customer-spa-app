import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/model/list_service_model.dart';
import 'package:spa_mobile/features/service/data/model/service_feedback_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/feedback_service.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_feedback_service.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_services.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_service_detail.dart';

abstract class ServiceRepository {
  const ServiceRepository();

  Future<Either<Failure, ListServiceModel>> getServices(GetListServiceParams param);

  Future<Either<Failure, ListServiceModel>> getServicesByBranch(GetListServiceParams param);

  Future<Either<Failure, ServiceModel>> getServiceDetail(GetServiceDetailParams params);

  Future<Either<Failure, ServiceFeedbackModel>> feedbackService(FeedbackServiceParams params);

  Future<Either<Failure, List<ServiceFeedbackModel>>> getFeedbackServices(GetListFeedbackServiceParams params);
}
