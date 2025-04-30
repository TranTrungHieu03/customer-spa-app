import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/datasources/chat_remote_data_source.dart';
import 'package:spa_mobile/features/home/data/repositories/chat_repository_impl.dart';
import 'package:spa_mobile/features/home/domain/repositories/chat_repository.dart';
import 'package:spa_mobile/features/home/domain/usecases/connect_hub.dart';
import 'package:spa_mobile/features/home/domain/usecases/disconnect_hub.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_message.dart';
import 'package:spa_mobile/features/home/domain/usecases/send_message.dart';
import 'package:spa_mobile/features/home/presentation/blocs/chat/chat_bloc.dart';
import 'package:spa_mobile/init_dependencies.dart';

class SignalRService {
  static bool _isInitialized = false;

  static Future<void> initialize(String userId) async {
    if (_isInitialized) {
      AppLogger.info('SignalR service already initialized');
      return;
    }

    // Unregister existing instances if any
    _unregisterExistingInstances();

    // Register new instances
    _registerDependencies(userId);

    // Connect to SignalR hub
    final connectHub = serviceLocator<ConnectHub>();
    await connectHub.call(NoParams());

    _isInitialized = true;
    AppLogger.info('SignalR service initialized successfully');
  }

  static void _unregisterExistingInstances() {
    if (serviceLocator.isRegistered<ChatRemoteDataSource>()) {
      serviceLocator.unregister<ChatRemoteDataSource>();
    }
    if (serviceLocator.isRegistered<ChatRepository>()) {
      serviceLocator.unregister<ChatRepository>();
    }
    if (serviceLocator.isRegistered<SendMessage>()) {
      serviceLocator.unregister<SendMessage>();
    }
    if (serviceLocator.isRegistered<GetMessages>()) {
      serviceLocator.unregister<GetMessages>();
    }
    if (serviceLocator.isRegistered<ConnectHub>()) {
      serviceLocator.unregister<ConnectHub>();
    }
    if (serviceLocator.isRegistered<DisconnectHub>()) {
      serviceLocator.unregister<DisconnectHub>();
    }
    if (serviceLocator.isRegistered<ChatBloc>()) {
      serviceLocator.unregister<ChatBloc>();
    }
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
      ..registerLazySingleton<SendMessage>(
        () => SendMessage(serviceLocator<ChatRepository>()),
      )
      ..registerLazySingleton<ConnectHub>(
        () => ConnectHub(serviceLocator<ChatRepository>()),
      )
      ..registerLazySingleton<DisconnectHub>(
        () => DisconnectHub(serviceLocator<ChatRepository>()),
      )
      ..registerLazySingleton<GetMessages>(
        () => GetMessages(serviceLocator<ChatRepository>()),
      )
      ..registerLazySingleton<ChatBloc>(
        () => ChatBloc(
          getMessages: serviceLocator<GetMessages>(),
          sendMessage: serviceLocator<SendMessage>(),
          connect: serviceLocator<ConnectHub>(),
          disconnect: serviceLocator<DisconnectHub>(),
        ),
      );
  }

  static Future<void> disconnect() async {
    if (!_isInitialized) {
      return;
    }

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
