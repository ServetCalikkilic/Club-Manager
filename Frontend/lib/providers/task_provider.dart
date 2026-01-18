import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/dio_client.dart';

class TaskProvider with ChangeNotifier {
  final _dio = DioClient().dio;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get tasks by status
  List<Task> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  // Fetch all tasks
  Future<void> fetchTasks({TaskStatus? status}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String endpoint = '/api/tasks';
      if (status != null) {
        endpoint += '?status=${status.name}';
      }

      final response = await _dio.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        _tasks = data
            .map((json) => Task.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch tasks: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create task
  Future<bool> createTask({
    required String title,
    required String description,
    int? eventId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        '/api/tasks',
        data: {
          'title': title,
          'description': description,
          'status': 'TODO',
          'eventId': eventId,
        },
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchTasks(); // Refresh list
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to create task: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update task status
  Future<bool> updateTaskStatus({
    required int taskId,
    required TaskStatus status,
  }) async {
    try {
      final response = await _dio.put(
        '/api/tasks/$taskId/status',
        data: {'status': status.name},
      );

      if (response.statusCode == 200) {
        await fetchTasks(); // Refresh list
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update task: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
