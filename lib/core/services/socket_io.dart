// import 'package:socket_io_client/socket_io_client.dart' as IO;
class SocketIOService {
  static final SocketIOService _instance = SocketIOService._internal();

  factory SocketIOService() => _instance;

  SocketIOService._internal() {
    initSocket();
  }

  Future<void> initSocket() async {
    // SocketIOManager().createSocketIO(
    //   'https://socket-io-chat.now.sh/',
    //   '/',
    // )
    //   ..init()
    //   ..subscribe('receive_message', (jsonData) {
    //     print('receive_message: ' + jsonData.toString());
    //   })
    //   ..connect();
  }
}
