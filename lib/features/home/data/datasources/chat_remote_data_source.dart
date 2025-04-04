import 'dart:async';

import 'package:signalr_netcore/signalr_client.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/home/data/models/chat_message.dart';
import 'package:spa_mobile/features/home/domain/usecases/send_message.dart';

abstract class ChatRemoteDataSource {
  Stream<ChatMessageModel> getMessages();

  Future<void> sendMessage(SendMessageParams message);

  Future<void> connect();

  Future<void> disconnect();
}

class SignalRChatRemoteDataSource implements ChatRemoteDataSource {
  late HubConnection _hubConnection;
  final StreamController<ChatMessageModel> _messageStreamController = StreamController<ChatMessageModel>.broadcast();

  SignalRChatRemoteDataSource({
    required String hubUrl,
  }) {
    AppLogger.info("go connect");
    _hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl,
            options: HttpConnectionOptions(
              transport: HttpTransportType.WebSockets,
            ))
        .withAutomaticReconnect(retryDelays: [2000, 5000]).build();

    // Xử lý sự kiện tái kết nối
    _hubConnection.onreconnecting(({error}) {
      print('Đang cố gắng kết nối lại...');
      // Có thể thêm code để thông báo cho người dùng
    });

    _hubConnection.onreconnected(({connectionId}) {
      print('Đã kết nối lại thành công! ConnectionId: $connectionId');
      // Có thể thêm code để thông báo cho người dùng
    });

    _hubConnection.onclose(({error}) {
      print('Kết nối đã đóng: $error');
      // Có thể thêm code để thông báo cho người dùng
    });
    AppLogger.info("go connect");
    if (_hubConnection.state == HubConnectionState.Connected) {
      _hubConnection.on("receiveChannelMessage", (arguments) {
        AppLogger.info(arguments);
        if (arguments != null && arguments.isNotEmpty) {
          // final sender = arguments[0].toString();
          // final message = arguments[1].toString();
          // final timestamp = DateTime.now();
          AppLogger.info(arguments);
          _messageStreamController.add(ChatMessageModel(userId: "", timestamp: DateTime.now(), channelId: "", content: "Hieu"));
        }
      });
    }
  }

  @override
  Stream<ChatMessageModel> getMessages() => _messageStreamController.stream;

  @override
  Future<void> sendMessage(SendMessageParams params) async {
    if (_hubConnection.state != HubConnectionState.Connected) {
      try {
        await connect();
      } catch (e) {
        throw Exception("Failed to connect to chat server: ${e.toString()}");
      }
    }

    try {
      await _hubConnection.invoke(
        "SendMessageToChannel",
        args: [params.channelId, params.senderId, params.content ?? "", params.messageType, params.fileUrl ?? ""],
      );

      AppLogger.info("Message sent successfully to channel ${params.channelId}");
    } catch (e) {
      AppLogger.error("Failed to send message to channel ${params.channelId}", error: e);
      throw Exception("Failed to send message: ${e.toString()}");
    }
  }

  @override
  Future<void> connect() async {
    AppLogger.info("Attempting to connect to hub: ${_hubConnection.baseUrl}");
    await _hubConnection.start();
    AppLogger.info("Connect success: ${_hubConnection.baseUrl}");
    AppLogger.info("Connect success: ${_hubConnection.connectionId}");
    _hubConnection.on("receiveChannelMessage", (arguments) {
      AppLogger.info(arguments);
      if (arguments != null && arguments.isNotEmpty) {
        final message = ChatMessageModel(
          userId: arguments[0].toString(),
          content: arguments[1].toString(),
          timestamp: DateTime.now(),
          channelId: arguments[2].toString(),
        );
        _messageStreamController.add(message);
      }
    });
  }

  @override
  Future<void> disconnect() async {
    await _hubConnection.stop();
    _messageStreamController.close();
  }
}
