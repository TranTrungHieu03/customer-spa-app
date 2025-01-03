import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/home/data/datasources/ai_chat_remote_data_source.dart';
import 'package:spa_mobile/features/home/domain/repositories/ai_chat_repository.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_ai_chat.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatRemoteDataSource _remoteDataSource;

  AiChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> getAiChat(GetAiChatParams params) async {
    try {
      final String response = await _remoteDataSource.getAiChat(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
