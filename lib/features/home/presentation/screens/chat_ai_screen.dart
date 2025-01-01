import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';

class ChatAiScreen extends StatefulWidget {
  const ChatAiScreen({super.key});

  @override
  State<ChatAiScreen> createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen>
    with WidgetsBindingObserver {
  final _messageController = TextEditingController();
  final List<Map<String, String>> messages = [
    {
      "text":
          "Hello! How can I assist you today?Hello! How can I assist you today?Hello! How can I assist you today?",
      "isUser": "false"
    },
    {"text": "Hi! I need help with my booking.", "isUser": "true"},
    {"text": "Sure! What is the booking number?", "isUser": "false"},
    {"text": "It's 12345.", "isUser": "true"},
    {
      "text": "Alright, I found it. How can I assist you with it?",
      "isUser": "false"
    },
    {"text": "I need to reschedule it.", "isUser": "true"},
    {
      "text": "No problem. I will update the schedule for you.",
      "isUser": "false"
    },
    {"text": "Thank you!", "isUser": "true"},
    {"text": "You're welcome!", "isUser": "false"},
    {"text": "Have a great day!", "isUser": "true"},
    {"text": "Have a great day!", "isUser": "true"},
    {"text": "Have a great day!", "isUser": "true"},
    {"text": "Have a great day!", "isUser": "true"},
    {"text": "Have a great day!", "isUser": "true"},
    {"text": "Have a great day!", "isUser": "true"},
    {"text": "Have a great day!", "isUser": "true"},
    {"text": "Have a great day!", "isUser": "true"},
  ];
  final ScrollController _scrollController = ScrollController();

  final FocusNode _focusNode = FocusNode();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutSine,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        showBackArrow: true,
        title: Text(
          AppLocalizations.of(context)!.solaceChat,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .apply(color: TColors.black),
        ),
        actions: const [],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: messages.length + 1,
        padding: const EdgeInsets.all(TSizes.sm),
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == messages.length) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Lottie.asset(
                  TImages.chatLoading,
                  width: THelperFunctions.screenWidth(context) * 0.1,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ],
            );
          }
          final message = messages[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              mainAxisAlignment: message['isUser'] == 'true'
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: BoxDecoration(
                    color: message['isUser'] == 'true'
                        ? TColors.primary
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: THelperFunctions.screenWidth(context) * 0.85,
                    ),
                    child: Text(
                      message['text']!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: TSizes.sm,
          right: TSizes.sm,
          top: TSizes.sm,
          bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.sm,
        ),
        child: TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.sm),
          shadow: true,
          child: Row(
            children: [
              TRoundedIcon(
                onPressed: () {
                  setState(() {
                    FocusScope.of(context).unfocus();
                    _scrollToBottom();
                  });
                },
                icon: Iconsax.image,
                backgroundColor: TColors.primary.withOpacity(0.7),
              ),
              const SizedBox(
                width: TSizes.sm,
              ),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _messageController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Enter your message ...",
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: TSizes.sm),
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autofocus: true,
                  onTap: () {
                    _scrollToBottom();
                  },
                  onSubmitted: (value) {
                    setState(() {
                      messages.add({
                        "text": _messageController.text,
                        "isUser": "true",
                      });
                      _messageController.clear();
                      _scrollToBottom();
                    });
                  },
                ),
              ),
              const SizedBox(
                width: TSizes.sm,
              ),
              TRoundedIcon(
                onPressed: () {
                  setState(() {
                    messages.add({
                      "text": _messageController.text,
                      "isUser": "true",
                    });
                    _messageController.clear();
                    FocusScope.of(context).unfocus();
                    _scrollToBottom();
                  });
                },
                icon: Iconsax.send_2,
                backgroundColor: TColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
