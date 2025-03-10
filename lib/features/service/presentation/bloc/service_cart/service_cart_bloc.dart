import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';

part 'service_cart_event.dart';
part 'service_cart_state.dart';

class ServiceCartBloc extends Bloc<ServiceCartEvent, ServiceCartState> {
  ServiceCartBloc() : super(ServiceCartInitial()) {
    on<LoadServices>(_onLoadServices);
    on<AddService>(_onAddService);
    on<RemoveService>(_onRemoveService);
    on<ToggleCartVisibility>(_onToggleCartVisibility);
  }

  void _onLoadServices(LoadServices event, Emitter<ServiceCartState> emit) async {
    emit(ServiceCartLoading());
    try {
      final servicesJson = jsonDecode(await LocalStorage.getData(LocalStorageKey.serviceCart));
      final services = (servicesJson as List).map((x) => ServiceModel.fromJson(x)).toList();
      emit(ServiceCartLoaded(services: services));
    } catch (e) {
      emit(ServiceCartError("Không thể tải dịch vụ: ${e.toString()}"));
    }
  }

  void _onAddService(AddService event, Emitter<ServiceCartState> emit) async {
    if (state is ServiceCartLoaded) {
      final currentState = state as ServiceCartLoaded;
      final updatedServices = List<ServiceModel>.from(currentState.services)..add(event.service);
      await LocalStorage.saveData(LocalStorageKey.serviceCart, jsonEncode(updatedServices));
      emit(currentState.copyWith(services: updatedServices));
    }
  }

  void _onRemoveService(RemoveService event, Emitter<ServiceCartState> emit) async {
    if (state is ServiceCartLoaded) {
      final currentState = state as ServiceCartLoaded;
      final updatedServices = List<ServiceModel>.from(currentState.services)
        ..removeWhere((service) => service.serviceId == event.serviceId);
      await LocalStorage.saveData(LocalStorageKey.serviceCart, jsonEncode(updatedServices));
      emit(currentState.copyWith(services: updatedServices));
    }
  }

  void _onToggleCartVisibility(ToggleCartVisibility event, Emitter<ServiceCartState> emit) {
    if (state is ServiceCartLoaded) {
      final currentState = state as ServiceCartLoaded;
      emit(currentState.copyWith(isVisible: !currentState.isVisible));
    }
  }
}
