part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String role;
  final String userName;
  final String phoneNumber;

  SignUpEvent({
    required this.email,
    required this.password,
    required this.role,
    required this.userName,
    required this.phoneNumber,
  });
}
class GoogleLoginEvent extends AuthEvent {}