import 'user.dart';

class Message {
  final int id;
  final int channelId;
  final int userId;
  final User? user;
  final String content;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.channelId,
    required this.userId,
    this.user,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      channelId: json['channelId'] as int,
      userId: json['userId'] as int,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channelId': channelId,
      'userId': userId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
