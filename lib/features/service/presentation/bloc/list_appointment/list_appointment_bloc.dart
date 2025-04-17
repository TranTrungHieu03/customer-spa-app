import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_list_appointment_by_routine.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_appointment.dart';

part 'list_appointment_event.dart';
part 'list_appointment_state.dart';

class ListAppointmentBloc extends Bloc<ListAppointmentEvent, ListAppointmentState> {
  final GetListAppointment _getListAppointment;
  final GetAppointmentsByRoutine _getAppointmentsByRoutine;

  ListAppointmentBloc({required GetListAppointment getListAppointment, required GetAppointmentsByRoutine getAppointmentsByRoutine})
      : _getListAppointment = getListAppointment,
        _getAppointmentsByRoutine = getAppointmentsByRoutine,
        super(ListAppointmentInitial()) {
    on<GetListAppointmentEvent>((event, emit) async {
      emit(ListAppointmentLoading());
      final result = await _getListAppointment(event.params);
      result.fold((message) => emit(ListAppointmentError(message.toString())), (data) {
        if (data.isEmpty) {
          emit(ListAppointmentLoaded(appointments: []));
          return;
        }
        final sortedAppointments = (data as List<AppointmentModel>)..sort((a, b) => a.appointmentsTime.compareTo(b.appointmentsTime));
        emit(ListAppointmentLoaded(appointments: sortedAppointments));
      });
    });
    on<GetListAppointmentByRoutineEvent>((event, emit) async {
      emit(ListAppointmentLoading());
      final result = await _getAppointmentsByRoutine(event.params);
      result.fold((message) => emit(ListAppointmentError(message.toString())), (data) {
        if (data.isEmpty) {
          emit(ListAppointmentLoaded(appointments: []));
          return;
        }
        emit(ListAppointmentLoaded(appointments: data));
      });
    });
  }
}
