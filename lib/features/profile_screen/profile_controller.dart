import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/funchion/get_or_creat_chat_id.dart';
import 'package:minimsg/core/funchion/save_my_profile_in_cach.dart';
import 'package:minimsg/features/DM_chat_screen/DM_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isUpdateScreen = false.obs;
  final bool isNotYourProfile;
  final Rx<Map<String, dynamic>?> profileDataa;

  ProfileController({
    this.isNotYourProfile = false,
    Rx<Map<String, dynamic>?>? profileDataa,
  }) : profileDataa = profileDataa ?? Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    if (isNotYourProfile) {
      // For other user's profile, fetch from Supabase
      isLoading.value = false;
    } else {
      // For own profile, load from cache
      loadProfileFromCache();
    }
  }

  Future<void> loadProfileFromCache() async {
    try {
      isLoading.value = true;
      final isSaved = await MyProfileCache.isProfileSaved();
      if (isSaved) {
        final profile = await MyProfileCache.getProfile();
        if (profile != null) {
          profileDataa.value = {
            'id': profile.id,
            'username': profile.username,
            'username_unique': profile.username_unique,
            'email': profile.email,
            'emoji': profile.emoji,
            'background_color': profile.background_color,
            'created_at': profile.created_at,
          };
        }
      } else {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          final profile = await MyProfileCache.getAndSaveProfile();
          if (profile != null) {
            profileDataa.value = {
              'id': profile.id,
              'username': profile.username,
              'username_unique': profile.username_unique,
              'email': profile.email,
              'emoji': profile.emoji,
              'background_color': profile.background_color,
              'created_at': profile.created_at,
            };
          }
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isUpdateScreen.value = true;
      await MyProfileCache.clearCache();
      final profile = await MyProfileCache.getAndSaveProfile();
      if (profile != null) {
        profileDataa.value = {
          'id': profile.id,
          'username': profile.username,
          'username_unique': profile.username_unique,
          'email': profile.email,
          'emoji': profile.emoji,
          'background_color': profile.background_color,
          'created_at': profile.created_at,
        };
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdateScreen.value = false;
    }
  }

  Future<void> startChat(String userId) async {
    String myId = '';
    if (MyProfileCache.myProfile.id.isNotEmpty &&
        MyProfileCache.myProfile.id != '') {
      myId = MyProfileCache.myProfile.id;
      MyProfileCache.getAndSaveProfile();
    } else {
      myId = Supabase.instance.client.auth.currentUser?.id ?? '';
    }

    final chatId = await getExistingChat(myId, userId);
    Get.to(
      () => DMChatScreen(
        chatId: chatId ?? 'new_chat',
        myUserId: myId,
        userdata: profileDataa.value!,
      ),
    );
  }
}
