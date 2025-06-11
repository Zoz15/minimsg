// class Conversation {
//   final String id;
//   final String user1;
//   final String user2;

//   Conversation({required this.id, required this.user1, required this.user2});

//   factory Conversation.fromJson(Map<String, dynamic> json) {
//     return Conversation(
//       id: json['id'],
//       user1: json['user1'],
//       user2: json['user2'],
//     );
//   }
// }

// class Message {
//   final String id;
//   final String conversationId;
//   final String senderId;
//   final String content;
//   final DateTime createdAt;

//   Message({
//     required this.id,
//     required this.conversationId,
//     required this.senderId,
//     required this.content,
//     required this.createdAt,
//   });

//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       id: json['id'],
//       conversationId: json['conversation_id'],
//       senderId: json['sender_id'],
//       content: json['content'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }
