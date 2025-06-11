import 'dart:convert';
import 'package:minimsg/features/chat_screen/presentation/model/profile_var_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProfileCache {
  static const String _profileKey = 'cached_profile';

  // static const String _lastUpdateKey = 'last_profile_update';

  static var myProfile = ProfileVarModel(
    id: '',
    email: '',
    username_unique: '',
    username: '',
    emoji: '',
    background_color: '',
    created_at: '',
  );

  static Future<ProfileVarModel?> getAndSaveProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final data =
          await Supabase.instance.client
              .from('profiles')
              .select()
              .eq('id', user.id)
              .maybeSingle();

      if (data != null) {
        myProfile = ProfileVarModel(
          id: data['id'] ?? '',
          email: data['email'] ?? '',
          username_unique: data['username_unique'] ?? '',
          username: data['username'] ?? '',
          emoji: data['emoji'] ?? '',
          background_color: data['background_color'] ?? '',
          created_at: data['created_at'] ?? DateTime.now().toIso8601String(),
        );

        // Save to cache
        try {
          final prefs = await SharedPreferences.getInstance();
          final profileJson = jsonEncode({
            'id': myProfile.id,
            'email': myProfile.email,
            'username_unique': myProfile.username_unique,
            'username': myProfile.username,
            'emoji': myProfile.emoji,
            'background_color': myProfile.background_color,
            'created_at': myProfile.created_at,
          });
          await prefs.setString(_profileKey, profileJson);
        } catch (e) {
          print('Error saving profile to cache: $e');
        }

        return myProfile;
      }
    }
    return null;
  }

  // Get cached profile data
  static Future<ProfileVarModel?> getProfile() async {
    try {
      if (myProfile.id.isNotEmpty && myProfile.id != '') {
        return myProfile;
      }
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      if (profileJson != null) {
        final data = jsonDecode(profileJson) as Map<String, dynamic>;
        myProfile = ProfileVarModel(
          id: data['id'],
          email: data['email'],
          username_unique: data['username_unique'],
          username: data['username'],
          emoji: data['emoji'],
          background_color: data['background_color'],
          created_at: data['created_at'],
        );
        return myProfile;
      }
    } catch (e) {
      print('Error getting profile from cache: $e');
    }
    return null;
  }

  // Check if profile is saved in cache
  static Future<bool> isProfileSaved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      if (profileJson != null) {
        final data = jsonDecode(profileJson) as Map<String, dynamic>;
        return data['id'] != null && data['id'].isNotEmpty;
      }
    } catch (e) {
      print('Error checking if profile is saved: $e');
    }
    return false;
  }

  // Clear cached profile data
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
    } catch (e) {
      print('Error clearing profile cache: $e');
    }
  }

  // Update specific profile fields
  static Future<void> updateProfileFields(Map<String, dynamic> updates) async {
    try {
      final currentProfile = await getProfile();
      if (currentProfile != null) {
        myProfile = ProfileVarModel(
          id: updates['id'] ?? currentProfile.id,
          email: updates['email'] ?? currentProfile.email,
          username_unique:
              updates['username_unique'] ?? currentProfile.username_unique,
          username: updates['username'] ?? currentProfile.username,
          emoji: updates['emoji'] ?? currentProfile.emoji,
          background_color:
              updates['background_color'] ?? currentProfile.background_color,
          created_at: updates['created_at'] ?? currentProfile.created_at,
        );

        // Save updated profile to cache
        final prefs = await SharedPreferences.getInstance();
        final profileJson = jsonEncode({
          'id': myProfile.id,
          'email': myProfile.email,
          'username_unique': myProfile.username_unique,
          'username': myProfile.username,
          'emoji': myProfile.emoji,
          'background_color': myProfile.background_color,
          'created_at': myProfile.created_at,
        });
        await prefs.setString(_profileKey, profileJson);
      }
    } catch (e) {
      print('Error updating profile fields: $e');
    }
  }
}
