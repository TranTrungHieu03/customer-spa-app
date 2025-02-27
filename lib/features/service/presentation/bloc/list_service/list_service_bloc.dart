import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_services.dart';

part 'list_service_event.dart';
part 'list_service_state.dart';

class ListServiceBloc extends Bloc<ListServiceEvent, ListServiceState> {
  final GetListService _getListService;

  ListServiceBloc({
    required GetListService getListService,
  })  : _getListService = getListService,
        super(ListServiceInitial()) {
    on<GetListServicesEvent>(_onGetListServices);
    on<GetListServiceChangeBranchEvent>(_onGetListServiceChangeBranch);
  }

  Future<void> _onGetListServices(GetListServicesEvent event, Emitter<ListServiceState> emit) async {
    final currentState = state;
    if (currentState is ListServiceLoaded && currentState.isLoadingMore) {
      return;
    }
    if (currentState is ListServiceLoaded) {
      emit(currentState.copyWith(isLoadingMore: true));
      final result = await _getListService(GetListServiceParams(event.page, event.branchId));
      result.fold(
        (failure) => emit(ListServiceFailure(failure.message)),
        (result) =>
            emit(ListServiceLoaded(services: currentState.services + result.services, pagination: result.pagination, isLoadingMore: false)),
      );
    } else {
      emit(ListServiceLoading(
        isLoadingMore: false,
        services: [],
        pagination: PaginationModel.isEmty(),
      ));

      final result = await _getListService(GetListServiceParams(event.page, event.branchId));
      result.fold(
        (failure) => emit(ListServiceFailure(failure.message)),
        (result) {
          if (result.services.isEmpty) {
            emit(ListServiceEmpty());
          } else {
            emit(ListServiceLoaded(
              services: result.services,
              pagination: result.pagination,
            ));
          }
        },
      );
    }
  }

  Future<void> _onGetListServiceChangeBranch(GetListServiceChangeBranchEvent event, Emitter<ListServiceState> emit) async {
    AppLogger.info("GetListServiceParams:   event.branchId: ${event.branchId}");
    emit(ListServiceLoading(
      isLoadingMore: false,
      services: [],
      pagination: PaginationModel.isEmty(),
    ));

    final result = await _getListService(GetListServiceParams(1, event.branchId));
    result.fold(
      (failure) => emit(ListServiceFailure(failure.message)),
      (result) {
        if (result.services.isEmpty) {
          emit(ListServiceEmpty());
        } else{
          emit(ListServiceLoaded(
            services: result.services,
            pagination: result.pagination,
          ));
          AppLogger.debug("ListServiceLoaded: ${result.services.length}");
        }
      },
    );
  }
}
