import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/features/home/domain/usecases/send_message.dart';
import 'package:spa_mobile/features/home/presentation/blocs/chat/chat_bloc.dart';
import 'package:spa_mobile/features/home/presentation/widgets/chat_message_list.dart';
import 'package:spa_mobile/features/home/presentation/widgets/chat_type_message.dart';
import 'package:spa_mobile/init_dependencies.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.channelId});

  final String channelId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatBloc chatBloc;
  ScrollController chatListScrollController = ScrollController();
  TextEditingController messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc(
      getMessages: serviceLocator(),
      sendMessage: serviceLocator(),
      connect: serviceLocator(),
      disconnect: serviceLocator(),
    );
    chatBloc.add(ChatConnectEvent());
  }

  @override
  void dispose() {
    chatBloc.add(ChatDisconnectEvent()); // Gọi trên biến lưu thay vì context
    chatListScrollController.dispose();
    messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: chatBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is ChatError) {
                TSnackBar.errorSnackBar(context, message: state.error);
              }
            },
            child: Container(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoaded) {
                        return chatMessageWidget(chatListScrollController, state.messages, "");
                      } else if (state is ChatLoading) {
                        return const TLoader();
                      }
                      return Container();
                    },
                  ),
                  const Spacer(),
                  chatTypeMessageWidget(
                    messageTextController,
                    () => chatBloc.add(ChatSendMessageEvent(SendMessageParams(user: "", message: "HêlHeeloo "))),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:spa_mobile/features/home/domain/usecases/send_message.dart';
// import 'package:spa_mobile/features/home/presentation/blocs/chat/chat_bloc.dart';
// import 'package:spa_mobile/init_dependencies.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key, required this.channelId});
//
//   final String channelId;
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   late final ChatBloc chatBloc;
//   late final ScrollController _scrollController;
//   late final TextEditingController _messageController;
//   bool _isDisposed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     chatBloc = serviceLocator<ChatBloc>();
//     _scrollController = ScrollController();
//     _messageController = TextEditingController();
//     _connectToChat();
//   }
//
//   void _connectToChat() {
//     if (_isDisposed) return;
//     chatBloc.add(ChatConnectEvent());
//     // Sử dụng Future.microtask thay vì addPostFrameCallback
//     Future.microtask(() {
//       if (!_isDisposed && !chatBloc.isClosed) {
//         chatBloc.add(ChatConnectEvent());
//       }
//     });
//   }
//
//   void _sendMessage() {
//     if (_messageController.text.trim().isEmpty || _isDisposed) return;
//
//     final params = SendMessageParams(
//       user: "",
//       message: _messageController.text,
//     );
//
//     if (!chatBloc.isClosed) {
//       chatBloc.add(ChatSendMessageEvent(params));
//       _messageController.clear();
//     }
//   }
//
//   @override
//   void dispose() {
//     _isDisposed = true;
//
//     // Đóng các controller trước
//     _messageController.dispose();
//     _scrollController.dispose();
//
//     // Kiểm tra trước khi thêm event disconnect
//     if (!chatBloc.isClosed) {
//       chatBloc.add(ChatDisconnectEvent());
//       chatBloc.close();
//     }
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chat - ${widget.channelId}')),
//       body: BlocProvider.value(
//         value: chatBloc,
//         child: Column(
//           children: [
//             Expanded(
//               child: BlocBuilder<ChatBloc, ChatState>(
//                 builder: (context, state) {
//                   if (state is ChatLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   if (state is ChatError) {
//                     return Center(child: Text(state.error));
//                   }
//
//                   if (state is ChatLoaded) {
//                     return ListView.builder(
//                       controller: _scrollController,
//                       itemCount: state.messages.length,
//                       itemBuilder: (context, index) {
//                         final message = state.messages[index];
//                         // return ChatMessageBubble(
//                         //   message: message,
//                         //   isMe: message.userId == widget.userId,
//                         // );
//                       },
//                     );
//                   }
//
//                   return const SizedBox();
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                       ),
//                       onSubmitted: (_) => _sendMessage(),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
