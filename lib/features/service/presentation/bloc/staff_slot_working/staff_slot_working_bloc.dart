import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/service/data/model/shift_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_slot_working.dart';

part 'staff_slot_working_event.dart';
part 'staff_slot_working_state.dart';

class StaffSlotWorkingBloc extends Bloc<StaffSlotWorkingEvent, StaffSlotWorkingState> {
  final GetSlotWorking _getListSlotWorking;

  StaffSlotWorkingBloc({
    required GetSlotWorking getListSlotWorking,
  })  : _getListSlotWorking = getListSlotWorking,
        super(StaffSlotWorkingInitial()) {
    on<GetStaffSlotWorkingEvent>((event, emit) async {
      emit(StaffSlotWorkingLoading());
      final result = await _getListSlotWorking(event.params);
      result.fold(
        (failure) => emit(StaffSlotWorkingError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(StaffSlotWorkingLoaded([]));
            return;
          }
          List<ShiftModel> handleRs = [];

          Set<ShiftModel> intersectionStaff = data.first.workSchedules.map((e) => e.shift).toSet();
          for (var staff in data) {
            intersectionStaff = intersectionStaff.intersection(staff.workSchedules.map((e) => e.shift).toSet());
          }
          handleRs = intersectionStaff.toList();

          AppLogger.info(handleRs);
          emit(StaffSlotWorkingLoaded(handleRs));
        },
      );
    });
  }
}
