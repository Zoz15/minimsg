import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:minimsg/features/search_screen/search_controller.dart';
import 'package:minimsg/features/search_screen/widgets/build_search_field.dart';
import 'package:minimsg/features/search_screen/widgets/build_user_list.dart';

Widget buildSearchContent(Search_Controller controller) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            buildSearchField(controller),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: buildUserList(controller),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
