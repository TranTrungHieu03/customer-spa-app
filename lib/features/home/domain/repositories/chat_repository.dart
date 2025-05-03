import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/models/message_channel_model.dart';
import 'package:spa_mobile/features/home/data/models/notification_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/send_message.dart';

abstract class ChatRepository {
  // void addMessageListener(Function(MessageChannelModel) onMessageReceived);
  //
  // void removeMessageListener(Function(MessageChannelModel) onMessageReceived);

  Stream<MessageChannelModel> getMessages(NoParams params);

  Stream<NotificationModel> getNotifications(NoParams params);

  Future<Either<Failure, void>> sendMessage(SendMessageParams message);

  Future<Either<Failure, void>> connect();

  Future<Either<Failure, void>> disconnect();
}
