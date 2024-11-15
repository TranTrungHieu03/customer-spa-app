import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/network/connection_checker.dart';
import 'package:spa_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:spa_mobile/features/auth/domain/repository/auth_repository.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final ConnectionChecker _connectionChecker;

  AuthRepositoryImpl(this._authRemoteDataSource, this._connectionChecker);

  @override
  Future<Either<Failure, String>> login(LoginParams params) async {
    try {
      String token = await _authRemoteDataSource.login(params);
      return right(token);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> signUp(String email, String password,
      String role, String userName, String phoneNumber) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
