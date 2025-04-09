import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/service/data/model/staff_time_model.dart';
import 'package:spa_mobile/features/service/data/model/time_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_time_slot_by_date.dart';

part 'list_time_event.dart';
part 'list_time_state.dart';

class ListTimeBloc extends Bloc<ListTimeEvent, ListTimeState> {
  final GetTimeSlotByDate _getTimeSlotByDate;

  ListTimeBloc({required GetTimeSlotByDate getTimeSlotByDate})
      : _getTimeSlotByDate = getTimeSlotByDate,
        super(ListTimeInitial()) {
    on<GetListTimeByDateEvent>(_onGetTimeSlotByDate);
  }

  Future<void> _onGetTimeSlotByDate(GetListTimeByDateEvent event, Emitter<ListTimeState> emit) async {
    emit(ListTimeLoading());

    final result = await _getTimeSlotByDate(
      GetTimeSlotByDateParams(
        staffId: event.params.staffId,
        date: event.params.date,
      ),
    );

    result.fold(
      (failure) => emit(ListTimeError(failure.message)),
      (result) {
        if (result.isEmpty) {
          emit(ListTimeLoaded([]));
        } else {
          List<TimeModel> handleRs = [];

          final allSame = event.params.staffId.every((id) => id == event.params.staffId[0]);

          if (allSame) {
            final firstStaffId = event.params.staffId[0];
            final staff =
                result.firstWhere((e) => e.staffId == firstStaffId, orElse: () => StaffTimeModel(staffId: firstStaffId, busyTimes: []));
            handleRs = staff.busyTimes;
          } else {
            for (var staff in result) {
              handleRs.addAll(staff.busyTimes);
            }
          }

          emit(ListTimeLoaded(handleRs));
        }
      },
    );
  }
}
