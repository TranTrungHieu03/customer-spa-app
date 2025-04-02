import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/local_storage/local_storage.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_user_chat_info.dart';
import 'package:spa_mobile/features/home/presentation/blocs/user_chat/user_chat_bloc.dart';

// Model to represent a chat conversation
class ChatConversation {
  final String customerName;
  final String lastMessage;
  final DateTime timestamp;
  final bool isUnread;

  ChatConversation({
    required this.customerName,
    required this.lastMessage,
    required this.timestamp,
    this.isUnread = false,
  });
}

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  UserChatModel? userChatModel;
  late int userId;

  // Sample chat conversations (In a real app, this would come from a backend/state management)
  final List<ChatConversation> conversations = [
    ChatConversation(
      customerName: 'John Doe',
      lastMessage: 'Tôi muốn đặt dịch vụ massage',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isUnread: true,
    ),
    ChatConversation(
      customerName: 'Jane Smith',
      lastMessage: 'Cảm ơn nhân viên đã hỗ trợ',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ChatConversation(
      customerName: 'Mike Brown',
      lastMessage: 'Tôi có câu hỏi về gói dịch vụ',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadLocalData();
    _loadListChat();
  }

  void _loadListChat() {}

  void _loadLocalData() async {
    final jsonUserChat = await LocalStorage.getData(LocalStorageKey.userChat);

    if (jsonUserChat != null && jsonUserChat.isNotEmpty) {
      try {
        userChatModel = UserChatModel.fromJson(jsonDecode(jsonUserChat));
        setState(() {});
      } catch (e) {
        debugPrint('Lỗi parsing userChatModel: $e');
        goLoginNotBack();
      }
      return;
    }

    final userJson = await LocalStorage.getData(LocalStorageKey.userKey);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        userId = UserModel.fromJson(jsonDecode(userJson)).userId;
        context.read<UserChatBloc>().add(GetUserChatInfoEvent(GetUserChatInfoParams(userId)));
      } catch (e) {
        goLoginNotBack();
      }
    } else {
      goLoginNotBack();
    }
  }

  // Format timestamp to show relative time
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Vừa xong';
    if (difference.inHours < 1) return '${difference.inMinutes} phút trước';
    if (difference.inDays < 1) return '${difference.inHours} giờ trước';
    if (difference.inDays < 7) return '${difference.inDays} ngày trước';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.info(userChatModel?.id);
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text(
          "Solace Connect",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: ListView.separated(
        itemCount: conversations.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                conversation.customerName[0].toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              conversation.customerName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: conversation.isUnread ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            subtitle: Text(
              conversation.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: conversation.isUnread ? Colors.black87 : Colors.grey,
                  ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTimestamp(conversation.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                if (conversation.isUnread)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            onTap: () {
              // TODO: Navigate to detailed chat screen
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context) => ChatDetailScreen(conversationId: conversation.id)
              // ));
            },
          );
        },
      ),
    );
  }
}
