import 'package:flutter/foundation.dart';
import '../models/meeting.dart';
import '../models/attendance.dart';
import '../services/dio_client.dart';

class MeetingProvider with ChangeNotifier {
  final _dio = DioClient().dio;

  List<Meeting> _meetings = [];
  Meeting? _selectedMeeting;
  List<Attendance> _attendances = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Meeting> get meetings => _meetings;
  Meeting? get selectedMeeting => _selectedMeeting;
  List<Attendance> get attendances => _attendances;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all meetings
  Future<void> fetchMeetings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('/api/meetings');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        _meetings = data
            .map((json) => Meeting.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch meetings: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch single meeting
  Future<void> fetchMeetingById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('/api/meetings/$id');

      if (response.statusCode == 200) {
        _selectedMeeting = Meeting.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch meeting: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch meeting attendances
  Future<void> fetchAttendances(int meetingId) async {
    try {
      final response = await _dio.get('/api/meetings/$meetingId/attendances');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        _attendances = data
            .map((json) => Attendance.fromJson(json as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch attendances: ${e.toString()}';
      notifyListeners();
    }
  }

  // Create meeting
  Future<bool> createMeeting({
    required String title,
    required String description,
    required DateTime meetingDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        '/api/meetings',
        data: {
          'title': title,
          'description': description,
          'meetingDate': meetingDate.toIso8601String(),
        },
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchMeetings(); // Refresh list
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to create meeting: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update attendance status
  Future<bool> updateAttendance({
    required int meetingId,
    required AttendanceStatus status,
  }) async {
    try {
      final response = await _dio.post(
        '/api/meetings/$meetingId/attend',
        data: {'status': status.name},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchAttendances(meetingId); // Refresh attendances
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update attendance: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
