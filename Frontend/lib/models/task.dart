enum TaskStatus {
  TODO,
  DOING,
  DONE;

  static TaskStatus fromString(String status) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => TaskStatus.TODO,
    );
  }
}

class Task {
  final int id;
  final String title;
  final String description;
  final TaskStatus status;
  final int? assignedTo;
  final int? eventId;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.assignedTo,
    this.eventId,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      status: TaskStatus.fromString(json['status'] as String),
      assignedTo: json['assignedTo'] as int?,
      eventId: json['eventId'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'assignedTo': assignedTo,
      'eventId': eventId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
