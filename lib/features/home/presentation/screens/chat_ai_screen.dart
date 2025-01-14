import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/common/widgets/rounded_container.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/common/widgets/show_snackbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/home/data/models/message_chat.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_ai_chat.dart';
import 'package:spa_mobile/features/home/presentation/blocs/ai_chat/ai_chat_bloc.dart';

class ChatAiScreen extends StatefulWidget {
  const ChatAiScreen({super.key});

  @override
  State<ChatAiScreen> createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> with WidgetsBindingObserver {
  final _messageController = TextEditingController();

  final List<MessageChatModel> messages = [];

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          messages.add(MessageChatModel(
            text: AppLocalizations.of(context)!.chat_bot_help,
            isUser: false,
          ));
        });
      }
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiChatBloc, AiChatState>(
      listener: (context, state) {
        if (state is AiChatLoaded) {
          messages.add(MessageChatModel(text: state.message, isUser: false));
        } else if (state is AiChatError) {
          TSnackBar.errorSnackBar(context, message: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: TAppbar(
            showBackArrow: true,
            title: Text(
              AppLocalizations.of(context)!.solaceChat,
              style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black),
            ),
          ),
          body: ListView.builder(
            controller: _scrollController,
            itemCount: messages.length + 1,
            padding: const EdgeInsets.all(TSizes.sm),
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == messages.length) {
                if (state is AiChatLoading) {
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
              } else {
                final message = messages[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Row(
                    mainAxisAlignment: message.isUser == true ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(TSizes.sm),
                        decoration: BoxDecoration(
                          color: message.isUser == false ? TColors.primary : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: THelperFunctions.screenWidth(context) * 0.85,
                          ),
                          child: Text(
                            message.text,
                            style: Theme.of(context).textTheme.bodyMedium,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return null;
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
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Enter your message ...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      autofocus: true,
                      onTap: () {
                        _scrollToBottom();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: TSizes.sm,
                  ),
                  TRoundedIcon(
                    onPressed: () {
                      setState(() {
                        messages.add(MessageChatModel(text: _messageController.text.toString(), isUser: true));

                        context.read<AiChatBloc>().add(GetAiChatEvent(GetAiChatParams(
                              _messageController.text.toString(),
                            )));
                        FocusScope.of(context).unfocus();
                        _messageController.clear();
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
      },
    );
  }
}
