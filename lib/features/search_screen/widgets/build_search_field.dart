import 'package:flutter/material.dart';
import 'package:minimsg/features/search_screen/search_controller.dart';

Widget buildSearchField(Search_Controller controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.updateSearchQuery,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search users...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey[400],
            size: 24,
          ),
          // suffixIcon: Icon(
          //   Icons.tune_rounded,
          //   color: Colors.grey[400],
          //   size: 24,
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    ),
  );
}
