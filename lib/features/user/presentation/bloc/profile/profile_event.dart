part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class UpdateUserProfileEvent extends ProfileEvent {
  final UpdateProfileParams params;

  UpdateUserProfileEvent({
    required this.params,
  });
}

class GetUserInfoEvent extends ProfileEvent {}
