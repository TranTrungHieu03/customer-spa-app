import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login.dart';
import 'package:spa_mobile/features/auth/domain/usecases/sign_up.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<Either<Failure, void>> signUp(SignUpParams params);

  Future<Either<Failure, String>> login(LoginParams params);

  Future<Either<Failure, String>> loginWithGoogle();

  Future<Either<Failure, String>> loginWithFacebook();
}
