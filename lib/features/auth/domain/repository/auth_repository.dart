import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<Either<Failure, void>> signUp(String email, String password,
      String role, String userName, String phoneNumber);

  Future<Either<Failure, String>> login(LoginParams params);

  Future<Either<Failure, String>> loginWithGoogle();
}
