import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/datasources/chat_remote_data_source.dart';
import 'package:spa_mobile/features/home/data/models/message_channel_model.dart';
import 'package:spa_mobile/features/home/domain/repositories/chat_repository.dart';
import 'package:spa_mobile/features/home/domain/usecases/send_message.dart';

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
  Stream<MessageChannelModel> getMessages(NoParams params) {
    return _remoteDataSource.getMessages();
  }

  @override
  Future<Either<Failure, void>> sendMessage(SendMessageParams message) async {
    try {
      await _remoteDataSource.sendMessage(message);
      return right(null);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
