import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/chat_repository.dart';

class ConnectHub implements UseCase<Either, NoParams> {
  final ChatRepository repository;

  ConnectHub(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.connect();
  }
}
