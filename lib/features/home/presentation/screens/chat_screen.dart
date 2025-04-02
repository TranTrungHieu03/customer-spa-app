import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/widgets/loader.dart';
import 'package:spa_mobile/features/home/presentation/blocs/chat/chat_bloc.dart';
import 'package:spa_mobile/features/home/presentation/widgets/chat_message_list.dart';
import 'package:spa_mobile/features/home/presentation/widgets/chat_type_message.dart';
import 'package:spa_mobile/init_dependencies.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController chatListScrollController = ScrollController();
  TextEditingController messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider<ChatBloc>(
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
                    return const TLoader();
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
