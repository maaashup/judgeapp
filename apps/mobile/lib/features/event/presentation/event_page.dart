import 'package:flutter/material.dart';
import 'package:mobile/features/event/presentation/widgets/path_button.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            //Paricipants Button
            MyButton(text: "Participants", color: Colors.blue),
            SizedBox(height: 20),
            //Judges Button
            MyButton(text: "Judges", color: Colors.red),
            SizedBox(height: 20),
            //Rulings Button
            MyButton(text: "Rulings", color: Colors.deepPurple),
          ],
        ),
      ),

      //Display other information: Event code / Option to finish tournament and export results
    );
  }
}
