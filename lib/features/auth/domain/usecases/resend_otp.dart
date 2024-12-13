import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';

class ResendOtp implements UseCase<Either, ResendOtpParams> {
  @override
  Future<Either<Failure, String>> call(ResendOtpParams params) async {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class ResendOtpParams {
  final String email;

  ResendOtpParams({required this.email});

  Map<String, dynamic> toJson() {
    return {"email": email};
  }
}
