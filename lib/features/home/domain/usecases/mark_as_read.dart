import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/notification_repository.dart';

class MarkAsReadParams {
  final int id;

  MarkAsReadParams(this.id);

  int toJson() => id;
}

class MarkAsRead implements UseCase<Either, MarkAsReadParams> {
  final NotificationRepository _repository;

  MarkAsRead(this._repository);

  @override
  Future<Either> call(MarkAsReadParams params) async {
    return await _repository.markAsRead(params);
  }
}
