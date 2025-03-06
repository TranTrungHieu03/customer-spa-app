import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_single_staff.dart';

part 'staff_event.dart';
part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  final GetSingleStaff _getSingleStaff;

  StaffBloc({required GetSingleStaff getSingleStaff})
      : _getSingleStaff = getSingleStaff,
        super(StaffInitial()) {
    on<GetStaffInfoEvent>(_onGetSingleStaff);
  }

  Future<void> _onGetSingleStaff(GetStaffInfoEvent event, Emitter<StaffState> emit) async {
    emit(StaffLoading());
    final result = await _getSingleStaff(GetSingleStaffParams(staffId: event.params.staffId));
    result.fold(
      (failure) => emit(StaffError(failure.message)),
      (result) {
        emit(StaffLoaded(staff: result));
      },
    );
  }
}
