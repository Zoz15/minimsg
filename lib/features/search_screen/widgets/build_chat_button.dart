import 'package:flutter/material.dart';

Widget buildChatButton(Function() onPressed) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.pinkAccent.withOpacity(0.1),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.pinkAccent.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.chat_bubble_outline_rounded,
          size: 24,
          color: Colors.pinkAccent.shade400,
        ),
      ),
    ),
  );
}
