import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/models/message_channel_model.dart';
import 'package:spa_mobile/features/home/domain/repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Stream<MessageChannelModel> call(NoParams params) {
    return repository.getMessages(params);
  }
}
