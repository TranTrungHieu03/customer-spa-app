import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';

class ResetPassword implements UseCase<Either, ResetPasswordParams> {
  @override
  Future<Either<Failure, String>> call(ResetPasswordParams params) async {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class ResetPasswordParams {
  final String email;
  final String password;
  final String passwordConfirm;

  ResetPasswordParams(
      {required this.email,
      required this.password,
      required this.passwordConfirm});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "confirmPassword": passwordConfirm
    };
  }
}
