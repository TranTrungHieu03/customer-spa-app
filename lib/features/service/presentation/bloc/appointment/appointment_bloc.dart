import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAppointment _getAppointment;
  final CreateAppointment _createAppointment;

  AppointmentBloc({
    required GetAppointment getAppointment,
    required CreateAppointment createAppointment,
  })  : _getAppointment = getAppointment,
        _createAppointment = createAppointment,
        super(AppointmentInitial()) {
    on<GetAppointmentEvent>(_onGetAppointmentEvent);
    on<CreateAppointmentEvent>(_onCreateAppointmentEvent);
    on<ResetAppointmentEvent>(_onResetAppointmentEvent);
  }

  Future<void> _onGetAppointmentEvent(GetAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    final result = await _getAppointment(GetAppointmentParams(id: event.id));
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (appointment) => emit(AppointmentLoaded(appointment)),
    );
  }

  Future<void> _onCreateAppointmentEvent(CreateAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    final result = await _createAppointment(CreateAppointmentParams(
        customerId: event.params.customerId,
        staffId: event.params.staffId,
        serviceId: event.params.serviceId,
        branchId: event.params.branchId,
        appointmentsTime: event.params.appointmentsTime,
        notes: event.params.notes));
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (appointment) => emit(AppointmentCreateSuccess(appointment)),
    );
  }

  Future<void> _onResetAppointmentEvent(ResetAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentInitial());
  }
}
