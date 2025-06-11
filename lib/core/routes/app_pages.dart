import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:minimsg/features/google_login_screen/presentation/google_login_page.dart';
import 'package:minimsg/features/home_screen/home_screen.dart';
import 'package:minimsg/features/setup_profile/presentation/setup_profile.dart';
import 'package:minimsg/features/start_screen/presentation/start_page.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.START;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const GoogleLogin(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: Routes.SETUP_PROFILE,
      page: () => const SetupProfilePage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: Routes.START,
      page: () => const StartPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    ),
    
  ];
}
