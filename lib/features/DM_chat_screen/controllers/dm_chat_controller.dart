import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:minimsg/core/model/massages_model.dart';
import 'package:minimsg/core/model/chats_model.dart';
import 'package:minimsg/core/funchion/get_or_creat_chat_id.dart';
import 'package:uuid/uuid.dart';

class DMChatController extends GetxController {
  final supabase = Supabase.instance.client;
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  RealtimeChannel? channel;

  // Make messages observable
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  final String chatId;
  final String myUserId;
  final String otherUserId;

  bool isNewChat = false;

  DMChatController({
    required this.chatId,
    required this.myUserId,
    required this.otherUserId,
  });

  @override
  void onInit() {
    super.onInit();
    print(
      'DMChatController initialized with chatId: $chatId, myUserId: $myUserId',
    );
    initializeMessages();
  }

  Future<void> initializeMessages() async {
    try {
      print('Initializing messages for chat: $chatId');

      // Load initial messages
      await loadMessages();

      // Subscribe to realtime changes
      print('Setting up realtime subscription...');
      channel =
          supabase.channel('messages')
            ..onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: MassagesModel.table,
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'chat_id',
                value: chatId,
              ),
              callback: (payload) async {
                print('🔔 Realtime update received');
                print('Event Type: ${payload.eventType}');

                final newMessage = payload.newRecord;
                final senderId = newMessage[MassagesModel.sender];
                final content = newMessage[MassagesModel.content];

                print('My user ID: $myUserId | Sender ID: $senderId');

                if (payload.eventType == PostgresChangeEvent.insert) {
                  if (senderId == myUserId) {
                    print('📤 You sent a new message: "$content"');
                  } else {
                    print(
                      '📥 New message received from user $senderId: "$content"',
                    );
                  }

                  // Update message list
                  final updatedMessages = [...messages, newMessage];
                  updatedMessages.sort(
                    (a, b) => a[MassagesModel.createdAt].compareTo(
                      b[MassagesModel.createdAt],
                    ),
                  );
                  if (updatedMessages.isNotEmpty) {
                    messages.value = updatedMessages;
                    scrollToBottom();
                  } else {
                    isNewChat = true;
                  }
                }
              },
            )
            ..subscribe((status, err) {
              print('Channel subscription status: $status');
              if (err != null) {
                print('Channel subscription error: $err');
              }
            });
      print('Realtime subscription setup complete');
    } catch (e, stackTrace) {
      print('Error initializing messages: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'Error loading messages: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadMessages() async {
    try {
      print('🔄 Loading messages...');
      final result = await supabase
          .from(MassagesModel.table)
          .select()
          .eq(MassagesModel.chatId, chatId)
          .order(MassagesModel.createdAt, ascending: true);

      print('📨 Loaded ${result.length} messages');
      messages.value = List.from(result);
      scrollToBottom();
    } catch (e, stackTrace) {
      print('Error loading messages: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      String currentChatId = chatId;

      // If this is a new chat, create it first
      if (isNewChat) {
        currentChatId = await createNewChat(myUserId, otherUserId);
      }

      final uuid = Uuid();
      final messageData = {
        MassagesModel.id: uuid.v4(),
        MassagesModel.chatId: currentChatId,
        MassagesModel.sender: myUserId,
        MassagesModel.content: text,
        MassagesModel.createdAt: DateTime.now().toIso8601String(),
        MassagesModel.delivered: false,
      };

      print('📤 Sending message: "$text"');

      await supabase.from(MassagesModel.table).insert(messageData);
      messageController.clear();
    } catch (e, stackTrace) {
      print('Send Error: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'Error sending message: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> deleteChat() async {
    try {
      // Delete all messages in the chat
      await supabase
          .from(MassagesModel.table)
          .delete()
          .eq(MassagesModel.chatId, chatId);

      // Delete the chat itself
      await supabase.from(ChatsModel.table).delete().eq(ChatsModel.id, chatId);

      Get.back(); // Go back to previous screen
    } catch (e) {
      print('Error deleting chat: $e');
      Get.snackbar(
        'Error',
        'Failed to delete chat',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    print('Disposing DMChatController...');
    channel?.unsubscribe();
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
