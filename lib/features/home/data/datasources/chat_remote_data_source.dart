import 'dart:async';

import 'package:signalr_netcore/signalr_client.dart';
import 'package:spa_mobile/features/home/data/models/chat_message.dart';

abstract class ChatRemoteDataSource {
  Stream<ChatMessageModel> getMessages();

  Future<void> sendMessage(String message);

  Future<void> connect();

  Future<void> disconnect();
}

class SignalRChatRemoteDataSource implements ChatRemoteDataSource {
  late HubConnection _hubConnection;
  final StreamController<ChatMessageModel> _messageStreamController = StreamController<ChatMessageModel>.broadcast();

  SignalRChatRemoteDataSource({
    required String hubUrl,
  }) {
    _hubConnection = HubConnectionBuilder().withUrl(hubUrl).build();

    _hubConnection.on("ReceiveMessage", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final sender = arguments[0].toString();
        final message = arguments[1].toString();
        final timestamp = DateTime.now();
        _messageStreamController.add(ChatMessageModel(userId: sender, message: message, timestamp: timestamp));
      }
    });
  }

  @override
  Stream<ChatMessageModel> getMessages() => _messageStreamController.stream;

  @override
  Future<void> sendMessage(String message) async {
    if (_hubConnection.state == HubConnectionState.Connected) {
      await _hubConnection.invoke("SendMessage", args: ["FlutterUser", message]);
    }
  }

  @override
  Future<void> connect() async {
    await _hubConnection.start();
  }

  @override
  Future<void> disconnect() async {
    await _hubConnection.stop();
    _messageStreamController.close();
  }
}
