import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

/// Service for managing API configuration
/// Allows users to override the default API URL for testing with different backends
class ApiConfigService {
  static const _storage = FlutterSecureStorage();
  static const String _customUrlKey = 'custom_api_url';
  static const String _useCustomUrlKey = 'use_custom_api_url';

  /// Get the current API base URL (custom or default)
  static Future<String> getApiUrl() async {
    final useCustom = await _storage.read(key: _useCustomUrlKey);
    
    if (useCustom == 'true') {
      final customUrl = await _storage.read(key: _customUrlKey);
      if (customUrl != null && customUrl.isNotEmpty) {
        return customUrl;
      }
    }
    
    return ApiConstants.baseUrl;
  }

  /// Save a custom API URL
  static Future<void> setCustomUrl(String url) async {
    // Validate URL format
    if (!_isValidUrl(url)) {
      throw ArgumentError('Invalid URL format. Must start with http:// or https://');
    }
    
    await _storage.write(key: _customUrlKey, value: url);
    await _storage.write(key: _useCustomUrlKey, value: 'true');
  }

  /// Check if using custom URL
  static Future<bool> isUsingCustomUrl() async {
    final useCustom = await _storage.read(key: _useCustomUrlKey);
    return useCustom == 'true';
  }

  /// Get the saved custom URL (may be null)
  static Future<String?> getCustomUrl() async {
    return await _storage.read(key: _customUrlKey);
  }

  /// Reset to default API URL
  static Future<void> resetToDefault() async {
    await _storage.write(key: _useCustomUrlKey, value: 'false');
  }

  /// Clear all custom configuration
  static Future<void> clearCustomConfig() async {
    await _storage.delete(key: _customUrlKey);
    await _storage.delete(key: _useCustomUrlKey);
  }

  /// Get the default URL (from constants)
  static String getDefaultUrl() {
    return ApiConstants.baseUrl;
  }

  /// Validate URL format
  static bool _isValidUrl(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return false;
    }
    
    try {
      final uri = Uri.parse(url);
      return uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Build endpoint URL with current configuration
  static Future<String> buildEndpoint(String endpoint) async {
    final baseUrl = await getApiUrl();
    
    // Remove trailing slash from base URL if present
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    
    // Remove leading slash from endpoint if present
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    
    return '$cleanBase/$cleanEndpoint';
  }
}
