import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:minimsg/core/app_core.dart';
import 'package:minimsg/core/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import '../../../core/widgets/custom_notification.dart';
import 'package:minimsg/core/emoji_utils.dart';

class GoogleLogin extends StatefulWidget {
  const GoogleLogin({super.key});

  @override
  State<GoogleLogin> createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  static const _webClientId =
      '605824528424-lim87qpni4f771h96k0dsmjvq0fqdmep.apps.googleusercontent.com';
  static const _googleLogoUrl = 'https://www.google.com/favicon.ico';
  static const _notificationDuration = Duration(seconds: 2);

  String? _notificationMessage;
  bool _isError = false;
  final _supabase = Supabase.instance.client;

  void _showNotification(String message, {bool isError = false}) {
    setState(() {
      _notificationMessage = message;
      _isError = isError;
    });

    Timer(_notificationDuration, () {
      if (mounted) {
        setState(() {
          _notificationMessage = null;
        });
      }
    });
  }

  void _goToHome() {
    Get.offAllNamed(Routes.HOME);
  }

  void _goToSetupProfile() {
    Get.toNamed(Routes.SETUP_PROFILE);
  }

  Future<void> _checkIfNewUser() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      print('❌ لا يوجد مستخدم مسجل دخول');
      return;
    }

    print('✅ User ID from auth: ${user.id}');

    try {
      final profile =
          await _supabase
              .from('profiles')
              .select()
              .eq('id', user.id)
              .maybeSingle();

      if (profile == null) {
        print('🆕 مستخدم جديد → الذهاب إلى صفحة إعداد الحساب');
        _goToSetupProfile(); // روح شاشة إعداد الحساب
      } else {
        print('👤 مستخدم موجود → الذهاب إلى الصفحة الرئيسية');
        _goToHome(); // روح الصفحة الرئيسية
      }
    } catch (e) {
      print('⚠️ حصل خطأ أثناء التحقق من المستخدم: $e');
      // ممكن تعرض Snackbar هنا لو حبيت
    }
  }

  Future<bool> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNotification(
        '❌ No internet connection, please check your network',
        isError: true,
      );
      return false;
    }
    return true;
  }

  Future<void> _handleGoogleSignIn() async {
    if (!await _checkInternetConnection()) return;

    try {
      final googleSignIn = GoogleSignIn(serverClientId: _webClientId);
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'Authentication tokens not found';
      }

      final result = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (result.user != null) {
        _checkIfNewUser();

        print(
          '✅ Successfully signed in with Google! User: ${result.user?.email}',
        );
        _showNotification('Successfully signed in with Google!');
      } else {
        _showNotification(
          '❌ Error occurred during Google sign-in',
          isError: true,
        );
      }
    } catch (error) {
      print('🔴 Google Sign-In Error: $error');
      _showNotification(
        '❌ Error occurred during Google sign-in',
        isError: true,
      );
    }
  }

  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _handleGoogleSignIn,
        icon: Image.network(
          _googleLogoUrl,
          height: 24,
          width: 24,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.g_mobiledata, size: 24);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            );
          },
        ),
        label: const Text(
          'Sign in with Google',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCore.primaryColor,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            EmojiUtils.getRandomFaceEmoji(),
            style: const TextStyle(fontSize: 64, fontFamily: 'iphone'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome to MiniMsg!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "It's easy talking to your friends with MiniMsg",
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildGoogleSignInButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildWelcomeCard(),
              ),
            ),
            if (_notificationMessage != null)
              Positioned(
                top: 32,
                left: 0,
                right: 0,
                child: CustomNotification(
                  message: _notificationMessage!,
                  isError: _isError,
                  onDismiss: () {
                    setState(() {
                      _notificationMessage = null;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
