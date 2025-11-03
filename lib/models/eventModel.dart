class Event {
  final int? id;
  final String title;
  final String description;
  final DateTime date;
  final int userId; 

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.userId,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'userId': userId,
    };
  }
}
