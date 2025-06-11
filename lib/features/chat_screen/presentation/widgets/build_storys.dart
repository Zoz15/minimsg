import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/features/chat_screen/presentation/controllers/chat_controller.dart';
import 'package:minimsg/features/chat_screen/presentation/widgets/build_story_circle.dart';

Widget buildStorys(ChatController controller) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Story',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              // TODO: Add see all stories
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 120,
        child: Obx(
          () => ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              buildStoryCircle('Add Story', '+'),
              ...controller.stories
                  .map(
                    (story) =>
                        buildStoryCircle(story['name']!, story['emoji']!),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    ],
  );
}
