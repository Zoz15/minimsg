import 'package:minimsg/core/model/chats_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> getExistingChat(String myId, String otherId) async {
  final supabase = Supabase.instance.client;

  // Check if chat already exists
  final existingChat =
      await supabase
          .from(ChatsModel.table)
          .select(ChatsModel.id)
          .or(
            'and(user1_id.eq.$myId,user2_id.eq.$otherId),and(user1_id.eq.$otherId,user2_id.eq.$myId)',
          )
          .maybeSingle();

  if (existingChat != null) {
    return existingChat[ChatsModel.id] as String; // Chat already exists
  }

  return null; // No existing chat
}

Future<String> createNewChat(String myId, String otherId) async {
  final supabase = Supabase.instance.client;

  // Create new chat
  final newChat =
      await supabase
          .from(ChatsModel.table)
          .insert({ChatsModel.user1Id: myId, ChatsModel.user2Id: otherId})
          .select(ChatsModel.id)
          .single();

  return newChat[ChatsModel.id] as String;
}
