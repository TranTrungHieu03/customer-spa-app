import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/order_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_history_order_routine.dart';

part 'list_order_routine_event.dart';
part 'list_order_routine_state.dart';

class ListOrderRoutineBloc extends Bloc<ListOrderRoutineEvent, ListOrderRoutineState> {
  final GetHistoryOrderRoutine _getHistoryOrderRoutine;

  ListOrderRoutineBloc({required GetHistoryOrderRoutine getHistoryOrderRoutine})
      : _getHistoryOrderRoutine = getHistoryOrderRoutine,
        super(ListOrderRoutineInitial()) {
    on<GetHistoryOrderRoutineEvent>(_onGetListOrderRoutine);
  }

  Future<void> _onGetListOrderRoutine(GetHistoryOrderRoutineEvent event, Emitter<ListOrderRoutineState> emit) async {
    final currentState = state;
    if (currentState is ListOrderRoutineLoaded && currentState.isLoadingMorePending) {
      return;
    }
    if (currentState is ListOrderRoutineLoaded) {
      emit(currentState.copyWith(
          isLoadingMorePending: event.params.status == "pending" ? true : currentState.isLoadingMorePending,
          isLoadingMoreCompleted: event.params.status == "completed" ? true : currentState.isLoadingMoreCompleted,
          // // isLpaginationArrived: event.params.status == "arrived" ? true : currentState.isLpaginationArrived,
          isLoadingMoreCancelled: event.params.status == "cancelled" ? true : currentState.isLoadingMoreCancelled));
      final result = await _getHistoryOrderRoutine(GetHistoryOrderRoutineParams(page: event.params.page, status: event.params.status));
      result.fold(
          (failure) => emit(ListOrderRoutineError(failure.message)),
          (result) => emit(ListOrderRoutineLoaded(
              pending: currentState.pending + (event.params.status == "pending" ? result.data : []),
              completed: currentState.completed + (event.params.status == "completed" ? result.data : []),
              cancelled: currentState.cancelled + (event.params.status == "cancelled" ? result.data : []),
              // arrived: currentState.arrived + (event.params.status == "arrived" ? result.data : []),
              isLoadingMorePending: event.params.status == "pending" ? false : currentState.isLoadingMorePending,
              isLoadingMoreCompleted: event.params.status == "completed" ? false : currentState.isLoadingMoreCompleted,
              isLoadingMoreCancelled: event.params.status == "cancelled" ? false : currentState.isLoadingMoreCancelled,
              // // isLpaginationArrived: event.params.status == "arrived" ? false : currentState.isLpaginationArrived,
              paginationPending: event.params.status == "pending" ? result.pagination : currentState.paginationPending,
              paginationCompleted: event.params.status == "completed" ? result.pagination : currentState.paginationCompleted,
              // // paginationArrived: event.params.status == "arrived" ? result.pagination : currentState.paginationArrived,
              paginationCancelled: event.params.status == "cancelled" ? result.pagination : currentState.paginationCancelled)));
    } else {
      emit(ListOrderRoutineLoading(
          pending: [],
          completed: [],
          cancelled: [],
          // arrived: [],
          isLoadingMorePending: false,
          // isLpaginationArrived: false,
          isLoadingMoreCompleted: false,
          isLoadingMoreCancelled: false,
          paginationPending: PaginationModel.isEmty(),
          // paginationArrived: PaginationModel.isEmty(),
          paginationCompleted: PaginationModel.isEmty(),
          paginationCancelled: PaginationModel.isEmty()));

      final result = await _getHistoryOrderRoutine(GetHistoryOrderRoutineParams(page: event.params.page, status: event.params.status));
      result.fold(
          (failure) => emit(ListOrderRoutineError(failure.message)),
          (result) => emit(ListOrderRoutineLoaded(
              pending: event.params.status == "pending" ? result.data : [],
              completed: event.params.status == "completed" ? result.data : [],
              cancelled: event.params.status == "cancelled" ? result.data : [],
              // arrived: event.params.status == "arrived" ? result.data : [],
              isLoadingMorePending: false,
              isLoadingMoreCompleted: false,
              // isLpaginationArrived: false,
              isLoadingMoreCancelled: false,
              paginationPending: event.params.status == "pending" ? result.pagination : PaginationModel.isEmty(),
              // // paginationArrived: event.params.status == "arrived" ? result.pagination : PaginationModel.isEmty(),
              paginationCompleted: event.params.status == "completed" ? result.pagination : PaginationModel.isEmty(),
              paginationCancelled: event.params.status == "cancelled" ? result.pagination : PaginationModel.isEmty())));
    }
  }
}
