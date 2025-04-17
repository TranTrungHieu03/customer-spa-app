part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentEvent {}

final class GetAppointmentEvent extends AppointmentEvent {
  final int id;

  GetAppointmentEvent(this.id);
}
  final class GetAppointmentDetailEvent extends AppointmentEvent {
  final GetAppointmentDetailParams params;

  GetAppointmentDetailEvent(this.params);
  }

final class CreateAppointmentEvent extends AppointmentEvent {
  final CreateAppointmentParams params;

  CreateAppointmentEvent(this.params);
}

final class UpdateAppointmentEvent extends AppointmentEvent {
  final UpdateAppointmentParams params;

  UpdateAppointmentEvent(this.params);
}

final class ResetAppointmentEvent extends AppointmentEvent {}

final class UpdateCreateAppointmentDataEvent extends AppointmentEvent {
  final CreateAppointmentParams params;

  UpdateCreateAppointmentDataEvent(this.params);
}

final class UpdateCreateServiceIdAndBranchIdEvent extends AppointmentEvent {
  final List<int> serviceId;
  final int branchId;
  final int totalMinutes;

  UpdateCreateServiceIdAndBranchIdEvent({required this.serviceId, required this.branchId, required this.totalMinutes});
}

final class UpdateCreateStaffIdEvent extends AppointmentEvent {
  final List<int> staffId;

  UpdateCreateStaffIdEvent({required this.staffId});
}

final class UpdateCreateTimeEvent extends AppointmentEvent {
  final DateTime appointmentTime;

  UpdateCreateTimeEvent({required this.appointmentTime});
}

final class UpdateNoteEvent extends AppointmentEvent {
  final String note;

  UpdateNoteEvent({required this.note});
}

final class ClearAppointmentEvent extends AppointmentEvent {}

final class CancelAppointmentEvent extends AppointmentEvent {
  final CancelOrderParams params;

  CancelAppointmentEvent(this.params);
}
