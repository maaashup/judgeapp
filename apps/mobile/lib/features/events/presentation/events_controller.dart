import 'package:flutter/foundation.dart';
import 'package:mobile/features/events/data/event.dart';
import 'package:mobile/features/events/data/events_api_service.dart';

class EventsController extends ChangeNotifier {
  EventsController({EventsApiService? apiService})
    : _apiService = apiService ?? EventsApiService();

  final EventsApiService _apiService;

  List<Event> _events = [];
  bool _isLoading = true;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _apiService.fetchEvents();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createEvent(Map<String, dynamic> data) async {
    await _apiService.createEvent(data);
    await loadEvents();
  }

  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    await _apiService.updateEvent(id, data);
    await loadEvents();
  }

  Future<void> deleteEvent(String id) async {
    await _apiService.deleteEvent(id);
    await loadEvents();
  }
}
