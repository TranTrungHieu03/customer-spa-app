import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_staff_free_in_time.dart';

part 'list_staff_event.dart';
part 'list_staff_state.dart';

class ListStaffBloc extends Bloc<ListStaffEvent, ListStaffState> {
  final GetListStaff _getListStaff;
  final GetStaffFreeInTime _getStaffFreeInTime;

  ListStaffBloc({required GetListStaff getListStaff, required GetStaffFreeInTime getStaffFreeInTime})
      : _getListStaff = getListStaff,
        _getStaffFreeInTime = getStaffFreeInTime,
        super(ListStaffInitial()) {
    on<GetListStaffEvent>(_onGetListStaffEvent);
    on<GetStaffFreeInTimeEvent>(_onGetStaffFreeInTimeEvent);
  }

  Future<void> _onGetListStaffEvent(GetListStaffEvent event, Emitter<ListStaffState> emit) async {
    emit(ListStaffLoading());
    final result = await _getListStaff(GetListStaffParams(id: event.id));
    result.fold(
      (failure) => emit(ListStaffError(message: failure.message)),
      (result) {
        if (result.isEmpty) {
          emit(ListStaffEmpty());
        } else {
          emit(ListStaffLoaded(listStaff: result));
        }
      },
    );
  }

  Future<void> _onGetStaffFreeInTimeEvent(GetStaffFreeInTimeEvent event, Emitter<ListStaffState> emit) async {
    emit(ListStaffLoading());
    final result = await _getStaffFreeInTime(
        GetStaffFreeInTimeParams(branchId: event.params.branchId, serviceId: event.params.serviceId, startTime: event.params.startTime));
    AppLogger.debug(result);
    result.fold(
      (failure) => emit(ListStaffError(message: failure.message)),
      (result) {
        emit(ListStaffLoaded(listStaff: result));
      },
    );
  }
}
