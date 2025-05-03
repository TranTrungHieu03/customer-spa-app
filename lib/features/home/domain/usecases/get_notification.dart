import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/models/notification_model.dart';
import 'package:spa_mobile/features/home/domain/repositories/chat_repository.dart';

class GetNotification {
  final ChatRepository repository;

  GetNotification(this.repository);

  Stream<NotificationModel> call(NoParams params) {
    return repository.getNotifications(params);
  }
}
