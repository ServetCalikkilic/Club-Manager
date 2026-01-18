enum UserRole {
  MEMBER,
  PRESIDENT,
  ADMIN;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.MEMBER,
    );
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final UserRole role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: UserRole.fromString(json['role'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isPresident => role == UserRole.PRESIDENT;
  bool get isAdmin => role == UserRole.ADMIN;
  bool get canCreateAnnouncements => isPresident || isAdmin;
  bool get canCreateMeetings => isPresident || isAdmin;
}
