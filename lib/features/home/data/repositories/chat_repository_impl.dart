import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/datasources/chat_remote_data_source.dart';
import 'package:spa_mobile/features/home/data/models/chat_message.dart';
import 'package:spa_mobile/features/home/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> connect() async {
    try {
      await _remoteDataSource.connect();
      return right(null);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await _remoteDataSource.disconnect();
      return right(null);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Stream<ChatMessageModel>>> getMessages(NoParams params) async {
    try {
      final Stream<ChatMessageModel> response = _remoteDataSource.getMessages();
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(String message) async {
    try {
      await _remoteDataSource.sendMessage(message);
      return right(null);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
