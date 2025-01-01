import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/auth/domain/repository/auth_repository.dart';

class Logout implements UseCase<Either, NoParams> {
  final AuthRepository _repository;

  Logout(this._repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await _repository.logout();
  }
}
