import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/home/data/models/notification_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_all_notification.dart';

part 'list_notification_event.dart';
part 'list_notification_state.dart';

class ListNotificationBloc extends Bloc<ListNotificationEvent, ListNotificationState> {
  final GetAllNotification _getAllNotification;

  ListNotificationBloc({required GetAllNotification getAllNotification})
      : _getAllNotification = getAllNotification,
        super(ListNotificationInitial()) {
    on<GetAllNotificationEvent>((event, emit) async {
      final currentState = state;
      if (currentState is ListNotificationLoaded && currentState.isLoadingMore) {
        return;
      }
      if (currentState is ListNotificationLoaded) {
        emit(currentState.copyWith(isLoadingMore: true));
        final result = await _getAllNotification(event.params);
        result.fold(
          (failure) => emit(ListNotificationError(failure.message)),
          (result) => emit(ListNotificationLoaded(
            notifications: currentState.notifications + result.notifications,
            pagination: result.pagination,
            isLoadingMore: false,
          )),
        );
      } else {
        emit(ListNotificationLoading());
        final result = await _getAllNotification(event.params);
        result.fold(
            (message) => emit(ListNotificationError(message.message)),
            (data) => emit(ListNotificationLoaded(
                notifications: data.notifications.toSet().toList(), pagination: data.pagination, isLoadingMore: false)));
      }
    });
    // on<AddNewNotificationEvent>((event, emit) async {
    //   AppLogger.wtf(event);
    //   final currentState = state;
    //   if (currentState is ListNotificationLoaded && currentState.isLoadingMore) {
    //     return;
    //   }
    //   if (currentState is ListNotificationLoaded) {
    //     emit(ListNotificationLoaded(
    //       notifications: {...currentState.notifications, ...event.notifications}.toSet().toList(),
    //       pagination: currentState.pagination,
    //       isLoadingMore: false,
    //     ));
    //   }
    // });
    on<ResetNotificationEvent>((event, emit) {
      emit(ListNotificationLoading());
    });
  }
}
