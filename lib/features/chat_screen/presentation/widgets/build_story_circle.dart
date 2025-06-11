import 'package:flutter/material.dart';

Widget buildStoryCircle(String name, String emoji) {
  return Padding(
    padding: const EdgeInsets.only(right: 15),
    child: Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white24,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 30, fontFamily: 'iphone'),
          ),
        ),
        const SizedBox(height: 5),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );
}
