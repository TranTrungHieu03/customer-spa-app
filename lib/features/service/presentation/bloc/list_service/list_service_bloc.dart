import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/service/data/model/category_model.dart';
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
    on<GetListServicesForSelectionEvent>(_onGetListServicesSelection);
    on<GetListServiceChangeBranchEvent>(_onGetListServiceChangeBranch);
    on<SelectCategoryEvent>(_onSelectCategory);
  }

  Future<void> _onGetListServices(GetListServicesEvent event, Emitter<ListServiceState> emit) async {
    final result = await _getListService(GetListServiceParams(event.page, event.branchId, event.pageSize));
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

  Future<void> _onGetListServicesSelection(GetListServicesForSelectionEvent event, Emitter<ListServiceState> emit) async {
    emit(ListServiceLoadingForSelection());

    final result = await _getListService(GetListServiceParams(event.page, event.branchId, event.pageSize));

    result.fold((failure) => emit(ListServiceFailure(failure.message)), (result) {
      final Map<int, List<ServiceModel>> groupedServices = {};
      final Set<CategoryModel> categorySet = {};
      final List<ServiceModel> services = result.services;

      for (var service in services) {
        if (!groupedServices.containsKey(service.serviceCategoryId)) {
          groupedServices[service.serviceCategoryId] = [];
        }
        groupedServices[service.serviceCategoryId]!.add(service);
        categorySet.add(service.serviceCategory!);
      }

      final categories = categorySet.toList();

      emit(ListServiceLoadedForSelection(
        groupedServices: groupedServices,
        categories: categories,
      ));
    });
  }

  Future<void> _onGetListServiceChangeBranch(GetListServiceChangeBranchEvent event, Emitter<ListServiceState> emit) async {
    AppLogger.info("GetListServiceParams:   event.branchId: ${event.branchId}");
    emit(ListServiceLoading(
      isLoadingMore: false,
      services: [],
      pagination: PaginationModel.isEmty(),
    ));

    final result = await _getListService(GetListServiceParams(1, event.branchId, 10));
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
          AppLogger.debug("ListServiceLoaded: ${result.services.length}");
        }
      },
    );
  }

  Future<void> _onSelectCategory(SelectCategoryEvent event, Emitter<ListServiceState> emit) async {
    if (state is ListServiceLoadedForSelection) {
      final currentState = state as ListServiceLoadedForSelection;
      emit(ListServiceLoadedForSelection(
        categories: currentState.categories,
        groupedServices: currentState.groupedServices,
        selectedCategoryId: event.categoryId,
      ));
    }
  }
}
