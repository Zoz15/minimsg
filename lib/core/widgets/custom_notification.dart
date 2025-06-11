import 'package:flutter/material.dart';
import 'package:minimsg/core/app_core.dart';

class CustomNotification extends StatelessWidget {
  final String message;
  final bool isError;
  final VoidCallback? onDismiss;

  const CustomNotification({
    Key? key,
    required this.message,
    this.isError = false,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color:
              isError
                  ? Colors.red.shade900.withOpacity(0.9)
                  : AppCore.primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isError ? '❌' : '✅', style: TextStyle(fontSize: 28)),
            SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: isError ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (onDismiss != null)
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.black38,
                  size: 22,
                ),
                onPressed: onDismiss,
                splashRadius: 18,
              ),
          ],
        ),
      ),
    );
  }
}
