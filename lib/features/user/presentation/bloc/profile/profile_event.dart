part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class UpdateUserProfileEvent extends ProfileEvent {
  final UpdateProfileParams params;
  final bool isChangeAddress;
  final AddressModel addressModel;

  UpdateUserProfileEvent({required this.params, this.isChangeAddress = false, required this.addressModel});
}

class GetUserInfoEvent extends ProfileEvent {}
