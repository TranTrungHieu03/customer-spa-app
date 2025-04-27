import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_user_chat_info.dart';

part 'user_chat_event.dart';
part 'user_chat_state.dart';

class UserChatBloc extends Bloc<UserChatEvent, UserChatState> {
  final GetUserChatInfo _getUserChatInfo;

  UserChatBloc({required GetUserChatInfo getUserChatInfo})
      : _getUserChatInfo = getUserChatInfo,
        super(UserChatInitial()) {
    on<GetUserChatInfoEvent>((event, emit) async {
      emit(UserChatLoading());
      final result = await _getUserChatInfo(event.params);
      result.fold((failure) => emit(UserChatError(failure.message)), (data) {
        AppLogger.info(data);
        emit(UserChatLoaded(data));
      });
    });
  }
}
