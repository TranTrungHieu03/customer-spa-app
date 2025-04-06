import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/hub_repository.dart';

class GetChannelParams {
  final String id;

  GetChannelParams(this.id);
}

class GetChannel implements UseCase<Either, GetChannelParams> {
  final HubRepository _repository;

  GetChannel(this._repository);

  @override
  Future<Either> call(GetChannelParams params) async {
    return await _repository.getChannel(params);
  }
}
