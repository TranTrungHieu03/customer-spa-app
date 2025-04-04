import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/hub_repository.dart';

class GetListMessageParams {
  final String id;

  GetListMessageParams(this.id);
}

class GetListMessage implements UseCase<Either, GetListMessageParams> {
  final HubRepository _repository;

  GetListMessage(this._repository);

  @override
  Future<Either> call(GetListMessageParams params) async {
    return await _repository.getListMessages(params);
  }
}
