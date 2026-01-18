import 'package:flutter/foundation.dart';
import '../models/announcement.dart';
import '../services/dio_client.dart';

class AnnouncementProvider with ChangeNotifier {
  final _dio = DioClient().dio;

  List<Announcement> _announcements = [];
  Announcement? _selectedAnnouncement;
  bool _isLoading = false;
  String? _errorMessage;

  List<Announcement> get announcements => _announcements;
  Announcement? get selectedAnnouncement => _selectedAnnouncement;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all announcements
  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('/api/announcements');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        _announcements = data
            .map((json) => Announcement.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch announcements: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch single announcement
  Future<void> fetchAnnouncementById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('/api/announcements/$id');

      if (response.statusCode == 200) {
        _selectedAnnouncement = Announcement.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch announcement: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create announcement
  Future<bool> createAnnouncement({
    required String title,
    required String content,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        '/api/announcements',
        data: {'title': title, 'content': content},
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchAnnouncements(); // Refresh list
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to create announcement: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
