import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/app_core.dart';

class StartScreenText extends StatelessWidget {
  const StartScreenText({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 20, bottom: Get.height * 0.15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Let\'s easy talking to \nyour friends with\n${AppCore.appName}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Messages your Friends Simply\nAnd Simple With ${AppCore.appName}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 75),
            ],
          ),
        ),
      ),
    );
  }
}
