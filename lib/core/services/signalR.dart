import 'dart:async';

import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/services/notification.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/datasources/chat_remote_data_source.dart';
import 'package:spa_mobile/features/home/data/models/notification_model.dart';
import 'package:spa_mobile/features/home/data/repositories/chat_repository_impl.dart';
import 'package:spa_mobile/features/home/domain/repositories/chat_repository.dart';
import 'package:spa_mobile/features/home/domain/usecases/connect_hub.dart';
import 'package:spa_mobile/features/home/domain/usecases/disconnect_hub.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_notification.dart';
import 'package:spa_mobile/init_dependencies.dart';

class SignalRService {
  static bool _isInitialized = false;
  static StreamSubscription<NotificationModel>? _notificationStream;

  static Future<void> initialize(String userId) async {
    // if (_isInitialized) {
    //   AppLogger.info('SignalR service already initialized');
    //   return;
    // }

    // Unregister existing instances if any
    _unregisterExistingInstances();

    // Register new instances
    _registerDependencies(userId);

    // // Connect to SignalR hub
    final connectHub = serviceLocator<ConnectHub>();

    AppLogger.wtf("connect hub");
    await connectHub.call(NoParams());
    _setupMessageStream();

    _isInitialized = true;
    AppLogger.info('SignalR service initialized successfully');
  }

  static void _setupMessageStream() async {
    _notificationStream?.cancel();
    AppLogger.wtf("Set up");
    final stream = serviceLocator<GetNotification>().call(NoParams());

    _notificationStream = stream.listen(
      (notification) {
        // serviceLocator<ListNotificationBloc>().add(AddNewNotificationEvent([notification]));
        NotificationService.showNotification(
            title: notification.type,
            body: notification.content,
            type: notification.type,
            code: notification.objectId.toString(),
            id: notification.notificationId.toString());
      },
      cancelOnError: false,
    );
  }

  static void _unregisterExistingInstances() {
    if (serviceLocator.isRegistered<ChatRemoteDataSource>()) {
      serviceLocator.unregister<ChatRemoteDataSource>();
    }
    if (serviceLocator.isRegistered<ChatRepository>()) {
      serviceLocator.unregister<ChatRepository>();
    }

    if (serviceLocator.isRegistered<GetNotification>()) {
      serviceLocator.unregister<GetNotification>();
    }
    if (serviceLocator.isRegistered<ConnectHub>()) {
      serviceLocator.unregister<ConnectHub>();
    }
    if (serviceLocator.isRegistered<DisconnectHub>()) {
      serviceLocator.unregister<DisconnectHub>();
    }
    // if (serviceLocator.isRegistered<ListNotificationBloc>()) {
    //   serviceLocator.unregister<ListNotificationBloc>();
    // }
  }

  static void _registerDependencies(String userId) {
    serviceLocator
      ..registerLazySingleton<ChatRemoteDataSource>(
        () => SignalRChatRemoteDataSource(
          hubUrl: "https://solaceapi.ddnsking.com/notification",
          userId: userId,
        ),
      )
      ..registerFactory<ChatRepository>(
        () => ChatRepositoryImpl(serviceLocator<ChatRemoteDataSource>()),
      )
      // ..registerLazySingleton<GetAllNotification>(
      //   () => GetAllNotification(serviceLocator<NotificationRepository>()),
      // )
      ..registerLazySingleton<ConnectHub>(
        () => ConnectHub(serviceLocator<ChatRepository>()),
      )
      ..registerLazySingleton<DisconnectHub>(
        () => DisconnectHub(serviceLocator<ChatRepository>()),
      )
      ..registerLazySingleton<GetNotification>(
        () => GetNotification(serviceLocator<ChatRepository>()),
        // )
        // ..registerLazySingleton<ListNotificationBloc>(
        //   () => ListNotificationBloc(
        //     getAllNotification: serviceLocator<GetAllNotification>(),
        //   ),
      );
  }

  static Future<void> disconnect() async {
    // if (!_isInitialized) {
    //   return;
    // }

    try {
      final disconnectHub = serviceLocator<DisconnectHub>();
      await disconnectHub.call(NoParams());
      _isInitialized = false;
      AppLogger.info('SignalR service disconnected successfully');
    } catch (e) {
      AppLogger.error('Error disconnecting SignalR service: $e');
    }
  }

  static bool get isInitialized => _isInitialized;
}
