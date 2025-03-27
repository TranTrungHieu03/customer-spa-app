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
      try {
        final address = event.addressModel;

        // 🔹 Lấy danh sách tỉnh/thành phố
        final provinceRs = await _getProvince(NoParams());
        final List<ProvinceModel> provinceList = provinceRs.fold(
          (failure) => throw Exception("Không tìm thấy tỉnh/thành phố"),
          (data) => data,
        );

        final selectedProvince = provinceList.firstWhere((x) => x.nameExtension.contains(address.province));

        // 🔹 Lấy danh sách quận/huyện
        final districtRs = await _getDistrict(GetDistrictParams(selectedProvince.provinceId));
        final List<DistrictModel> districtList = districtRs.fold(
          (failure) => throw Exception("Không tìm thấy quận/huyện"),
          (data) => data,
        );

        final selectedDistrict = districtList.firstWhere((x) => x.nameExtension.contains(address.district));

        // 🔹 Lấy danh sách phường/xã
        final communeRs = await _getWard(GetWardParams(selectedDistrict.districtId));
        final List<WardModel> communeList = communeRs.fold(
          (failure) => throw Exception("Không tìm thấy phường/xã"),
          (data) => data,
        );

        final selectedCommune = communeList.firstWhere((x) => x.nameExtension.contains(address.commune));

        // 🔹 Cập nhật thông tin user
        userInfo = userInfo.copyWith(
          district: selectedDistrict.districtId,
          wardCode: int.parse(selectedCommune.wardCode),
        );
      } catch (e) {
        emit(ProfileError(e.toString())); // Xuất lỗi đúng lúc
        return;
      }
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
