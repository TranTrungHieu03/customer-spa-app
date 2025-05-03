import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/notification_repository.dart';

class GetAllNotificationParams {
  final int userId;
  final int pageIndex;
  final int pageSize;
  final bool? isRead;

  GetAllNotificationParams({required this.userId, required this.pageIndex, required this.pageSize, this.isRead});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'pageIndex': pageIndex,
      'pageSize': pageSize,
    };
  }
}

class GetAllNotification implements UseCase<Either, GetAllNotificationParams> {
  final NotificationRepository _repository;

  GetAllNotification(this._repository);

  @override
  Future<Either> call(GetAllNotificationParams params) async {
    return await _repository.getAllNotification(params);
  }
}
