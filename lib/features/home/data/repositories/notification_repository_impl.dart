import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/list_notification_model.dart';
import 'package:spa_mobile/features/home/data/datasources/notification_remote_data_source.dart';
import 'package:spa_mobile/features/home/domain/repositories/notification_repository.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_all_notification.dart';
import 'package:spa_mobile/features/home/domain/usecases/mark_as_read.dart';
import 'package:spa_mobile/features/home/domain/usecases/mark_as_read_all.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, ListNotificationModel>> getAllNotification(GetAllNotificationParams params) async {
    try {
      final ListNotificationModel response = await _dataSource.getListNotification(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> markAsRead(MarkAsReadParams params) async {
    try {
      final String response = await _dataSource.markAsRead(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> markAsReadAll(MarkAsReadAllParams params) async {
    try {
      final String response = await _dataSource.markAsReadAll(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
