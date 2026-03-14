class Event {
  final String id;
  final String eventName;
  final DateTime eventDate;
  final String format;
  final String game;
  final String country;

  Event({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.format,
    required this.game,
    required this.country,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      eventName: json['eventName'],
      eventDate: DateTime.parse(json['eventDate']),
      format: json['format'],
      game: json['game'],
      country: json['country'],
    );
  }
}
