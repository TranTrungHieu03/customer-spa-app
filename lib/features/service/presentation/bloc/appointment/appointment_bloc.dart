import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/update_appointment_routine.dart';
import 'package:spa_mobile/features/product/domain/usecases/cancel_order.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/data/model/order_appointment_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/cancel_appointment_detail.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment_detail.dart';
import 'package:spa_mobile/features/service/domain/usecases/update_appointment.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAppointment _getAppointment;
  final CreateAppointment _createAppointment;
  final CancelOrder _cancelOrder;
  final GetAppointmentDetail _getAppointmentDetail;
  final UpdateAppointment _updateAppointment;
  final CancelAppointmentDetail _cancelAppointmentDetail;
  final UpdateAppointmentRoutine _updateAppointmentRoutine;

  AppointmentBloc(
      {required GetAppointment getAppointment,
      required GetAppointmentDetail getAppointmentDetail,
      required CreateAppointment createAppointment,
      required CancelOrder cancelOrder,
      required UpdateAppointment updateAppointment,
      required CancelAppointmentDetail cancelAppointmentDetail,
      required UpdateAppointmentRoutine updateAppointmentRoutine})
      : _getAppointment = getAppointment,
        _createAppointment = createAppointment,
        _cancelOrder = cancelOrder,
        _getAppointmentDetail = getAppointmentDetail,
        _updateAppointment = updateAppointment,
        _cancelAppointmentDetail = cancelAppointmentDetail,
        _updateAppointmentRoutine = updateAppointmentRoutine,
        super(AppointmentInitial()) {
    on<GetAppointmentEvent>(_onGetAppointmentEvent);
    on<GetAppointmentDetailEvent>(_onGetAppointmentDetailEvent);
    on<CreateAppointmentEvent>(_onCreateAppointmentEvent);
    on<ResetAppointmentEvent>(_onResetAppointmentEvent);
    // on<UpdateCreateServiceIdAndBranchIdEvent>(_onUpdateServiceAndBranchDataEvent);
    // on<UpdateCreateStaffIdEvent>(_onUpdateStaffIdDataEvent);
    // on<UpdateCreateTimeEvent>(_onUpdateTimeDataEvent);
    // on<UpdateNoteEvent>(_onUpdateNoteDataEvent);
    on<ClearAppointmentEvent>(_onClearAppointmentEvent);
    on<CancelAppointmentEvent>(_onCancelAppointment);
    on<UpdateAppointmentEvent>(_onUpdateAppointmentEvent);
    on<CancelAppointmentDetailEvent>(_onCancelAppointmentDetailEvent);
    on<UpdateAppointmentRoutineEvent>(_onUpdateAppointmentRoutineEvent);
  }

  Future<void> _onGetAppointmentEvent(GetAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    final result = await _getAppointment(GetAppointmentParams(id: event.id));
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (appointment) => emit(AppointmentLoaded(appointment)),
    );
  }

  Future<void> _onGetAppointmentDetailEvent(GetAppointmentDetailEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    final result = await _getAppointmentDetail(GetAppointmentDetailParams(appointmentId: event.params.appointmentId));
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (appointment) => emit(AppointmentDetailLoaded(appointment)),
    );
  }

  Future<void> _onCancelAppointment(CancelAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    final result = await _cancelOrder(event.params);
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (message) => emit(CancelAppointmentSuccess(orderId: event.params.orderId, error: message)),
    );
  }

  Future<void> _onCancelAppointmentDetailEvent(CancelAppointmentDetailEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    final result = await _cancelAppointmentDetail(event.params);
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (message) => emit(CancelAppointmentDetailSuccess(message)),
    );
  }

  Future<void> _onCreateAppointmentEvent(CreateAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    AppLogger.debug(event.params);
    final result = await _createAppointment(event.params);
    result.fold(
      (failure) {
        emit(AppointmentError(failure.message));
        emit(AppointmentCreateData(event.params));
      },
      (appointment) => emit(AppointmentCreateSuccess(appointment)),
    );
  }

  Future<void> _onResetAppointmentEvent(ResetAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentInitial());
  }

  Future<void> _onUpdateAppointmentEvent(UpdateAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    final result = await _updateAppointment(event.params);
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (appointment) => emit(AppointmentCreateSuccess(appointment)),
    );
  }

  Future<void> _onUpdateAppointmentRoutineEvent(UpdateAppointmentRoutineEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    final result = await _updateAppointmentRoutine(event.params);
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (appointment) => emit(
          AppointmentUpdateRoutineSuccess(userId: event.params.userId, orderId: event.params.orderId, routineId: event.params.routineId)),
    );
  }

  Future<void> _onClearAppointmentEvent(ClearAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentInitial());
  }
}
