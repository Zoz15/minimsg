import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/model/proriles_model.dart';
import 'package:minimsg/core/widgets/circel_profile.dart';
import 'package:minimsg/features/DM_chat_screen/controllers/dm_chat_controller.dart';
import 'package:minimsg/features/DM_chat_screen/widgets/bottom_sheet.dart';
import 'package:minimsg/features/DM_chat_screen/widgets/messages_list.dart';
import 'package:minimsg/features/DM_chat_screen/widgets/message_input.dart';
import 'package:minimsg/features/profile_screen/profile_screen.dart';

class DMChatScreen extends StatefulWidget {
  final String chatId;
  final String myUserId;
  final Map<String, dynamic> userdata;

  const DMChatScreen({
    super.key,
    required this.chatId,
    required this.myUserId,
    required this.userdata,
  });

  @override
  State<DMChatScreen> createState() => _DMChatScreenState();
}

class _DMChatScreenState extends State<DMChatScreen> {
  late final DMChatController controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller in initState
    controller = Get.put<DMChatController>(
      DMChatController(
        chatId: widget.chatId,
        myUserId: widget.myUserId,
        otherUserId: widget.userdata[ProfilesModel.id],
      ),
      tag: widget.chatId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 10,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                  onPressed: () => Get.back(),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => openUserProfile(),
                    child: Row(
                      children: [
                        CircleProfile(
                          50,
                          widget.userdata[ProfilesModel.background_color],
                          widget.userdata[ProfilesModel.emoji],
                          ifShadowBig: false,
                          animation: false,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userdata[ProfilesModel.username],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "@${widget.userdata[ProfilesModel.username_unique]}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                bottomSheet(
                  context,
                  onDeleteChat: () {
                    controller.deleteChat();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Obx(() {
                if (controller.messages.isEmpty && !controller.isNewChat) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleProfile(
                          100,
                          widget.userdata[ProfilesModel.background_color],
                          widget.userdata[ProfilesModel.emoji],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          widget.userdata[ProfilesModel.username],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start a new conversation',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.withOpacity(0.1),
                                Colors.purple.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.purple[300],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Send your first message',
                                style: TextStyle(
                                  color: Colors.purple[300],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return MessagesList(
                  messages: controller.messages,
                  myUserId: widget.myUserId,
                  scrollController: controller.scrollController,
                );
              }),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: MessageInput(
              controller: controller.messageController,
              onSend: controller.sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controller when widget is disposed
    Get.delete<DMChatController>(tag: widget.chatId);
    super.dispose();
  }

  void openUserProfile() {
    Get.to(
      () =>
          BuildProfileScreen(isNotYourProfile: true, profile: widget.userdata),
    );
  }
}
