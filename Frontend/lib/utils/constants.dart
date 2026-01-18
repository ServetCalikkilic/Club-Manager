class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:8080';
  static const String apiPrefix = '/api';
  
  // Auth endpoints
  static const String authLogin = '/api/auth/login';
  static const String authRegister = '/api/auth/register';
  static const String authProfile = '/api/auth/profile';
  
  // Storage keys
  static const String jwtTokenKey = 'jwt_token';
  static const String userDataKey = 'user_data';
  
  // Polling interval
  static const Duration chatPollingInterval = Duration(seconds: 3);
}
