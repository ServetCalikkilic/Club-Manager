import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../services/dio_client.dart';

class EventProvider with ChangeNotifier {
  final _dio = DioClient().dio;

  List<Event> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all events
  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('/api/events');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        _events = data
            .map((json) => Event.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch events: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
