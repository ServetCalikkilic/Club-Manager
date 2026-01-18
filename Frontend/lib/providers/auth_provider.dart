import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/dio_client.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  final _dio = DioClient().dio;
  final _storage = StorageService();

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Auto-load user from storage on app start
  Future<void> loadUserFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _storage.getUser();
      final token = await _storage.getToken();

      if (user != null && token != null) {
        _currentUser = user;
      }
    } catch (e) {
      print('Error loading user from storage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        AppConstants.authRegister,
        data: {
          'username': username,
          'email': email,
          'password': password,
          'fullName': fullName,
        },
      );

      _isLoading = false;
      notifyListeners();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      _errorMessage = 'Registration failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        AppConstants.authLogin,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final token = data['token'] as String;
        final userData = data['user'] as Map<String, dynamic>;

        final user = User.fromJson(userData);

        // Save to storage
        await _storage.saveToken(token);
        await _storage.saveUser(user);

        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.clearAll();
    _currentUser = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
