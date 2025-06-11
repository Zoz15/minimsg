import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircleBackground extends StatelessWidget {
  const CircleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SizedBox(
        width: Get.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildCircle(Get.width * 0.3, 0.5),
            _buildCircle(Get.width * 0.55, 0.3),
            _buildCircle(Get.width * 0.8, 0.1),
            Container(
              width: Get.width,
              height: Get.width,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 0, 0.2),
                    Colors.transparent,
                  ],
                  radius: 0.9,
                  center: Alignment.center,
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(double size, double borderWidth) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: borderWidth),
        shape: BoxShape.circle,
      ),
    );
  }
}
