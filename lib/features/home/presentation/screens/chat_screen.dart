import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/screens/error_screen.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_list_message.dart';
import 'package:spa_mobile/features/home/domain/usecases/send_message.dart';
import 'package:spa_mobile/features/home/presentation/blocs/chat/chat_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/list_message/list_message_bloc.dart';
import 'package:spa_mobile/features/home/presentation/widgets/chat_message_list.dart';
import 'package:spa_mobile/features/home/presentation/widgets/chat_type_message.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperChatRoom extends StatelessWidget {
  const WrapperChatRoom({super.key, required this.channelId});

  final String channelId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListMessageBloc(getListMessage: serviceLocator()),
      child: ChatScreen(channelId: channelId),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.channelId});

  final String channelId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserChatModel? userChatModel;
  late ChatBloc chatBloc;
  ScrollController chatListScrollController = ScrollController();
  TextEditingController messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocalData();
    chatBloc = ChatBloc(
      getMessages: serviceLocator(),
      sendMessage: serviceLocator(),
      connect: serviceLocator(),
      disconnect: serviceLocator(),
    );
    chatBloc.add(ChatConnectEvent());
    context.read<ListMessageBloc>().add(GetListMessageEvent(GetListMessageParams(widget.channelId)));
  }

  void _loadLocalData() async {
    final jsonUserChat = await LocalStorage.getData(LocalStorageKey.userChat);
    if (jsonUserChat != null && jsonUserChat.isNotEmpty) {
      try {
        userChatModel = UserChatModel.fromJson(jsonDecode(jsonUserChat));
      } catch (e) {
        debugPrint('Lỗi parsing userChatModel: $e');
        goLoginNotBack();
      }
      return;
    }
  }

  @override
  void dispose() {
    chatBloc.add(ChatDisconnectEvent());
    chatListScrollController.dispose();
    messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: chatBloc,
      child: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            TSnackBar.errorSnackBar(context, message: state.error);
          }

          if (state is ChatLoaded && state.messages.isNotEmpty) {
            final latestMessage = state.messages.last;
            context.read<ListMessageBloc>().add(ListMessageNewMessageEvent(latestMessage));
          }
        },
        child: Scaffold(
          appBar: TAppbar(showBackArrow: true),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              BlocBuilder<ListMessageBloc, ListMessageState>(
                builder: (context, state) {
                  if (state is ListMessageLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ListMessageError) {
                    return Center(child: Text(state.message));
                  } else if (state is ListMessageLoaded) {
                    final sortedMessages = state.messages..sort((a, b) => a.timestamp.compareTo(b.timestamp));
                    return chatMessageWidget(chatListScrollController, sortedMessages, userChatModel?.id ?? "");
                  }
                  return TErrorBody();
                },
              ),
              const Spacer(),
              chatTypeMessageWidget(
                messageTextController,
                () {
                  chatBloc.add(ChatSendMessageEvent(
                    SendMessageParams(
                      channelId: widget.channelId,
                      senderId: userChatModel?.id ?? "",
                      content: messageTextController.text.trim(),
                    ),
                  ));

                  messageTextController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
