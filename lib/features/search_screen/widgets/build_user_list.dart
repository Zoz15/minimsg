import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/app_core.dart';
import 'package:minimsg/core/model/proriles_model.dart';
import 'package:minimsg/core/widgets/circel_profile.dart';
import 'package:minimsg/features/search_screen/search_controller.dart';
import 'package:minimsg/features/search_screen/search_page.dart';
import 'package:minimsg/features/search_screen/widgets/build_chat_button.dart';
import 'package:minimsg/features/search_screen/widgets/build_user_info.dart';

Widget buildUserList(Search_Controller controller) {
  return Obx(() {
    if (controller.isLoading.value) {
      return Center(
        child: CircularProgressIndicator(
          color: AppCore.primaryColor,
          strokeWidth: 2,
        ),
      );
    }

    final filteredUsers = controller.filteredUsers;

    if (filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return buildUserListItem(user, controller);
      },
    );
  });
}

Widget buildUserListItem(
  Map<String, dynamic> user,
  Search_Controller controller,
) {
  final emoji = user[ProfilesModel.emoji];
  final backgroundColor = user[ProfilesModel.background_color];
  final userId = user[ProfilesModel.id];

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        controller.userdata = user;
        openUserProfile(userId);
      },
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'profile_$userId',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleProfile(65, backgroundColor, emoji),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Hero(
                tag: 'info_$userId',
                child: Material(
                  color: Colors.transparent,
                  child: buildUserInfo(user),
                ),
              ),
            ),
            const SizedBox(width: 12),
            buildChatButton(() {
              controller.userdata = user;
              startChat(userId);
            }),
          ],
        ),
      ),
    ),
  );
}
