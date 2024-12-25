part of 'image_bloc.dart';

@immutable
sealed class ImageState {}

final class ImageInitial extends ImageState {}

final class ImageLoading extends ImageState {}

final class ImagePicked extends ImageState {
  final String imagePath;

  ImagePicked(this.imagePath);
}

final class ImageValid extends ImageState {}

final class ImageInvalid extends ImageState {
  final String error;

  ImageInvalid(this.error);
}
