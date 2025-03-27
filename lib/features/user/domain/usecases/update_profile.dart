import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/auth/domain/repository/auth_repository.dart';

class UpdateProfileParams {
  UserModel userInfo;
  final String? newAvatarFilePath;

  UpdateProfileParams(this.userInfo, this.newAvatarFilePath);

  Future<FormData> toFormData() async {
    Map<String, dynamic> userInfoMap = userInfo.toJson();

    FormData formData = FormData.fromMap(userInfoMap);

    if (newAvatarFilePath != null && newAvatarFilePath!.isNotEmpty) {
      formData.files.add(
        MapEntry(
          'avatar',
          await MultipartFile.fromFile(newAvatarFilePath!, filename: 'avatar.jpg'),
        ),
      );
    } else if (userInfo.avatar != null && userInfo.avatar!.isNotEmpty) {
      formData.fields.add(MapEntry('avatar', userInfo.avatar!));
    }

    return formData;
  }
}

class UpdateProfile implements UseCase<Either, UpdateProfileParams> {
  final AuthRepository _repository;

  UpdateProfile(this._repository);

  @override
  Future<Either> call(UpdateProfileParams params) async {
    return await _repository.updateProfile(params);
  }
}
