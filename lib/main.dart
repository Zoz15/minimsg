import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/app_core.dart';
import 'package:minimsg/core/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jvnwamyeqfaitulktkpn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp2bndhbXllcWZhaXR1bGt0a3BuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwODU1ODMsImV4cCI6MjA2NDY2MTU4M30.Ru6zeOVXcHBXWR6Z9usdzIbGdN6UKW1bphsKSqblhNU',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(bodyLarge: const TextStyle(fontSize: 18)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppCore.primaryColor,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ),
      initialRoute: _getInitialRoute(),
      getPages: AppPages.routes,
    );
  }

  String _getInitialRoute() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      return Routes.HOME;
    }
    return Routes.START;
  }
}
