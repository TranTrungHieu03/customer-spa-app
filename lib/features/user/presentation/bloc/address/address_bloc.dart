import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/home/data/models/address_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_address_auto_complete.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressAutoComplete _addressAutoComplete;

  AddressBloc({required GetAddressAutoComplete addressAutoComplete})
      : _addressAutoComplete = addressAutoComplete,
        super(AddressInitial()) {
    on<GetListAddressEvent>(_onGetAddress);
    on<RefreshAddressEvent>(_onRefreshAddress);
  }

  Future<void> _onGetAddress(
    GetListAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await _addressAutoComplete.call(event.params);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (list) => emit(AddressLoaded(list)),
    );
  }

  Future<void> _onRefreshAddress(
    RefreshAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressInitial());
  }
}
