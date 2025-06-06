import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/home/data/datasources/chat_remote_data_source.dart';
import 'package:spa_mobile/features/home/data/repositories/chat_repository_impl.dart';
import 'package:spa_mobile/features/home/domain/repositories/chat_repository.dart';
import 'package:spa_mobile/features/home/domain/usecases/connect_hub.dart';
import 'package:spa_mobile/features/home/domain/usecases/disconnect_hub.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_channel.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_list_message.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_message.dart';
import 'package:spa_mobile/features/home/domain/usecases/send_message.dart';
import 'package:spa_mobile/features/home/presentation/blocs/channel/channel_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/chat/chat_bloc.dart';
import 'package:spa_mobile/features/home/presentation/blocs/list_message/list_message_bloc.dart';
import 'package:spa_mobile/features/home/presentation/widgets/chat_message_list.dart';
import 'package:spa_mobile/features/home/presentation/widgets/chat_type_message.dart';
import 'package:spa_mobile/init_dependencies.dart';

class WrapperChatRoom extends StatelessWidget {
  const WrapperChatRoom({
    super.key,
    required this.channelId,
    required this.userId,
  });

  final String channelId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListMessageBloc(getListMessage: serviceLocator()),
      child: ChatScreen(channelId: channelId, userId: userId),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.channelId, required this.userId});

  final String channelId;
  final String userId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatBloc chatBloc;
  ScrollController chatListScrollController = ScrollController();
  TextEditingController messageTextController = TextEditingController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatListScrollController.hasClients) {
        chatListScrollController.animateTo(
          chatListScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutSine,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize chatBloc first

    // Load local data
    _loadLocalData();
    _initAiChat(widget.userId);
    chatBloc = ChatBloc(
      getMessages: serviceLocator(),
      sendMessage: serviceLocator(),
      connect: serviceLocator(),
      disconnect: serviceLocator(),
    );
    context.read<ListMessageBloc>().add(GetListMessageEvent(GetListMessageParams(widget.channelId)));

    chatBloc.add(ChatConnectEvent());
    // context.read<ChatBloc>().add(StartListeningEvent());
    _scrollToBottom();
  }

  void _loadLocalData() async {}

  Future<void> _initAiChat(String userId) async {
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
    serviceLocator
      ..registerLazySingleton<ChatRemoteDataSource>(
        () => SignalRChatRemoteDataSource(
          hubUrl: "https://solaceapi.ddnsking.com/chat",
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

  @override
  void dispose() {
    chatListScrollController.dispose();
    messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChannelBloc(getChannel: serviceLocator(), getChannelByAppointment: serviceLocator())
        ..add(GetChannelEvent(GetChannelParams(widget.channelId))),
      child: BlocProvider.value(
        value: chatBloc,
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatError) {
              TSnackBar.errorSnackBar(context, message: state.error);
              AppLogger.info(state.error);
            }

            if (state is ChatLoaded && state.messages.isNotEmpty) {
              final latestMessage = state.messages.last;
              AppLogger.info("Forwarding message to ListMessageBloc: ${latestMessage.content}");
              context.read<ListMessageBloc>().add(ListMessageNewMessageEvent(latestMessage));
              _scrollToBottom();
            }
          },
          child: BlocBuilder<ChannelBloc, ChannelState>(
            builder: (context, channelState) {
              if (channelState is ChannelLoaded) {
                return Scaffold(
                  appBar: TAppbar(
                    showBackArrow: true,
                    title: Text(channelState.channel.name),
                  ),
                  backgroundColor: Colors.white,
                  body: Column(
                    children: [
                      BlocBuilder<ListMessageBloc, ListMessageState>(
                        builder: (context, state) {
                          if (state is ListMessageLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is ListMessageLoaded) {
                            _scrollToBottom();
                            final sortedMessages = state.messages..sort((a, b) => a.timestamp.compareTo(b.timestamp));
                            return Expanded(
                              child: chatMessageWidget(
                                  chatListScrollController, sortedMessages, widget.userId, channelState.channel.memberDetails!),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                  bottomNavigationBar: Padding(
                    padding: EdgeInsets.only(
                      left: TSizes.sm,
                      right: TSizes.sm,
                      top: TSizes.sm,
                      bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.sm,
                    ),
                    child: chatTypeMessageWidget(messageTextController, () {
                      chatBloc.add(ChatSendMessageEvent(
                        SendMessageParams(
                          channelId: widget.channelId,
                          senderId: widget.userId,
                          messageType: 'text',
                          content: messageTextController.text.trim(),
                        ),
                      ));

                      messageTextController.clear();
                    }, () => _scrollToBottom()),
                  ),
                );
              } else if (channelState is ChannelLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Scaffold(
                body: Center(
                  child: Text(
                    AppLocalizations.of(context)!.cannot_fetch_info,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
