import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/home/data/models/channel_model.dart';
import 'package:spa_mobile/features/home/data/models/message_channel_model.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_channel.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_list_channel.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_list_message.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_user_chat_info.dart';

abstract class HubRepository {
  Future<Either<Failure, UserChatModel>> getUserChatInfo(GetUserChatInfoParams params);

  Future<Either<Failure, List<ChannelModel>>> getChannelList(GetListChannelParams params);

  Future<Either<Failure, ChannelModel>> getChannel(GetChannelParams params);

  Future<Either<Failure, List<MessageChannelModel>>> getListMessages(GetListMessageParams params);
}
