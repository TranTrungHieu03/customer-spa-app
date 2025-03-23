import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Singleton pattern
  static final PermissionService _instance = PermissionService._internal();

  factory PermissionService() => _instance;

  PermissionService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize notification plugin
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Kiểm tra và xin quyền vị trí
  Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra dịch vụ vị trí có được bật không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Lấy vị trí hiện tại
  Future<Position?> getCurrentLocation() async {
    bool permissionGranted = await requestLocationPermission();

    if (permissionGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        return position;
      } catch (e) {
        debugPrint('Lỗi khi lấy vị trí: $e');
        return null;
      }
    }

    return null;
  }

  // Kiểm tra và xin quyền camera
  Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;

    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    return status.isGranted;
  }

  // Kiểm tra và xin quyền thư viện ảnh
  Future<bool> requestPhotosPermission() async {
    PermissionStatus status = await Permission.photos.status;

    if (status.isDenied) {
      status = await Permission.photos.request();
    }

    return status.isGranted;
  }

  // Lấy ảnh từ camera
  Future<XFile?> getImageFromCamera() async {
    bool hasPermission = await requestCameraPermission();

    if (hasPermission) {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        return photo;
      } catch (e) {
        debugPrint('Lỗi khi sử dụng camera: $e');
        return null;
      }
    }

    return null;
  }

  // Lấy ảnh từ thư viện
  Future<XFile?> getImageFromGallery() async {
    bool hasPermission = await requestPhotosPermission();

    if (hasPermission) {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        return image;
      } catch (e) {
        debugPrint('Lỗi khi chọn ảnh từ thư viện: $e');
        return null;
      }
    }

    return null;
  }

  // Kiểm tra và xin quyền thông báo
  Future<bool> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied) {
      status = await Permission.notification.request();
    }

    return status.isGranted;
  }

  // Hiển thị thông báo
  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    bool hasPermission = await requestNotificationPermission();

    if (hasPermission) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
      );
    }
  }

  // Mở cài đặt ứng dụng để người dùng cấp quyền thủ công
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  // Mở cài đặt vị trí
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // Hiển thị dialog yêu cầu quyền
  void showPermissionDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onOpenSettings,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onOpenSettings();
            },
            child: const Text("Mở cài đặt"),
          ),
        ],
      ),
    );
  }

  // Kiểm tra và xin nhiều quyền cùng lúc
  Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(List<Permission> permissions) async {
    return await permissions.request();
  }
}
