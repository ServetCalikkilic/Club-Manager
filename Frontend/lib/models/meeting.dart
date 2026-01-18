import 'user.dart';

class Meeting {
  final int id;
  final String title;
  final String description;
  final DateTime meetingDate;
  final User? createdBy;
  final int createdById;
  final DateTime createdAt;

  Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.meetingDate,
    this.createdBy,
    required this.createdById,
    required this.createdAt,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      meetingDate: DateTime.parse(json['meetingDate'] as String),
      createdBy: json['createdBy'] != null
          ? User.fromJson(json['createdBy'])
          : null,
      createdById: json['createdById'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'meetingDate': meetingDate.toIso8601String(),
      'createdById': createdById,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
