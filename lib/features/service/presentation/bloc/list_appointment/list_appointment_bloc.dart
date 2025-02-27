import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_appointment.dart';

part 'list_appointment_event.dart';
part 'list_appointment_state.dart';

class ListAppointmentBloc extends Bloc<ListAppointmentEvent, ListAppointmentState> {
  final GetListAppointment _getListAppointment;

  ListAppointmentBloc({
    required GetListAppointment getListAppointment,
  })  : _getListAppointment = getListAppointment,
        super(ListAppointmentInitial()) {
    on<GetListAppointmentEvent>(_onGetListAppointment);
  }

  Future<void> _onGetListAppointment(GetListAppointmentEvent event, Emitter<ListAppointmentState> emit) async {
    final currentState = state;
    if (currentState is ListAppointmentLoaded && currentState.isLoadingMorePending) {
      return;
    }
    if (currentState is ListAppointmentLoaded) {
      emit(currentState.copyWith(
          isLoadingMorePending: event.title == "pending" ? true : currentState.isLoadingMorePending,
          isLoadingMoreCompleted: event.title == "completed" ? true : currentState.isLoadingMoreCompleted,
          isLoadingMoreCancelled: event.title == "cancelled" ? true : currentState.isLoadingMoreCancelled));
      final result = await _getListAppointment(GetListAppointmentParams(page: event.page, status: event.title));
      result.fold(
          (failure) => emit(ListAppointmentError(failure.message)),
          (result) => emit(ListAppointmentLoaded(
              pending: currentState.pending + (event.title == "pending" ? result.data : []),
              completed: currentState.completed + (event.title == "completed" ? result.data : []),
              cancelled: currentState.cancelled + (event.title == "cancelled" ? result.data : []),
              isLoadingMorePending: event.title == "pending" ? false : currentState.isLoadingMorePending,
              isLoadingMoreCompleted: event.title == "completed" ? false : currentState.isLoadingMoreCompleted,
              isLoadingMoreCancelled: event.title == "cancelled" ? false : currentState.isLoadingMoreCancelled,
              paginationPending: event.title == "pending" ? result.pagination : currentState.paginationPending,
              paginationCompleted: event.title == "completed" ? result.pagination : currentState.paginationCompleted,
              paginationCancelled: event.title == "cancelled" ? result.pagination : currentState.paginationCancelled)));
    } else {
      emit(ListAppointmentLoading(
          pending: [],
          completed: [],
          cancelled: [],
          isLoadingMorePending: false,
          isLoadingMoreCompleted: false,
          isLoadingMoreCancelled: false,
          paginationPending: PaginationModel.isEmty(),
          paginationCompleted: PaginationModel.isEmty(),
          paginationCancelled: PaginationModel.isEmty()));

      final result = await _getListAppointment(GetListAppointmentParams(page: event.page, status: event.title));
      result.fold(
          (failure) => emit(ListAppointmentError(failure.message)),
          (result) => emit(ListAppointmentLoaded(
              pending: event.title == "pending" ? result.data : [],
              completed: event.title == "completed" ? result.data : [],
              cancelled: event.title == "cancelled" ? result.data : [],
              isLoadingMorePending: false,
              isLoadingMoreCompleted: false,
              isLoadingMoreCancelled: false,
              paginationPending: event.title == "pending" ? result.pagination : PaginationModel.isEmty(),
              paginationCompleted: event.title == "completed" ? result.pagination : PaginationModel.isEmty(),
              paginationCancelled: event.title == "cancelled" ? result.pagination : PaginationModel.isEmty())));
    }
  }
}
