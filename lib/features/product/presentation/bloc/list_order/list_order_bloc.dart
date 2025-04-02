import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/product/data/model/order_product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_history_product.dart';

part 'list_order_event.dart';
part 'list_order_state.dart';

class ListOrderBloc extends Bloc<ListOrderEvent, ListOrderState> {
  final GetHistoryProduct _getHistoryProduct;

  ListOrderBloc({required GetHistoryProduct getHistoryProduct})
      : _getHistoryProduct = getHistoryProduct,
        super(ListOrderInitial()) {
    on<GetListOrderEvent>((event, emit) async {
      final currentState = state;
      if (currentState is ListOrderLoaded && currentState.isLoadingMorePending) {
        return;
      }
      if (currentState is ListOrderLoaded) {
        emit(currentState.copyWith(
            isLoadingMorePending: event.title == "pending" ? true : currentState.isLoadingMorePending,
            isLoadingMoreShipping: event.title == "shipping" ? true : currentState.isLoadingMoreShipping,
            isLoadingMoreCompleted: event.title == "completed" ? true : currentState.isLoadingMoreCompleted,
            isLoadingMoreCancelled: event.title == "cancelled" ? true : currentState.isLoadingMoreCancelled));
        final result = await _getHistoryProduct(GetHistoryProductParams(page: event.page, status: event.title));
        result.fold(
            (failure) => emit(ListOrderError(failure.message)),
            (result) => emit(ListOrderLoaded(
                pending: currentState.pending + (event.title == "pending" ? result.data : []),
                completed: currentState.completed + (event.title == "completed" ? result.data : []),
                cancelled: currentState.cancelled + (event.title == "cancelled" ? result.data : []),
                shipping: currentState.cancelled + (event.title == "shipping" ? result.data : []),
                isLoadingMorePending: event.title == "pending" ? false : currentState.isLoadingMorePending,
                isLoadingMoreShipping: event.title == "shipping" ? false : currentState.isLoadingMoreShipping,
                isLoadingMoreCompleted: event.title == "completed" ? false : currentState.isLoadingMoreCompleted,
                isLoadingMoreCancelled: event.title == "cancelled" ? false : currentState.isLoadingMoreCancelled,
                paginationPending: event.title == "pending" ? result.pagination : currentState.paginationPending,
                paginationCompleted: event.title == "completed" ? result.pagination : currentState.paginationCompleted,
                paginationShipping: event.title == "shipping" ? result.pagination : currentState.paginationShipping,
                paginationCancelled: event.title == "cancelled" ? result.pagination : currentState.paginationCancelled)));
      } else {
        emit(ListOrderLoading(
            pending: [],
            completed: [],
            cancelled: [],
            shipping: [],
            isLoadingMorePending: false,
            isLoadingMoreCompleted: false,
            isLoadingMoreShipping: false,
            isLoadingMoreCancelled: false,
            paginationPending: PaginationModel.isEmty(),
            paginationShipping: PaginationModel.isEmty(),
            paginationCompleted: PaginationModel.isEmty(),
            paginationCancelled: PaginationModel.isEmty()));

        final result = await _getHistoryProduct(GetHistoryProductParams(page: event.page, status: event.title));
        result.fold(
            (failure) => emit(ListOrderError(failure.message)),
            (result) => emit(ListOrderLoaded(
                pending: event.title == "pending" ? result.data : [],
                completed: event.title == "completed" ? result.data : [],
                cancelled: event.title == "cancelled" ? result.data : [],
                shipping: event.title == "shipping" ? result.data : [],
                isLoadingMorePending: false,
                isLoadingMoreCompleted: false,
                isLoadingMoreCancelled: false,
                isLoadingMoreShipping: false,
                paginationPending: event.title == "pending" ? result.pagination : PaginationModel.isEmty(),
                paginationShipping: event.title == "shipping" ? result.pagination : PaginationModel.isEmty(),
                paginationCompleted: event.title == "completed" ? result.pagination : PaginationModel.isEmty(),
                paginationCancelled: event.title == "cancelled" ? result.pagination : PaginationModel.isEmty())));
      }
    });
  }
}
