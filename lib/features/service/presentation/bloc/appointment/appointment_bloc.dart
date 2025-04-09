import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/product/domain/usecases/cancel_order.dart';
import 'package:spa_mobile/features/service/data/model/order_appointment_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAppointment _getAppointment;
  final CreateAppointment _createAppointment;
  final CancelOrder _cancelOrder;

  AppointmentBloc({required GetAppointment getAppointment, required CreateAppointment createAppointment, required CancelOrder cancelOrder})
      : _getAppointment = getAppointment,
        _createAppointment = createAppointment,
        _cancelOrder = cancelOrder,
        super(AppointmentInitial()) {
    on<GetAppointmentEvent>(_onGetAppointmentEvent);
    on<CreateAppointmentEvent>(_onCreateAppointmentEvent);
    on<ResetAppointmentEvent>(_onResetAppointmentEvent);
    // on<UpdateCreateServiceIdAndBranchIdEvent>(_onUpdateServiceAndBranchDataEvent);
    // on<UpdateCreateStaffIdEvent>(_onUpdateStaffIdDataEvent);
    // on<UpdateCreateTimeEvent>(_onUpdateTimeDataEvent);
    // on<UpdateNoteEvent>(_onUpdateNoteDataEvent);
    on<ClearAppointmentEvent>(_onClearAppointmentEvent);
    on<CancelAppointmentEvent>(_onCancelAppointment);
  }

  Future<void> _onGetAppointmentEvent(GetAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    final result = await _getAppointment(GetAppointmentParams(id: event.id));
    result.fold(
      (failure) => emit(AppointmentError(failure.message)),
      (appointment) => emit(AppointmentLoaded(appointment)),
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

  // Future<void> _onUpdateServiceAndBranchDataEvent(UpdateCreateServiceIdAndBranchIdEvent event, Emitter<AppointmentState> emit) async {
  //   final currentState = state;
  //   if (currentState is AppointmentCreateData) {
  //     emit(AppointmentCreateData(CreateAppointmentParams(
  //         staffId: currentState.params.staffId,
  //         serviceId: event.serviceId,
  //         branchId: event.branchId,
  //         appointmentsTime: currentState.params.appointmentsTime,
  //         totalMinutes: currentState.params.totalMinutes,
  //         // Giữ nguyên giá trị totalMinutes
  //         notes: currentState.params.notes)));
  //     AppLogger.debug(CreateAppointmentParams(
  //             staffId: currentState.params.staffId,
  //             serviceId: event.serviceId,
  //             branchId: event.branchId,
  //             appointmentsTime: currentState.params.appointmentsTime,
  //             totalMinutes: currentState.params.totalMinutes,
  //             notes: currentState.params.notes)
  //         .toJson());
  //   } else {
  //     emit(AppointmentCreateData(CreateAppointmentParams(
  //         staffId: [],
  //         serviceId: event.serviceId,
  //         branchId: event.branchId,
  //         appointmentsTime: DateTime.now(),
  //         totalMinutes: event.totalMinutes,
  //         // Giá trị mặc định cho totalMinutes
  //         notes: "")));
  //     AppLogger.debug(CreateAppointmentParams(
  //             staffId: [],
  //             serviceId: event.serviceId,
  //             branchId: event.branchId,
  //             appointmentsTime: DateTime.now(),
  //             totalMinutes: event.totalMinutes,
  //             notes: "")
  //         .toJson());
  //   }
  // }
  //
  // Future<void> _onUpdateStaffIdDataEvent(UpdateCreateStaffIdEvent event, Emitter<AppointmentState> emit) async {
  //   final currentState = state;
  //   if (currentState is AppointmentCreateData) {
  //     AppLogger.debug(event.staffId);
  //     emit(AppointmentCreateData(CreateAppointmentParams(
  //         staffId: event.staffId,
  //         serviceId: currentState.params.serviceId,
  //         branchId: currentState.params.branchId,
  //         appointmentsTime: currentState.params.appointmentsTime,
  //         totalMinutes: currentState.params.totalMinutes,
  //         // Giữ nguyên giá trị totalMinutes
  //         notes: currentState.params.notes)));
  //
  //     AppLogger.debug(CreateAppointmentParams(
  //             staffId: event.staffId,
  //             serviceId: currentState.params.serviceId,
  //             branchId: currentState.params.branchId,
  //             appointmentsTime: currentState.params.appointmentsTime,
  //             totalMinutes: currentState.params.totalMinutes,
  //             notes: currentState.params.notes)
  //         .toJson());
  //   } else {
  //     emit(AppointmentError("Du lieu chua duoc dong nhat"));
  //   }
  // }
  //
  // Future<void> _onUpdateTimeDataEvent(UpdateCreateTimeEvent event, Emitter<AppointmentState> emit) async {
  //   final currentState = state;
  //   if (currentState is AppointmentCreateData) {
  //     emit(AppointmentCreateData(CreateAppointmentParams(
  //         staffId: currentState.params.staffId,
  //         serviceId: currentState.params.serviceId,
  //         branchId: currentState.params.branchId,
  //         appointmentsTime: event.appointmentTime,
  //         totalMinutes: currentState.params.totalMinutes,
  //         // Giữ nguyên giá trị totalMinutes
  //         notes: currentState.params.notes)));
  //   } else {
  //     emit(AppointmentError("Du lieu chua duoc dong nhat"));
  //   }
  // }
  //
  // Future<void> _onUpdateNoteDataEvent(UpdateNoteEvent event, Emitter<AppointmentState> emit) async {
  //   final currentState = state;
  //   if (currentState is AppointmentCreateData) {
  //     emit(AppointmentCreateData(CreateAppointmentParams(
  //         staffId: currentState.params.staffId,
  //         serviceId: currentState.params.serviceId,
  //         branchId: currentState.params.branchId,
  //         appointmentsTime: currentState.params.appointmentsTime,
  //         totalMinutes: currentState.params.totalMinutes,
  //         // Giữ nguyên giá trị totalMinutes
  //         notes: event.note)));
  //     AppLogger.debug(CreateAppointmentParams(
  //             staffId: currentState.params.staffId,
  //             serviceId: currentState.params.serviceId,
  //             branchId: currentState.params.branchId,
  //             appointmentsTime: currentState.params.appointmentsTime,
  //             totalMinutes: currentState.params.totalMinutes,
  //             notes: event.note)
  //         .toJson());
  //   } else {
  //     emit(AppointmentError("Du lieu chua duoc dong nhat"));
  //   }
  // }

  Future<void> _onClearAppointmentEvent(ClearAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentInitial());
  }
}
