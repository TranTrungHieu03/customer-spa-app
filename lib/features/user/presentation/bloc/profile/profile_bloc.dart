import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/auth/domain/usecases/get_user_info.dart';
import 'package:spa_mobile/features/home/data/models/address_model.dart';
import 'package:spa_mobile/features/product/data/model/district_model.dart';
import 'package:spa_mobile/features/product/data/model/province_model.dart';
import 'package:spa_mobile/features/product/data/model/ward_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_district.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_province.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_ward.dart';
import 'package:spa_mobile/features/user/domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfile _updateProfile;
  final GetUserInformation _getUserInformation;
  final GetProvince _getProvince;
  final GetDistrict _getDistrict;
  final GetWard _getWard;

  ProfileBloc(
      {required UpdateProfile updateProfile,
      required GetUserInformation getUserInformation,
      required GetProvince getProvince,
      required GetDistrict getDistrict,
      required GetWard getWard})
      : _updateProfile = updateProfile,
        _getUserInformation = getUserInformation,
        _getDistrict = getDistrict,
        _getWard = getWard,
        _getProvince = getProvince,
        super(ProfileInitial()) {
    on<UpdateUserProfileEvent>(_onUpdateProfile);
    on<GetUserInfoEvent>(_onGetUserInformation);
  }

  Future<void> _onUpdateProfile(UpdateUserProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    UserModel userInfo = event.params.userInfo;
    if (event.isChangeAddress) {
      final address = event.addressModel;
      final provinceRs = await _getProvince(NoParams());

      provinceRs.fold((failure) => emit(ProfileError("Không tìm thấy tỉnh/thành phố")), (data) async {
        final List<ProvinceModel> provinceList = data;
        final selectedProvince = provinceList.firstWhere((x) => x.nameExtension.contains(address.province));
        final districtRs = await _getDistrict(GetDistrictParams(selectedProvince.provinceId));
        districtRs.fold((failure) => emit(ProfileError("Không tìm thấy quận/huyện")), (dataDistrict) async {
          final List<DistrictModel> districtList = dataDistrict;
          final selectedDistrict = districtList.firstWhere((x) => x.nameExtension.contains(address.district));
          final communeRs = await _getWard(GetWardParams(selectedDistrict.districtId));
          communeRs.fold((failure) => emit(ProfileError("Không tìm thấy phường/xã")), (dataCommune) async {
            final List<WardModel> communeList = dataCommune;
            final selectedCommune = communeList.firstWhere((x) => x.nameExtension.contains(address.commune));
            userInfo = userInfo.copyWith(district: selectedDistrict.districtId, wardCode: int.parse(selectedCommune.wardCode));
          });
        });
      });
    }
    AppLogger.info(userInfo.district);
    final result = await _updateProfile(UpdateProfileParams(userInfo, event.params.newAvatarFilePath));
    result.fold((failure) => emit(ProfileError(failure)), (data) => emit(ProfileLoaded(data)));
  }

  Future<void> _onGetUserInformation(GetUserInfoEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await _getUserInformation(NoParams());
    result.fold((failure) => emit(ProfileError(failure.message)), (user) => emit(ProfileLoaded(user)));
  }
}
