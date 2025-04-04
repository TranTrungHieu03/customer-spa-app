import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/chat_repository.dart';

class GetMessages implements UseCase<Either, NoParams> {
  final ChatRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either> call(NoParams params) async {
    return await repository.getMessages(params);
  }
}

