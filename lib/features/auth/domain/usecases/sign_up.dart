import 'package:spa_mobile/features/auth/domain/repository/auth_repository.dart';

class SignUp {
  final AuthRepository _authRepository;

  SignUp(this._authRepository);

  Future<void> call(String email, String password, String role, String userName,
      String phoneNumber) async {
    await _authRepository.signUp(email, password, role, userName, phoneNumber);
  }
}
