import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveLocalNotification(NotificationResponse notificationResponse) async {
    AppLogger.wtf('Notification clicked with payload: ${notificationResponse.payload}');
    if (notificationResponse.payload?.startsWith('Appointment:') == true) {
      final orderId = notificationResponse.payload!.split(':')[1];
      goAppointmentDetail(orderId, false);
    }
    if (notificationResponse.payload?.startsWith('Product:') == true) {
      final orderId = notificationResponse.payload!.split(':')[1];
      goOrderProductDetail(int.parse(orderId));
    }
    if (notificationResponse.payload?.startsWith('Routine:') == true) {
      final orderId = notificationResponse.payload!.split(':')[1];
      goOrderRoutineDetail(int.parse(orderId));
    }
    if (notificationResponse.payload?.startsWith('ProductAndService:') == true) {
      final orderId = notificationResponse.payload!.split(':')[1];
      goOrderMixDetail(int.parse(orderId));
    }
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/logo_light');

    const DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings, iOS: darwinInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveLocalNotification);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNotification(
      {required String title, required String body, required String type, required String code, required String id}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: '$type:$code:$id',
    );
  }

  static Future<void> scheduledNotification({required String title, required String body, required DateTime scheduleTime}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      // tz.TZDateTime.from(scheduleTime, tz.local),
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
