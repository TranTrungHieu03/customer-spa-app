import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_branch_detail.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final GetBranchDetail _getBranchDetail;

  BranchBloc({required GetBranchDetail getBranchDetail})
      : _getBranchDetail = getBranchDetail,
        super(BranchInitial()) {
    on<GetBranchDetailEvent>((event, emit) async {
      emit(BranchLoading());
      final result = await _getBranchDetail(event.params);
      result.fold((failure) => emit(BranchError(failure)), (data) => emit(BranchLoaded(data)));
    });
    on<RefreshBranchEvent>((event, emit) async {
      emit(BranchInitial());
    });
  }
}
