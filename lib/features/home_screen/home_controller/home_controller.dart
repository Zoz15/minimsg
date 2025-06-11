import 'package:get/get.dart';
import 'package:minimsg/core/funchion/save_my_profile_in_cach.dart';
import 'package:minimsg/features/chat_screen/presentation/model/profile_var_model.dart';
import 'package:minimsg/features/home_screen/widgets/widget_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final profile = Rx<ProfileVarModel?>(null);
  final RxString selectedIndex = WidgetModel.chat.obs;

  @override
  void onInit() {
    super.onInit();
    getProfileFromCach();
  }

  Future<void> getProfileFromCach() async {
    final isSaved = await MyProfileCache.isProfileSaved();
    if (isSaved) {
      final profile = await MyProfileCache.getProfile();
      this.profile.value = profile;
    } else {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final profile = await MyProfileCache.getAndSaveProfile();
        this.profile.value = profile;
      }
    }
  }

  void updateSelectedIndex(String index) {
    /*
    * chat = Chat
    * call = Call
    * profile = Profile
    */
    selectedIndex.value = index;
  }
}
