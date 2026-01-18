import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/message.dart';
import '../services/dio_client.dart';
import '../utils/constants.dart';

class ChatProvider with ChangeNotifier {
  final _dio = DioClient().dio;

  List<Message> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _pollingTimer;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch messages
  Future<void> fetchMessages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('/api/chat/messages');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        _messages = data
            .map((json) => Message.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch messages: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch latest messages (for polling)
  Future<void> fetchLatestMessages() async {
    try {
      final response = await _dio.get('/api/chat/messages/latest');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final latestMessages = data
            .map((json) => Message.fromJson(json as Map<String, dynamic>))
            .toList();

        // Only update if there are new messages
        if (latestMessages.isNotEmpty) {
          _messages = latestMessages;
          notifyListeners();
        }
      }
    } catch (e) {
      // Silent fail for polling
      print('Polling error: $e');
    }
  }

  // Send message
  Future<bool> sendMessage(String content) async {
    try {
      final response = await _dio.post(
        '/api/chat/messages',
        data: {'content': content},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchMessages(); // Refresh messages
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to send message: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Start polling (call this when entering chat screen)
  void startPolling() {
    stopPolling(); // Stop any existing timer
    _pollingTimer = Timer.periodic(AppConstants.chatPollingInterval, (timer) {
      fetchLatestMessages();
    });
  }

  // Stop polling (call this when leaving chat screen)
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
