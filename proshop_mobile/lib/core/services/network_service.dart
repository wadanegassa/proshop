import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';

/// Network service for testing backend connectivity and providing detailed diagnostics
class NetworkService {
  /// Test the connection to the backend server
  /// Returns a NetworkTestResult with status, latency, and error details
  static Future<NetworkTestResult> testConnection() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      // Try to reach the backend's root endpoint
      final Future<http.Response> future = http.get(
        Uri.parse(ApiConstants.baseUrl.replaceAll('/api/v1', '')),
        headers: ApiConstants.defaultHeaders,
      );
      
      final response = await future.timeout(
        ApiConstants.connectionTimeout,
        onTimeout: () {
          throw TimeoutException('Connection timed out after ${ApiConstants.connectionTimeout.inSeconds} seconds');
        },
      );
      
      stopwatch.stop();
      
      if (response.statusCode == 200) {
        return NetworkTestResult(
          isSuccess: true,
          latencyMs: stopwatch.elapsedMilliseconds,
          message: 'Connected successfully',
        );
      } else {
        return NetworkTestResult(
          isSuccess: false,
          latencyMs: stopwatch.elapsedMilliseconds,
          message: 'Server returned status ${response.statusCode}',
          errorType: NetworkErrorType.serverError,
        );
      }
    } on SocketException catch (e) {
      stopwatch.stop();
      return NetworkTestResult(
        isSuccess: false,
        latencyMs: stopwatch.elapsedMilliseconds,
        message: 'Cannot reach server',
        errorType: NetworkErrorType.connectionRefused,
        troubleshooting: _getConnectionRefusedHelp(),
        technicalDetails: e.toString(),
      );
    } on TimeoutException catch (e) {
      stopwatch.stop();
      return NetworkTestResult(
        isSuccess: false,
        latencyMs: stopwatch.elapsedMilliseconds,
        message: 'Connection timed out',
        errorType: NetworkErrorType.timeout,
        troubleshooting: _getTimeoutHelp(),
        technicalDetails: e.toString(),
      );
    } on HttpException catch (e) {
      stopwatch.stop();
      return NetworkTestResult(
        isSuccess: false,
        latencyMs: stopwatch.elapsedMilliseconds,
        message: 'HTTP error occurred',
        errorType: NetworkErrorType.httpError,
        technicalDetails: e.toString(),
      );
    } catch (e) {
      stopwatch.stop();
      return NetworkTestResult(
        isSuccess: false,
        latencyMs: stopwatch.elapsedMilliseconds,
        message: 'Unexpected error: ${e.toString()}',
        errorType: NetworkErrorType.unknown,
        technicalDetails: e.toString(),
      );
    }
  }

  /// Test a specific endpoint with authentication
  static Future<NetworkTestResult> testAuthenticatedEndpoint(String token) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final Future<http.Response> future = http.get(
        Uri.parse(ApiConstants.profile),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      );
      
      final response = await future.timeout(ApiConstants.connectionTimeout);
      
      stopwatch.stop();
      
      if (response.statusCode == 200) {
        return NetworkTestResult(
          isSuccess: true,
          latencyMs: stopwatch.elapsedMilliseconds,
          message: 'Authentication successful',
        );
      } else {
        final body = json.decode(response.body);
        return NetworkTestResult(
          isSuccess: false,
          latencyMs: stopwatch.elapsedMilliseconds,
          message: body['message'] ?? 'Authentication failed',
          errorType: NetworkErrorType.authError,
        );
      }
    } catch (e) {
      stopwatch.stop();
      return NetworkTestResult(
        isSuccess: false,
        latencyMs: stopwatch.elapsedMilliseconds,
        message: 'Failed to verify authentication',
        errorType: NetworkErrorType.unknown,
        technicalDetails: e.toString(),
      );
    }
  }

  static String _getConnectionRefusedHelp() {
    return '''
• Make sure your phone and computer are on the same WiFi network
• Check if the backend server is running (npm run dev)
• Verify the IP address in Settings matches your computer's IP
• Run 'hostname -I' on your computer to find the correct IP
• Disable firewall temporarily to test if it's blocking connections
''';
  }

  static String _getTimeoutHelp() {
    return '''
• Check your WiFi connection strength
• Make sure the backend server is responding
• The IP address might be incorrect
• Your network might be blocking the connection
• Try restarting the backend server
''';
  }

  /// Extract just the base URL (without /api/v1) for display
  static String getDisplayUrl() {
    return ApiConstants.baseUrl;
  }

  /// Extract host and port for display
  static Map<String, String> getConnectionInfo() {
    final uri = Uri.parse(ApiConstants.baseUrl);
    return {
      'host': uri.host,
      'port': uri.port.toString(),
      'protocol': uri.scheme,
      'fullUrl': ApiConstants.baseUrl,
    };
  }
}

/// Result of a network connectivity test
class NetworkTestResult {
  final bool isSuccess;
  final int latencyMs;
  final String message;
  final NetworkErrorType? errorType;
  final String? troubleshooting;
  final String? technicalDetails;

  NetworkTestResult({
    required this.isSuccess,
    required this.latencyMs,
    required this.message,
    this.errorType,
    this.troubleshooting,
    this.technicalDetails,
  });

  /// Get a user-friendly error message
  String getUserMessage() {
    if (isSuccess) {
      return 'Connected in ${latencyMs}ms';
    }
    
    switch (errorType) {
      case NetworkErrorType.connectionRefused:
        return 'Cannot reach the server. Check your network and server status.';
      case NetworkErrorType.timeout:
        return 'Connection timed out. Check your WiFi connection.';
      case NetworkErrorType.authError:
        return message;
      case NetworkErrorType.serverError:
        return message;
      default:
        return 'Connection failed: $message';
    }
  }

  /// Get detailed technical information for debugging
  String getDetailedMessage() {
    final buffer = StringBuffer();
    buffer.writeln(message);
    
    if (troubleshooting != null) {
      buffer.writeln('\nTroubleshooting:');
      buffer.writeln(troubleshooting);
    }
    
    if (technicalDetails != null) {
      buffer.writeln('\nTechnical Details:');
      buffer.writeln(technicalDetails);
    }
    
    return buffer.toString();
  }
}

/// Types of network errors for better error handling
enum NetworkErrorType {
  connectionRefused,
  timeout,
  authError,
  serverError,
  httpError,
  unknown,
}
