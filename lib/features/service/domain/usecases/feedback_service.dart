import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/service_repository.dart';

class FeedbackServiceParams {
  final int serviceId;
  final int customerId;
  final String comment;
  final double rating;

  FeedbackServiceParams({
    required this.serviceId,
    required this.customerId,
    required this.comment,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'customerId': customerId,
      'comment': comment,
      'rating': rating.toInt(),
      'userId': 1,
    };
  }
}

class FeedbackService implements UseCase<Either, FeedbackServiceParams> {
  final ServiceRepository _repository;

  FeedbackService(this._repository);

  @override
  Future<Either> call(FeedbackServiceParams params) async {
    return await _repository.feedbackService(params);
  }
}
