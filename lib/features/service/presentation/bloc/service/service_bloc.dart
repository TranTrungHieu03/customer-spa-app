import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_service_detail.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetServiceDetail _getServiceDetail;

  ServiceBloc({
    required GetServiceDetail getServiceDetail,
  })  : _getServiceDetail = getServiceDetail,
        super(ServiceInitial()) {
    on<GetServiceDetailEvent>(_onGetServiceDetail);
  }

  Future<void> _onGetServiceDetail(GetServiceDetailEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceLoading());
    final result = await _getServiceDetail(GetServiceDetailParams(id: event.id));
    result.fold(
      (failure) => emit(ServiceDetailFailure(failure.message)),
      (result) => emit(ServiceDetailSuccess(result)),
    );
  }
}
