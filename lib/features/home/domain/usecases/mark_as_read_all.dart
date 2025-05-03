import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/notification_repository.dart';

class MarkAsReadAllParams {
  final int userId;

  MarkAsReadAllParams(this.userId);
}

class MarkAsReadAll implements UseCase<Either, MarkAsReadAllParams> {
  final NotificationRepository _repository;

  MarkAsReadAll(this._repository);

  @override
  Future<Either> call(MarkAsReadAllParams params) async {
    return await _repository.markAsReadAll(params);
  }
}
