import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_user_chat_info.dart';

abstract class HubRepository {
  Future<Either<Failure, UserChatModel>> getUserChatInfo(GetUserChatInfoParams params);
}