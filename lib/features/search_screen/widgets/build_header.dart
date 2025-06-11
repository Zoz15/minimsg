import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/features/search_screen/search_controller.dart';

Widget buildHeader(Search_Controller controller) {
  return Container(
    width: Get.width,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Discover',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            _buildSortMenu(controller),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Find and connect with people',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSortMenu(Search_Controller controller) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: PopupMenuButton<String>(
      onSelected: controller.updateSortBy,
      icon: const Icon(Icons.sort, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[900],
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'name',
              child: Row(
                children: [
                  const Icon(
                    Icons.sort_by_alpha,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sort by Name',
                    style: TextStyle(color: Colors.grey[200], fontSize: 16),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'time',
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Sort by Time',
                    style: TextStyle(color: Colors.grey[200], fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
    ),
  );
}
