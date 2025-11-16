// lib/config/app_config.dart

class AppConfig {
  // Base URL for the API
  static const String apiBaseUrl = 'http://localhost:8000/api/v1';

  // Timeouts
  static const int standardRequestTimeoutSeconds = 30;
  static const int uploadRequestTimeoutSeconds = 120;

  // Feature flags
  static const bool useMockResponses = true; // Set to false in production
}
