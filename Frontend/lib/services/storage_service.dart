import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user.dart';
import '../utils/constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _storage = const FlutterSecureStorage();

  // JWT Token operations
  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.jwtTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.jwtTokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.jwtTokenKey);
  }

  // User data operations
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: AppConstants.userDataKey, value: userJson);
  }

  Future<User?> getUser() async {
    final userJson = await _storage.read(key: AppConstants.userDataKey);
    if (userJson == null) return null;
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: AppConstants.userDataKey);
  }

  // Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
