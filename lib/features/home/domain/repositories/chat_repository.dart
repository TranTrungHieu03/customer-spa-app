import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/models/chat_message.dart';

abstract class ChatRepository {
  Future<Either<Failure, Stream<ChatMessageModel>>> getMessages(NoParams params);

  Future<Either<Failure, void>> sendMessage(String message);

  Future<Either<Failure, void>> connect();

  Future<Either<Failure, void>> disconnect();
}
