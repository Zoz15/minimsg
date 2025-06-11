import 'package:flutter/material.dart';
import 'package:minimsg/core/app_core.dart';
import 'package:minimsg/features/home_screen/home_controller/home_controller.dart';

Widget buildTopBar(HomeController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Welcome ${controller.profile.value!.username} ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    // fontFamily: 'iphone',
                  ),
                ),
                Text(
                  '${controller.profile.value!.emoji}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    // fontFamily: 'iphone',
                  ),
                ),
              ],
            ),
            Text(
              AppCore.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,

            // borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.notifications, color: Colors.white, size: 30),
        ),
      ],
    ),
  );
}
