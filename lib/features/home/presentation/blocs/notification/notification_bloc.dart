import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/home/domain/usecases/mark_as_read.dart';
import 'package:spa_mobile/features/home/domain/usecases/mark_as_read_all.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final MarkAsRead _markAsRead;
  final MarkAsReadAll _markAsReadAll;

  NotificationBloc({required MarkAsRead markAsRead, required MarkAsReadAll markAsReadAll})
      : _markAsRead = markAsRead,
        _markAsReadAll = markAsReadAll,
        super(NotificationInitial()) {
    on<MarkAsReadEvent>((event, emit) async {
      emit(NotificationLoading());
      final result = await _markAsRead(event.params);
      result.fold((message) => emit(NotificationError(message.message)), (data) => emit(NotificationCreated(data)));
    });
    on<MarkAsReadAllEvent>((event, emit) async {
      emit(NotificationLoading());
      final result = await _markAsReadAll(event.params);
      result.fold((message) => emit(NotificationError(message.message)), (data) => emit(NotificationUpdatedAll(data)));
    });
  }
}
