import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/domain/repository/service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository _serviceRepository;

  ServiceBloc(this._serviceRepository) : super(ServiceInitial()) {
    on<GetListServicesEvent>(_onGetListServices);
  }

  Future<void> _onGetListServices(
      GetListServicesEvent event, Emitter<ServiceState> emit) async {
    final currentState = state;

    if (currentState is ListServiceLoaded) {
      emit(currentState.copyWith(isLoadingMore: true));
      final result = await _serviceRepository.getServices(event.page);
      result.fold(
        (failure) => emit(ServiceFailure(failure.message)),
        (result) => emit(ListServiceLoaded(
            services: currentState.services + result.services,
            pagination: result.pagination,
            isLoadingMore: false)),
      );
    } else {
      emit(ServiceLoading());
      final result = await _serviceRepository.getServices(event.page);
      result.fold(
        (failure) => emit(ServiceFailure(failure.message)),
        (result) => emit(ListServiceLoaded(
            services: result.services, pagination: result.pagination)),
      );
    }
  }
}
