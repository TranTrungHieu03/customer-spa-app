import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/auth/domain/repository/auth_repository.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login.dart';
import 'package:spa_mobile/features/auth/domain/usecases/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<GoogleLoginEvent>(_onGoogleLoginEvent);
    on<FacebookLoginEvent>(_onFacebookLoginEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _authRepository
        .login(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (token) => emit(AuthSuccess(token)),
    );
  }

  Future<void> _onSignUpEvent(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _authRepository.signUp(SignUpParams(
        email: event.email,
        password: event.password,
        role: "customer",
        userName: event.userName,
        phoneNumber: event.phoneNumber));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthSuccess("SignUp Successful")),
    );
  }

  Future<void> _onGoogleLoginEvent(
      GoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _authRepository.loginWithGoogle();

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (token) => emit(AuthSuccess("SignUp With Google Successful")),
    );
  }

  Future<void> _onFacebookLoginEvent(
      FacebookLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _authRepository.loginWithFacebook();

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (token) => emit(AuthSuccess("SignUp With Facebook Successful")),
    );
  }
}
