import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/funchion/get_or_creat_chat_id.dart';
import 'package:minimsg/features/DM_chat_screen/DM_screen.dart';
import 'package:minimsg/features/profile_screen/profile_screen.dart';
import 'package:minimsg/features/search_screen/search_controller.dart';
import 'package:minimsg/features/search_screen/widgets/build_header.dart';
import 'package:minimsg/features/search_screen/widgets/build_search_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BuildSearchScreen extends StatelessWidget {
  final Search_Controller controller = Get.put(Search_Controller());

  BuildSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: Column(
          children: [
            SafeArea(bottom: false, child: buildHeader(controller)),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.pinkAccent.shade400,
                          strokeWidth: 2,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading users...',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return buildSearchContent(controller);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> openUserProfile(String userId) async {
  try {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(
          color: Colors.pinkAccent.shade400,
          strokeWidth: 2,
        ),
      ),
      barrierDismissible: false,
    );

    final profile = await getUserProfileById(userId);
    Get.back(); // Close loading dialog

    if (profile != null) {
      Get.to(
        () => BuildProfileScreen(isNotYourProfile: true, profile: profile),
        duration: const Duration(milliseconds: 300), // Faster transition
        transition: Transition.fadeIn,
      );
    } else {
      Get.snackbar(
        'Error',
        'Could not load user profile',
        // ignore: deprecated_member_use
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.back(); // Close loading dialog
    Get.snackbar(
      'Error',
      'Something went wrong',
      // ignore: deprecated_member_use
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}

Future<Map<String, dynamic>?> getUserProfileById(String userId) async {
  final response =
      await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

  return response;
}

Future<void> startChat(String userId) async {
  try {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(
          color: Colors.pinkAccent.shade400,
          strokeWidth: 2,
        ),
      ),
      barrierDismissible: false,
    );

    final myId = Supabase.instance.client.auth.currentUser?.id;
    if (myId == null) {
      Get.back();
      Get.snackbar(
        'Error',
        'You must be logged in to start a chat',
        // ignore: deprecated_member_use
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    final chatId = await getExistingChat(myId, userId);
    Get.back(); // Close loading dialog

    if (chatId != null) {
      Get.to(
        () => DMChatScreen(
          chatId: chatId,
          myUserId: myId,
          userdata: Get.find<Search_Controller>().userdata,
        ),
        duration: const Duration(milliseconds: 200), // Faster transition
        transition: Transition.fadeIn,
      );
    } else {
      Get.snackbar(
        'Error',
        'Could not create chat',
        // ignore: deprecated_member_use
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.back(); // Close loading dialog
    Get.snackbar(
      'Error',
      'Something went wrong',
      // ignore: deprecated_member_use
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
