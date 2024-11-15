import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/auth/domain/repository/auth_repository.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignUpEvent>(_onSignUpEvent);
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

    final result = await _authRepository.signUp(
      event.email,
      event.password,
      event.role,
      event.userName,
      event.phoneNumber,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthSuccess("SignUp Successful")),
    );
  }
}
