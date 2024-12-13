import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';

class ForgetPassword implements UseCase<Either, ForgetPasswordParams> {
  @override
  Future<Either<Failure, String>> call(ForgetPasswordParams params) async {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class ForgetPasswordParams {
  final String email;

  ForgetPasswordParams({required this.email});

  Map<String, dynamic> toJson() {
    return {"email": email};
  }
}
