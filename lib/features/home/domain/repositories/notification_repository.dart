import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/list_notification_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_all_notification.dart';
import 'package:spa_mobile/features/home/domain/usecases/mark_as_read.dart';
import 'package:spa_mobile/features/home/domain/usecases/mark_as_read_all.dart';

abstract class NotificationRepository {
  Future<Either<Failure, String>> markAsRead(MarkAsReadParams params);

  Future<Either<Failure, String>> markAsReadAll(MarkAsReadAllParams params);

  Future<Either<Failure, ListNotificationModel>> getAllNotification(GetAllNotificationParams params);
}
