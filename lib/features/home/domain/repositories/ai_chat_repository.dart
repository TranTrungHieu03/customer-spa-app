import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_ai_chat.dart';

abstract class AiChatRepository {
  Future<Either<Failure, String>> getAiChat(GetAiChatParams params);
}
