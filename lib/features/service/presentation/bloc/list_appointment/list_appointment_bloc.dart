import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_appointment.dart';

part 'list_appointment_event.dart';
part 'list_appointment_state.dart';

class ListAppointmentBloc extends Bloc<ListAppointmentEvent, ListAppointmentState> {
  GetListAppointment _getListAppointment;

  ListAppointmentBloc({
    required GetListAppointment getListAppointment,
  })  : _getListAppointment = getListAppointment,
        super(ListAppointmentInitial()) {
    on<ListAppointmentEvent>(_onGetListAppointment);
  }
  Future<void> _onGetListAppointment(ListAppointmentEvent event, Emitter<ListAppointmentState> emit) async {
    if (event is GetListAppointmentDoneEvent) {
      emit(ListAppointmentLoading());
      final result = await _getListAppointment(GetListAppointmentParams(page: event.page, status: event.title));
      // result.fold(
      //   (failure) => emit(ListAppointmentError(failure.message)),
      //   // (data) => emit( ListAppointmentDoneLoaded(appointments: , pagination: )),
      // );
    }
  }
}
