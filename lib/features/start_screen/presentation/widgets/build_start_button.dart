import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/app_core.dart';
import 'package:minimsg/features/start_screen/presentation/widgets/circle_animation.dart';
import 'package:minimsg/features/start_screen/presentation/start_page.dart';

class AnimatedStartButton extends StatefulWidget {
  const AnimatedStartButton({super.key});

  @override
  State<AnimatedStartButton> createState() => _AnimatedStartButtonState();
}

class _AnimatedStartButtonState extends State<AnimatedStartButton> {
  final GlobalKey<CircleAnimationState> _circleKey = GlobalKey();

  void _showCircle() {
    _circleKey.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: Get.height,
          width: Get.width,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: InkWell(
                onTap: _showCircle,
                child: Container(
                  height: 70,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppCore.primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      'Get Start',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        CircleAnimation(
          key: _circleKey,
          color: AppCore.primaryColor,
          onAnimationComplete: () {
            goToLogin();
          },
        ),
      ],
    );
  }
}
