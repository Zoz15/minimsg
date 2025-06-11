import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minimsg/core/app_core.dart';
import 'package:minimsg/core/funchion/save_my_profile_in_cach.dart';
import 'package:minimsg/core/routes/app_pages.dart';
import 'package:minimsg/core/widgets/circel_profile.dart';
import 'package:minimsg/features/home_screen/home_controller/home_controller.dart';
import 'package:minimsg/features/setup_profile/presentation/setup_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:minimsg/features/profile_screen/profile_controller.dart';

class BuildProfileScreen extends StatelessWidget {
  final bool isNotYourProfile;
  final Map<String, dynamic>? profile;
  final HomeController? homeController;

  const BuildProfileScreen({
    super.key,
    this.homeController,
    this.isNotYourProfile = false,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ProfileController(
        isNotYourProfile: isNotYourProfile,
        profileDataa: Rx<Map<String, dynamic>?>(profile),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Obx(() {
              if (controller.isLoading.value &&
                  controller.profileDataa.value == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppCore.primaryColor),
                );
              }

              if (controller.profileDataa.value == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Profile not found',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildProfileHeader(controller),
                    const SizedBox(height: 20),
                    _buildUserName(controller),
                    const SizedBox(height: 32),
                    if (isNotYourProfile) ...[
                      _buildChatButton(controller),
                      const SizedBox(height: 32),
                    ],
                    _buildProfileInfo(controller),
                    const SizedBox(height: 32),
                    if (!isNotYourProfile) _buildSettingsSection(controller),
                  ],
                ),
              );
            }),
            if (isNotYourProfile)
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            // Update loading overlay
            Obx(() {
              if (controller.isUpdateScreen.value) {
                return Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppCore.primaryColor,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return Hero(
      tag: 'profile_${controller.profileDataa.value!['id']}',
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Center(
              child: CircleProfile(
                160,
                controller.profileDataa.value!['background_color'],
                controller.profileDataa.value!['emoji'],
              ),
            );
          },
        );
      },
      child: Center(
        child: CircleProfile(
          160,
          controller.profileDataa.value!['background_color'],
          controller.profileDataa.value!['emoji'],
        ),
      ),
    );
  }

  Widget _buildUserName(ProfileController controller) {
    return Hero(
      tag: 'info_${controller.profileDataa.value!['id']}',
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Material(
              color: Colors.transparent,
              child: _buildUserNameContent(controller),
            );
          },
        );
      },
      child: Material(
        color: Colors.transparent,
        child: _buildUserNameContent(controller),
      ),
    );
  }

  Widget _buildUserNameContent(ProfileController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  controller.profileDataa.value!['username'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.8,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "@${controller.profileDataa.value!['username_unique']}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileInfo(ProfileController controller) {
    if (controller.profileDataa.value == null ||
        controller.profileDataa.value!['created_at'] == null) {
      return const SizedBox.shrink();
    }

    final createdAt = DateTime.parse(
      controller.profileDataa.value!['created_at'],
    );
    final formattedDate = DateFormat('dd MMMM yyyy').format(createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Email',
            controller.profileDataa.value!['email'] ?? '',
            Icons.email_outlined,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            'Joined',
            formattedDate,
            Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppCore.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppCore.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

  Widget _buildChatButton(ProfileController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1E1E1E), const Color(0xFF2D2D2D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              controller.startChat(controller.profileDataa.value!['id']);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: AppCore.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: AppCore.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Start Chat',
                    style: TextStyle(
                      color: AppCore.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(ProfileController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            'Edit Profile',
            'Update your profile information',
            Icons.edit_outlined,
            () async {
              await Get.to(
                () => SetupProfilePage(
                  ifEdit: true,
                  profile: homeController!.profile.value,
                ),
              );
              // Update profile after returning
              await controller.updateProfile();
            },
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            'Notifications',
            'Manage your notification preferences',
            Icons.notifications_outlined,
            () {
              // Navigate to notifications settings
            },
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            'Privacy',
            'Manage your privacy settings',
            Icons.privacy_tip_outlined,
            () {
              // Navigate to privacy settings
            },
          ),
          const SizedBox(height: 12),
          _buildSettingsCard(
            'Logout',
            'Sign out from your account',
            Icons.logout_outlined,
            () async {
              final result = await Get.dialog<bool>(
                AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red[400]),
                      ),
                    ),
                  ],
                ),
              );

              if (result == true) {
                await Supabase.instance.client.auth.signOut();
                MyProfileCache.clearCache();
                Get.offAllNamed(Routes.START);
              }
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isDestructive
                        // ignore: deprecated_member_use
                        ? Colors.red.withOpacity(0.1)
                        // ignore: deprecated_member_use
                        : AppCore.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : AppCore.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDestructive ? Colors.red : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
