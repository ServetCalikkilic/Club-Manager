class Event {
  final int id;
  final String title;
  final String description;
  final DateTime eventDate;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
