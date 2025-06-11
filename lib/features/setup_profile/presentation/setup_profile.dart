import 'package:flutter/material.dart';
import 'package:minimsg/core/app_core.dart';
import 'package:get/get.dart';
import 'package:minimsg/core/funchion/save_my_profile_in_cach.dart';
import 'package:minimsg/core/routes/app_pages.dart';
import 'package:minimsg/core/widgets/circel_profile.dart';
import 'package:minimsg/features/chat_screen/presentation/model/profile_var_model.dart';
import 'package:minimsg/features/home_screen/home_controller/home_controller.dart';
import 'package:minimsg/features/profile_screen/profile_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/color_picker_widget.dart';
import 'widgets/emoji_picker_widget.dart';

class SetupProfilePage extends StatefulWidget {
  final bool ifEdit;
  final ProfileVarModel? profile;
  const SetupProfilePage({super.key, this.ifEdit = false, this.profile});

  @override
  State<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _uniqueUsernameController = TextEditingController();
  Color _selectedColor = AppCore.primaryColor;
  late String _selectedEmoji;

  @override
  void initState() {
    super.initState();
    _selectedEmoji = widget.profile?.emoji ?? '😊';
    _usernameController.text = widget.profile?.username ?? '';
    _uniqueUsernameController.text = widget.profile?.username_unique ?? '';
    if (widget.profile?.background_color != null) {
      _selectedColor = Color(
        int.parse('0xFF${widget.profile?.background_color}'),
      );
    } else {
      _selectedColor = Color(int.parse('0xFFfff5d5'));
    }
    // _selectedColor = Color(int.parse('0xFF${widget.profile?.background_color}')) ??
    //     Color(int.parse('0xFFfff5d5'));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _uniqueUsernameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // ignore: deprecated_member_use
      final backgroundColorHex = _selectedColor.value
          .toRadixString(16)
          .padLeft(8, '0')
          .substring(2); // بدون alpha

      await Supabase.instance.client.from('profiles').insert({
        'id': user.id,
        'username': _usernameController.text.trim(),
        'username_unique': _uniqueUsernameController.text.trim(),
        'background_color': backgroundColorHex,
        'emoji': _selectedEmoji,
        'email': user.email, // ممكن تضيفه لو حابب تحفظه كمان
      });

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print('Error saving profile: $e');
      Get.snackbar('error', 'Failed to save profile');
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final backgroundColorHex = _selectedColor.value
          .toRadixString(16)
          .padLeft(8, '0')
          .substring(2);

      await Supabase.instance.client
          .from('profiles')
          .update({
            'username': _usernameController.text.trim(),
            'background_color': backgroundColorHex,
            'emoji': _selectedEmoji,
            // 'email': user.email,
          })
          .eq('id', user.id);
      MyProfileCache.clearCache();
      MyProfileCache.getAndSaveProfile();

      print(
        'username: ${_usernameController.text.trim()} : ${Get.find<ProfileController>().profileDataa.value?['username']}',
      );
      print(
        'background_color: $backgroundColorHex : ${Get.find<ProfileController>().profileDataa.value?['background_color']}',
      );
      print(
        'emoji: $_selectedEmoji : ${Get.find<ProfileController>().profileDataa.value?['emoji']}',
      );
      Get.find<ProfileController>().profileDataa.value = {
        'username': _usernameController.text.trim(),
        // 'username_unique': _uniqueUsernameController.text.trim(),
        'background_color': backgroundColorHex,
        'emoji': _selectedEmoji,
        // 'email': user.email,
      };
      print('profile updated');
      Get.find<HomeController>().getProfileFromCach();
      Get.back();
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar('error', 'Failed to update profile');
    }
  }

  Widget _buildProfilePreview(ProfileVarModel? profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     // Outer glow effect
          //     Container(
          //       width: 160,
          //       height: 160,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         boxShadow: [
          //           BoxShadow(
          //             color: _selectedColor.withOpacity(0.3),
          //             blurRadius: 20,
          //             spreadRadius: 8,
          //           ),
          //         ],
          //       ),
          //     ),
          //     // Main circle
          //     Container(
          //       width: 140,
          //       height: 140,
          //       decoration: BoxDecoration(
          //         color: _selectedColor,
          //         shape: BoxShape.circle,
          //         boxShadow: [
          //           BoxShadow(
          //             color: _selectedColor.withOpacity(0.4),
          //             blurRadius: 15,
          //             spreadRadius: 2,
          //           ),
          //         ],
          //       ),
          //       child: Center(
          //         child: Padding(
          //           padding: const EdgeInsets.only(top: 25),
          //           child: Text(
          //             _selectedEmoji,
          //             style: const TextStyle(
          //               fontSize: 70,
          //               fontFamily: 'iphone',
          //             ),
          //             textAlign: TextAlign.center,
          //             textHeightBehavior: TextHeightBehavior(
          //               applyHeightToFirstAscent: false,
          //               applyHeightToLastDescent: false,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          CircleProfile(
            140,
            _selectedColor,
            _selectedEmoji,
            animation: true,
            ifShadowBig: false,
          ),
          const SizedBox(height: 24),
          if (_uniqueUsernameController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '@${_uniqueUsernameController.text}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (_usernameController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _usernameController.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Display Name',
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a display name';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _uniqueUsernameController,
          enabled: !widget.ifEdit,
          style: TextStyle(
            color: widget.ifEdit ? Colors.grey[600] : Colors.white,
          ),
          decoration: InputDecoration(
            labelText: 'Unique Username',
            labelStyle: TextStyle(
              color: widget.ifEdit ? Colors.grey[600] : Colors.white70,
            ),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixText: '@',
            prefixStyle: TextStyle(
              color: widget.ifEdit ? Colors.grey[600] : Colors.white70,
            ),
          ),
          validator: (value) {
            if (!widget.ifEdit && (value == null || value.isEmpty)) {
              return 'Please enter a unique username';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed top section with title and back button
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  if (widget.ifEdit)
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  if (widget.ifEdit) const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ifEdit ? 'Edit Profile' : 'Setup Your Profile',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Customize your profile',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfilePreview(widget.profile),
                      const SizedBox(height: 32),
                      _buildInputFields(),
                      const SizedBox(height: 32),
                      ColorPickerWidget(
                        selectedColor: _selectedColor,
                        onColorSelected:
                            (color) => setState(() => _selectedColor = color),
                      ),
                      const SizedBox(height: 32),
                      EmojiPickerWidget(
                        selectedEmoji: _selectedEmoji,
                        onEmojiSelected:
                            (emoji) => setState(() => _selectedEmoji = emoji),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            // Fixed bottom save button
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.ifEdit ? _updateProfile : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppCore.primaryColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.ifEdit ? 'Update Profile' : 'Save Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
