import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_branches.dart';

part 'list_branches_event.dart';
part 'list_branches_state.dart';

class ListBranchesBloc extends Bloc<ListBranchesEvent, ListBranchesState> {
  final GetListBranches _getListBranches;

  ListBranchesBloc({
    required GetListBranches getListBranches,
  })  : _getListBranches = getListBranches,
        super(ListBranchesInitial()) {
    on<GetListBranchesEvent>(_onGetListBranches);
  }

  Future<void> _onGetListBranches(GetListBranchesEvent event, Emitter<ListBranchesState> emit) async {
    final currentState = state;
    if (currentState is ListBranchesLoaded) {
      return;
    } else {
      emit(ListBranchesLoading());
      final result = await _getListBranches(NoParams());
      result.fold((failure) => emit(ListBranchesError(failure.message)), (result) {
        if (result.isEmpty) {
          emit(ListBranchesEmpty());
        } else {
          emit(ListBranchesLoaded(result));
        }
      });
    }
  }
}
