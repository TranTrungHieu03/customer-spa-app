import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/ai_chat_repository.dart';

class GetAiChat implements UseCase<Either, GetAiChatParams> {
  final AiChatRepository _aiChatRepository;

  GetAiChat(this._aiChatRepository);

  @override
  Future<Either<Failure, String>> call(GetAiChatParams params) async {
    return await _aiChatRepository.getAiChat(params);
  }
}

class GetAiChatParams {
  final String message;

  GetAiChatParams(this.message);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
    };
  }
}
