import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/features/home/data/datasources/hub_remote_data_source.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/domain/repositories/hub_repository.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_user_chat_info.dart';

class HubRepositoryImpl implements HubRepository {
  final HubRemoteDataSource _dataSource;

  HubRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserChatModel>> getUserChatInfo(GetUserChatInfoParams params) async {
    try {
      final UserChatModel response = await _dataSource.getUserChatInfo(params);
      await LocalStorage.saveData(LocalStorageKey.userChat, jsonEncode(response));
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
