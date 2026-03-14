import 'package:mobile/core/services/api_client.dart';
import 'event.dart';

class EventsApiService {
  EventsApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<Event>> fetchEvents() async {
    final data = await _client.get('/events');

    if (data is! List) {
      throw Exception('Invalid response format while loading events');
    }

    return data
        .map((item) => Event.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> createEvent(Map<String, dynamic> data) async {
    final payload = {
      ...data,
      'clientId': 'client_${DateTime.now().millisecondsSinceEpoch}',
    };

    await _client.post('/events', body: payload);
  }

  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    await _client.put('/events/$id', body: data);
  }

  Future<void> deleteEvent(String id) async {
    await _client.delete('/events/$id');
  }
}
