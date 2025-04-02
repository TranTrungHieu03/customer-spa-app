import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/hub_repository.dart';

class GetUserChatInfoParams {
  final int userId;

  GetUserChatInfoParams(this.userId);
}

class GetUserChatInfo implements UseCase<Either, GetUserChatInfoParams> {
  final HubRepository _repository;

  GetUserChatInfo(this._repository);

  @override
  Future<Either> call(GetUserChatInfoParams params) async {
    return await _repository.getUserChatInfo(params);
  }
}
