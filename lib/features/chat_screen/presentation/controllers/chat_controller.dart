import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/funchion/save_my_profile_in_cach.dart';
import 'package:minimsg/core/model/chats_model.dart';
import 'package:minimsg/core/model/massages_model.dart';
import 'package:minimsg/core/model/proriles_model.dart';
import 'package:minimsg/features/chat_screen/presentation/model/profile_var_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatController extends GetxController {
  final profile = Rx<ProfileVarModel?>(null);
  final isLoading = false.obs;
  final RxList<Map<String, dynamic>> chats = <Map<String, dynamic>>[].obs;
  final RxBool isExpanded = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    print('ChatController initialized');
    MyProfileCache.getAndSaveProfile().then((_) {
      loadChats();
      listenForNewMessages();
    });
    scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (chats.length < 5) {
      isExpanded.value = false;
      return;
    }

    if (scrollController.offset > 100 && !isExpanded.value) {
      isExpanded.value = true;
    } else if (scrollController.offset < 50 && isExpanded.value) {
      isExpanded.value = false;
    }
  }

  void listenForNewMessages() {
    final supabase = Supabase.instance.client;
    // final channel =
    supabase.channel('messages')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: MassagesModel.table,
        callback: (payload) {
          final newMessage = payload.newRecord;
          final chatId = newMessage[MassagesModel.chatId];
          final content = newMessage[MassagesModel.content];
          final senderId = newMessage[MassagesModel.sender];

          print('📨 New message in chat: $chatId from $senderId: $content');

          // TODO: حدّث الـ chat preview في الـ home screen
          // updateChatPreview(chatId, newMessage);
          loadChats();
        },
      )
      ..subscribe();
  }

  Future<void> loadChats() async {
    try {
      isLoading.value = true;
      final allChats = await getAllChats();
      chats.value = allChats;
      // print('Chats loaded: ${chats.value}');
    } catch (e) {
      print('Error loading chats: $e');
      Get.snackbar(
        'Error',
        'Failed to load chats',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllChats() async {
    try {
      final myId = MyProfileCache.myProfile.id;
      if (myId == '') return [];

      // Get all chats where the user is either user1 or user2
      final chats = await Supabase.instance.client
          .from(ChatsModel.table)
          .select()
          .or('${ChatsModel.user1Id}.eq.$myId,${ChatsModel.user2Id}.eq.$myId');
      // .order(ChatsModel.createdAt, ascending: false);
      // final messages = await Supabase.instance.client
      //     .from(MassagesModel.table)
      //     .select()
      //     .eq(MassagesModel.chatId, chats[ChatsModel.id]);
      // // .order(ChatsModel.createdAt, ascending: false);

      final List<Map<String, dynamic>> formattedChats = [];

      for (var chat in chats) {
        // Get the other user's ID
        final otherUserId =
            chat[ChatsModel.user1Id] == myId
                ? chat[ChatsModel.user2Id]
                : chat[ChatsModel.user1Id];

        // Get the other user's profile
        final otherUser =
            await Supabase.instance.client
                .from(ProfilesModel.table)
                .select()
                .eq(ProfilesModel.id, otherUserId)
                .single();

        // Get the last message for this chat
        final messages = await Supabase.instance.client
            .from(MassagesModel.table)
            .select()
            .eq(MassagesModel.chatId, chat[ChatsModel.id])
            .order(MassagesModel.createdAt, ascending: false)
            .limit(1);

        if (messages.isEmpty) {
          continue;
        }

        if (messages[0][MassagesModel.content] == null) {
          // todo delete chat from supabase
          await Supabase.instance.client
              .from(ChatsModel.table)
              .delete()
              .eq(ChatsModel.id, chat[ChatsModel.id]);
          continue;
        }

        print('Messages for chat ${chat[ChatsModel.id]}:  $messages');

        formattedChats.add({
          ChatsModel.id: chat[ChatsModel.id],
          ChatsModel.createdAt: messages[0][MassagesModel.createdAt],
          'other_user': otherUser,
          'last_message': messages[0],
        });
      }

      formattedChats.sort((a, b) {
        final aTime =
            a['last_message']?[MassagesModel.createdAt] ??
            a[ChatsModel.createdAt];
        final bTime =
            b['last_message']?[MassagesModel.createdAt] ??
            b[ChatsModel.createdAt];
        return bTime.compareTo(aTime); // الأحدث أولاً
      });

      return formattedChats;
    } catch (e) {
      print('Error fetching chats: $e');
      return [];
    }
  }

  final stories =
      [
        {'name': 'Yoga', 'emoji': '🧘'},
        {'name': 'Dono', 'emoji': '🏀'},
        {'name': 'Doni', 'emoji': '💪'},
        {'name': 'Rap', 'emoji': '🎧'},
      ].obs;

  Future<void> getChats() async {
    try {
      isLoading.value = true;
      final userId = Supabase.instance.client.auth.currentUser?.id;
      print('Current user ID: $userId'); // Debug print

      if (userId == null) {
        print('No user ID found'); // Debug print
        return;
      }

      // First get all chats
      final chatsResponse = await Supabase.instance.client
          .from(ChatsModel.table)
          .select()
          .or(
            '${ChatsModel.user1Id}.eq.$userId,${ChatsModel.user2Id}.eq.$userId',
          );

      print('Chats response: $chatsResponse'); // Debug print

      final List<Map<String, dynamic>> formattedChats = [];

      for (var chat in chatsResponse) {
        final otherUserId =
            chat[ChatsModel.user1Id] == userId
                ? chat[ChatsModel.user2Id]
                : chat[ChatsModel.user1Id];

        // Get other user's profile
        final otherUser =
            await Supabase.instance.client
                .from(ProfilesModel.table)
                .select()
                .eq(ProfilesModel.id, otherUserId)
                .single();

        // Get last message for this chat
        final messagesResponse = await Supabase.instance.client
            .from(MassagesModel.table)
            .select()
            .eq(MassagesModel.chatId, chat[ChatsModel.id])
            .order(MassagesModel.createdAt, ascending: false)
            .limit(1);

        print(
          'Messages for chat ${chat[ChatsModel.id]}: $messagesResponse',
        ); // Debug print

        formattedChats.add({
          'chat_id': chat[ChatsModel.id],
          'created_at': chat[ChatsModel.createdAt],
          'other_user': otherUser,
          'last_message':
              messagesResponse.isNotEmpty == true ? messagesResponse[0] : null,
        });
      }

      print('Formatted chats: $formattedChats'); // Debug print
      chats.value = formattedChats;
    } catch (e) {
      print('Error in getChats: $e'); // Debug print
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
