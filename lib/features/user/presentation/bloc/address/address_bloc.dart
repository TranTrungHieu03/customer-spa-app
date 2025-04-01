import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_address_auto_complete.dart';
import 'package:spa_mobile/features/product/data/model/district_model.dart';
import 'package:spa_mobile/features/product/data/model/province_model.dart';
import 'package:spa_mobile/features/product/data/model/ward_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_district.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_province.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_ward.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressAutoComplete _addressAutoComplete;
  final GetProvince _getProvince;
  final GetDistrict _getDistrict;
  final GetWard _getWard;

  AddressBloc(
      {required GetAddressAutoComplete addressAutoComplete,
      required GetProvince getProvince,
      required GetDistrict getDistrict,
      required GetWard getWard})
      : _addressAutoComplete = addressAutoComplete,
        _getDistrict = getDistrict,
        _getWard = getWard,
        _getProvince = getProvince,
        super(AddressInitial()) {
    on<GetListAddressEvent>(_onGetAddress);
    on<RefreshAddressEvent>(_onRefreshAddress);
    on<GetListDistrictEvent>(_onGetDistrict);
    on<GetListProvinceEvent>(_onGetProvince);
    on<GetListCommuneEvent>(_onGetWard);
  }

  Future<void> _onGetAddress(
    GetListAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await _addressAutoComplete.call(event.params);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (list) => emit(AddressInitial()),
    );
  }

  Future<void> _onGetProvince(
    GetListProvinceEvent event,
    Emitter<AddressState> emit,
  ) async {
    final result = await _getProvince.call(NoParams());
    result.fold((failure) => emit(AddressError(failure.message)), (list) {
      AppLogger.info(list);
      emit(AddressProvinceLoaded(provinces: list, districts: [], wards: [], isLoadingCommune: false, isLoadingDistrict: false));
    });
  }

  Future<void> _onGetDistrict(
    GetListDistrictEvent event,
    Emitter<AddressState> emit,
  ) async {
    final currentState = state;
    if (currentState is AddressProvinceLoaded) {
      emit(AddressProvinceLoaded(
          provinces: currentState.provinces, districts: [], wards: [], isLoadingCommune: false, isLoadingDistrict: true));

      final result = await _getDistrict.call(event.params);
      result.fold((failure) => emit(AddressError(failure.message)), (list) {
        emit(AddressProvinceLoaded(
            provinces: currentState.provinces, districts: list, wards: [], isLoadingCommune: false, isLoadingDistrict: false));
      });
    }
  }

  Future<void> _onGetWard(
    GetListCommuneEvent event,
    Emitter<AddressState> emit,
  ) async {
    final currentState = state;
    if (currentState is AddressProvinceLoaded) {
      emit(AddressProvinceLoaded(
          provinces: currentState.provinces,
          districts: currentState.districts,
          wards: [],
          isLoadingCommune: true,
          isLoadingDistrict: false));

      final result = await _getWard.call(event.params);
      result.fold((failure) => emit(AddressError(failure.message)), (list) {
        emit(AddressProvinceLoaded(
            provinces: currentState.provinces,
            districts: currentState.districts,
            wards: list,
            isLoadingCommune: false,
            isLoadingDistrict: false));
      });
    }
  }

  Future<void> _onRefreshAddress(
    RefreshAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressInitial());
  }
}
