part of 'image_bloc.dart';

@immutable
sealed class ImageEvent {}

final class PickImageEvent extends ImageEvent {}

final class ValidateImageEvent extends ImageEvent {
  final String imagePath;

  ValidateImageEvent(this.imagePath);
}
