import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/product_repository.dart';

class FeedbackProductParams {
  final int productId;
  final int customerId;
  final String comment;
  final double rating;

  FeedbackProductParams({
    required this.productId,
    required this.customerId,
    required this.comment,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'customerId': customerId,
      'comment': comment,
      'rating': rating.toInt(),
    };
  }
}

class FeedbackProduct implements UseCase<Either, FeedbackProductParams> {
  final ProductRepository _repository;

  FeedbackProduct(this._repository);

  @override
  Future<Either> call(FeedbackProductParams params) async {
    return await _repository.feedback(params);
  }
}
