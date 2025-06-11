import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/features/home_screen/home_controller/home_controller.dart';
import 'package:minimsg/features/home_screen/widgets/widget_model.dart';

Widget buildBottomNavigationBar() {
  final controller = Get.find<HomeController>();
  final screenWidth = Get.width;
  final itemWidth = screenWidth / 3 - 40; // Divide screen into 3 equal parts

  return Container(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
    decoration: BoxDecoration(
      color: Colors.black,
      boxShadow: [
        BoxShadow(
          color: Colors.purple.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: Container(
      height: 65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.purple.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.purple.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            Icons.add_circle_outline,
            controller.selectedIndex.value == WidgetModel.add,
            'Add',
            width: itemWidth,
            onTap: () => controller.updateSelectedIndex(WidgetModel.add),
          ),
          _buildNavItem(
            'assets/icons/chat.png',
            controller.selectedIndex.value == WidgetModel.chat,
            'Chats',
            width: itemWidth,
            onTap: () => controller.updateSelectedIndex(WidgetModel.chat),
          ),
          _buildNavItem(
            Icons.person_outline,
            controller.selectedIndex.value == WidgetModel.profile,
            'Profile',
            width: itemWidth,
            onTap: () => controller.updateSelectedIndex(WidgetModel.profile),
          ),
        ],
      ),
    ),
  );
}

Widget _buildNavItem(
  dynamic icon,
  bool isSelected,
  String label, {
  required VoidCallback onTap,
  required double width,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Colors.purple.withOpacity(0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
            child:
                icon is IconData
                    ? AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: isSelected ? 1.2 : 1.0,
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.purple[300] : Colors.white70,
                        size: 24,
                      ),
                    )
                    : AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: isSelected ? 1.2 : 1.0,
                      child: Image.asset(
                        icon,
                        width: 24,
                        height: 24,
                        color: isSelected ? Colors.purple[300] : Colors.white70,
                        fit: BoxFit.contain,
                      ),
                    ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isSelected ? Colors.purple[300] : Colors.white70,
              fontSize: isSelected ? 13 : 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              letterSpacing: isSelected ? 0.5 : 0,
            ),
            child: Text(label),
          ),
        ],
      ),
    ),
  );
}
