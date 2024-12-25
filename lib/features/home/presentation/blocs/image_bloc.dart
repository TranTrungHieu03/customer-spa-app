import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<ValidateImageEvent>(_onValidateImage);
  }

  Future<void> _onPickImage(PickImageEvent event, Emitter<ImageState> emit) async {
    try {
      emit(ImageLoading());
      final status = await Permission.photos.status;
      if (!status.isGranted) {
        final requestStatus = await Permission.photos.request();
        if (!requestStatus.isGranted) {
          emit(ImageInvalid("Permission to access photos is denied."));
          return;
        }
      }
      if (status.isDenied || status.isPermanentlyDenied) {
        emit(ImageInvalid("Permission to access photos is denied. Please enable it in settings."));
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
        return;
      }

      // Logic chọn ảnh
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        emit(ImagePicked(image.path));
      } else {
        emit(ImageInvalid("No image selected."));
      }
    } catch (e) {
      emit(ImageInvalid("Error picking image: $e"));
    }
  }

  Future<void> _onValidateImage(ValidateImageEvent event, Emitter<ImageState> emit) async {
    try {
      emit(ImageLoading());

      final File file = File(event.imagePath);

      // Kiểm tra định dạng
      final String extension = file.path.split('.').last.toLowerCase();
      if (extension != 'jpg' && extension != 'jpeg') {
        emit(ImageInvalid("Invalid format. Only JPG or JPEG are allowed."));
        return;
      }

      // Kiểm tra kích thước file
      if (file.lengthSync() > 5 * 1024 * 1024) {
        emit(ImageInvalid("File size exceeds 5MB."));
        return;
      }

      // Kiểm tra độ phân giải
      final img.Image? decodedImage = img.decodeImage(file.readAsBytesSync());
      if (decodedImage == null ||
          decodedImage.width < 200 ||
          decodedImage.height < 200 ||
          decodedImage.width > 4096 ||
          decodedImage.height > 4096) {
        emit(ImageInvalid("Resolution is out of bounds."));
        return;
      }

      emit(ImageValid());
    } catch (e) {
      emit(ImageInvalid("Validation error: $e"));
    }
  }
}
