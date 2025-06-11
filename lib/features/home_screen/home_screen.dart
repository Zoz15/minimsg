import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/features/chat_screen/presentation/pages/chat_screen.dart';
import 'package:minimsg/features/home_screen/home_controller/home_controller.dart';
import 'package:minimsg/features/home_screen/widgets/build_bottom_navigation_bar.dart';
import 'package:minimsg/features/home_screen/widgets/widget_model.dart';
import 'package:minimsg/features/profile_screen/profile_screen.dart';
import 'package:minimsg/features/search_screen/search_page.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () =>
            controller.profile.value == null
                ? const Center(child: CircularProgressIndicator())
                : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _buildCurrentScreen(),
            ),
          ),
          buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (controller.selectedIndex.value) {
      case WidgetModel.chat:
        return BuildChatScreen(homeController: controller);
      case WidgetModel.profile:
        return BuildProfileScreen(homeController: controller);
      case WidgetModel.add:
        return BuildSearchScreen();
      default:
        return const SizedBox();
    }
  }
}
