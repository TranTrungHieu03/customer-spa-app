import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/auth/domain/usecases/get_user_info.dart';
import 'package:spa_mobile/features/user/domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfile _updateProfile;
  final GetUserInformation _getUserInformation;

  ProfileBloc({
    required UpdateProfile updateProfile,
    required GetUserInformation getUserInformation,
  })  : _updateProfile = updateProfile,
        _getUserInformation = getUserInformation,
        super(ProfileInitial()) {
    on<UpdateUserProfileEvent>(_onUpdateProfile);
    on<GetUserInfoEvent>(_onGetUserInformation);
  }

  Future<void> _onUpdateProfile(UpdateUserProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await _updateProfile(event.params);
    result.fold((failure) => emit(ProfileError(failure)), (data) => emit(ProfileLoaded(data)));
  }

  Future<void> _onGetUserInformation(GetUserInfoEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await _getUserInformation(NoParams());
    result.fold((failure) => emit(ProfileError(failure.message)), (user) => emit(ProfileLoaded(user)));
  }
}
