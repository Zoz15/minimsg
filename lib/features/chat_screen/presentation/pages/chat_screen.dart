import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/features/chat_screen/presentation/controllers/chat_controller.dart';
import 'package:minimsg/features/chat_screen/presentation/widgets/build_chats.dart';
import 'package:minimsg/features/chat_screen/presentation/widgets/build_recent_text.dart';
import 'package:minimsg/features/chat_screen/presentation/widgets/build_storys.dart';
import 'package:minimsg/features/chat_screen/presentation/widgets/build_top_bar.dart';
import 'package:minimsg/features/home_screen/home_controller/home_controller.dart';

class BuildChatScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final HomeController homeController;
  BuildChatScreen({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        buildTopBar(homeController),
        const SizedBox(height: 20),
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [buildStorys(chatController), buildRecentChat()],
              ),
              Positioned.fill(
                child: Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(
                      top: chatController.isExpanded.value ? 0 : 200,
                    ),
                    child: buildChats(
                      chatController: chatController,
                      scrollController: chatController.scrollController,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
