import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/chat/chat_bloc.dart';
import 'package:spa_mobile/features/home/presentation/widgets/chat_message_list.dart';
import 'package:spa_mobile/features/home/presentation/widgets/chat_type_message.dart';
import 'package:spa_mobile/init_dependencies.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController chatListScrollController = ScrollController();
  TextEditingController messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) =>
          ChatBloc(getMessages: serviceLocator(), sendMessage: serviceLocator(), connect: serviceLocator(), disconnect: serviceLocator())
            ..add(ChatConnectEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              // chatAppbarWidget(size, context),
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoaded) {
                    return chatMessageWidget(chatListScrollController, state.messages, 1);
                  } else if (state is ChatError) {
                    return Center(child: Text(state.error));
                  } else if (state is ChatLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container();
                },
              ),
              chatTypeMessageWidget(
                messageTextController,
                () => context.read<ChatBloc>().add(
                      ChatSendMessageEvent(
                        messageTextController.text,

                        // context.read<ChatBloc>().currentUserId,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
