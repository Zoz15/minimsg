import 'package:flutter/material.dart';
import 'package:minimsg/core/model/proriles_model.dart';

Widget buildUserInfo(Map<String, dynamic> user) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        constraints: BoxConstraints(
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                user['username'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.alternate_email_rounded,
                  size: 12,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    "${user[ProfilesModel.username_unique]}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
