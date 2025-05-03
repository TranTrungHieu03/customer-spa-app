import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_all_notification.dart';

part 'home_state_event.dart';
part 'home_state_state.dart';

class HomeStateBloc extends Bloc<HomeStateEvent, HomeStateState> {
  final GetAllNotification _getAllNotification;

  HomeStateBloc({required GetAllNotification getAllNotification})
      : _getAllNotification = getAllNotification,
        super(HomeStateInitial()) {
    on<GetNotificationEvent>((event, emit) async {
      final result = await _getAllNotification(event.params);
      result.fold((message) => emit(HomeStateError(message.message)), (data) => emit(HomeStateLoaded(newNoti: data.pagination.totalCount)));
    });
    on<ResetDataEvent>((event, emit) {
      emit(HomeStateLoading());
    });
  }
}
