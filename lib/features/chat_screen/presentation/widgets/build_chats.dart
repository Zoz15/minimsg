import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/funchion/save_my_profile_in_cach.dart';
import 'package:minimsg/core/model/chats_model.dart';
import 'package:minimsg/core/widgets/circel_profile.dart';
import 'package:minimsg/features/DM_chat_screen/DM_screen.dart';
import 'package:minimsg/features/chat_screen/presentation/controllers/chat_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class buildChats extends StatelessWidget {
  const buildChats({
    super.key,
    required this.chatController,
    this.scrollController,
  });

  final ChatController chatController;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child:
              chatController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : chatController.chats.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No chats yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start a conversation with someone',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: chatController.chats.length,
                    itemBuilder: (context, index) {
                      final chat = chatController.chats[index];
                      final otherUser = chat['other_user'];
                      final lastMessage = chat['last_message'];
                      final sendedAt = DateTime.parse(
                        chat[ChatsModel.createdAt],
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Get.to(
                              () => DMChatScreen(
                                chatId: chat[ChatsModel.id],
                                myUserId: MyProfileCache.myProfile.id,
                                userdata: otherUser,
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleProfile(
                            50,
                            otherUser['background_color'],
                            otherUser['emoji'],
                            animation: false,
                          ),
                          title: Text(
                            otherUser['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            lastMessage != null
                                ? lastMessage['content']
                                : 'Start a conversation',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text(
                            timeago.format(sendedAt),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
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
