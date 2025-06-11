import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget bottomSheet(BuildContext context, {required VoidCallback onDeleteChat}) {
  return IconButton(
    icon: const Icon(Icons.more_vert, color: Colors.black87),
    onPressed: () {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Delete Chat',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Get.back(); // Close the bottom sheet
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Chat'),
                          content: const Text(
                            'Are you sure you want to delete this chat? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                onDeleteChat();
                                Get.back();
                                Get.back(); // Go back to previous screen
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
