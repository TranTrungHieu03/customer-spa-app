import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_staff.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_single_staff.dart';

part 'list_staff_event.dart';
part 'list_staff_state.dart';

class ListStaffBloc extends Bloc<ListStaffEvent, ListStaffState> {
  final GetListStaff _getListStaff;
  final GetSingleStaff _getSingleStaff;

  ListStaffBloc({required GetListStaff getListStaff, required GetSingleStaff getSingleStaff})
      : _getListStaff = getListStaff,
        _getSingleStaff = getSingleStaff,
        super(ListStaffInitial()) {
    on<GetListStaffEvent>(_onGetListStaffEvent);
    on<GetSingleStaffEvent>(_onGetSingleStaffEvent);
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

  Future<void> _onGetSingleStaffEvent(GetSingleStaffEvent event, Emitter<ListStaffState> emit) async {
    emit(ListStaffLoading());
    final result = await _getSingleStaff(GetSingleStaffParams(staffId: event.staffId));
    AppLogger.debug(result);
    result.fold(
      (failure) => emit(ListStaffError(message: failure.message)),
      (result) {
        emit(ListStaffLoaded(listStaff: [result]));
      },
    );
  }
}
