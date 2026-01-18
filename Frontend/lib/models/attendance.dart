import 'user.dart';

enum AttendanceStatus {
  COMING,
  NOT_COMING;

  static AttendanceStatus fromString(String status) {
    return AttendanceStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => AttendanceStatus.NOT_COMING,
    );
  }
}

class Attendance {
  final int id;
  final int meetingId;
  final int userId;
  final User? user;
  final AttendanceStatus status;

  Attendance({
    required this.id,
    required this.meetingId,
    required this.userId,
    this.user,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as int,
      meetingId: json['meetingId'] as int,
      userId: json['userId'] as int,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      status: AttendanceStatus.fromString(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meetingId': meetingId,
      'userId': userId,
      'status': status.name,
    };
  }
}
