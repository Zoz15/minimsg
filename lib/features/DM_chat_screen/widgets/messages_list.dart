import 'package:flutter/material.dart';
import 'package:minimsg/core/model/massages_model.dart';
import 'package:minimsg/features/DM_chat_screen/widgets/message_bubble.dart';

class MessagesList extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  final String myUserId;
  final ScrollController scrollController;

  const MessagesList({
    super.key,
    required this.messages,
    required this.myUserId,
    required this.scrollController,
  });

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void didUpdateWidget(MessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final msg = widget.messages[index];
        final isMe = msg[MassagesModel.sender] == widget.myUserId;

        return MessageBubble(message: msg[MassagesModel.content], isMe: isMe);
      },
    );
  }
}
