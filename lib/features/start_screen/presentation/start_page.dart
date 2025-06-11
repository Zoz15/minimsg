import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/routes/app_pages.dart';
import 'package:minimsg/features/start_screen/presentation/widgets/build_3d_images.dart';
import 'package:minimsg/features/start_screen/presentation/widgets/build_start_button.dart';
import 'package:minimsg/features/start_screen/presentation/widgets/build_text.dart';
import 'package:minimsg/features/start_screen/presentation/widgets/circel_contaner.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          CircleBackground(),
          Animated3DImages(),
          StartScreenText(),
          AnimatedStartButton(),
        ],
      ),
    );
  }
}

// void afterStartTapped() {
//   Get.offAllNamed('/home');
// }

void goToLogin() {
  Get.offAllNamed(Routes.LOGIN);
}
