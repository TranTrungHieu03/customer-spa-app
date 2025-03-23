import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/chat_repository.dart';

class SendMessage implements UseCase<Either, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either> call(SendMessageParams params) async {
    return await repository.sendMessage(params.message);
  }
}

class SendMessageParams {
  final String message;

  SendMessageParams(this.message);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
    };
  }
}
