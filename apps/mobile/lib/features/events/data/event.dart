class Event {
  final String id;
  final String eventName;
  final String format;
  final String game;
  final String country;
  final DateTime eventDate;

  Event({
    required this.id,
    required this.eventName,
    required this.format,
    required this.game,
    required this.country,
    required this.eventDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      eventName: json['eventName'],
      format: json['format'],
      game: json['game'],
      country: json['country'],
      eventDate: DateTime.parse(json['eventDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'format': format,
      'game': game,
      'country': country,
      'eventDate': eventDate.toIso8601String(),
    };
  }
}
