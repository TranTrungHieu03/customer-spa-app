import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/home/data/datasources/hub_remote_data_source.dart';
import 'package:spa_mobile/features/home/data/models/channel_model.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/domain/repositories/hub_repository.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_channel.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_list_channel.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_user_chat_info.dart';

class HubRepositoryImpl implements HubRepository {
  final HubRemoteDataSource _dataSource;

  HubRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserChatModel>> getUserChatInfo(GetUserChatInfoParams params) async {
    try {
      final UserChatModel response = await _dataSource.getUserChatInfo(params);
      AppLogger.info(response);
      AppLogger.info(jsonEncode(response));
      await LocalStorage.saveData(LocalStorageKey.userChat, jsonEncode(response));
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChannelModel>>> getChannelList(GetListChannelParams params) async {
    try {
      final List<ChannelModel> response = await _dataSource.getListChannel(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChannelModel>> getChannel(GetChannelParams params) async {
    try {
      final ChannelModel response = await _dataSource.getChannel(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
