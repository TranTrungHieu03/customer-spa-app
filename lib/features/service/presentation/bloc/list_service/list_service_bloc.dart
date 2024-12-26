import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/domain/repository/service_repository.dart';

part 'list_service_event.dart';
part 'list_service_state.dart';

class ListServiceBloc extends Bloc<ListServiceEvent, ListServiceState> {
  final ServiceRepository _serviceRepository;

  ListServiceBloc(this._serviceRepository) : super(ListServiceInitial()) {
    on<GetListServicesEvent>(_onGetListServices);
  }

  Future<void> _onGetListServices(
      GetListServicesEvent event, Emitter<ListServiceState> emit) async {
    final currentState = state;
    if (currentState is ListServiceLoaded && currentState.isLoadingMore) {
      return;
    }
    if (currentState is ListServiceLoaded) {
      emit(currentState.copyWith(isLoadingMore: true));
      final result = await _serviceRepository.getServices(event.page);
      result.fold(
        (failure) => emit(ListServiceFailure(failure.message)),
        (result) => emit(ListServiceLoaded(
            services: currentState.services + result.services,
            pagination: result.pagination,
            isLoadingMore: false)),
      );
    } else {
      emit(const ListServiceLoading(isLoadingMore: false));
      final result = await _serviceRepository.getServices(event.page);
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
}
