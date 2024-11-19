import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/network/connection_checker.dart';
import 'package:spa_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:spa_mobile/features/auth/domain/repository/auth_repository.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final ConnectionChecker _connectionChecker;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  @override
  Future<Either<Failure, String>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return left(const ApiFailure(message: "Google sign-in aborted"));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception("Failed to retrieve Google tokens");
      }
      final OAuthCredential credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception("Failed to retrieve Google tokens");
      }
      try {
        final userCredential = await _firebaseAuth.signInWithCredential(credentials);
        // final User? user = userCredential.user;
        // print(user);
      } catch (e) {
        print("Lỗi đăng nhập Firebase: $e");
      }

      // final User? user = userCredential.user;

      // if (user == null) {
      //   return left(const ApiFailure(message: "Google sign-in aborted"));
      // }

      // final String email = user.email ?? '';
      // final String userName = user.displayName ?? '';
      // final String imageUrl = user.photoURL ?? '';
      // final String phone = user.phoneNumber ?? '';
      //
      print("!1111111111111111111111111");
      //
      // String token = await _authRemoteDataSource.loginWithGoogle(
      //   LoginWithGoogleParams(
      //     email: email,
      //     userName: userName,
      //     imageUrl: imageUrl,
      //     phone: phone,
      //   ),
      // );

      return right("");
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
