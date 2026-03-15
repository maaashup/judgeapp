import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  final String eventId;
  final String eventName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event details: $eventName')),

      //Split into sections:

      //Participants Button

      //Judges Button

      //Rulings Button

      //Display other information: Event code / Option to finish tournament and export results
    );
  }
}
