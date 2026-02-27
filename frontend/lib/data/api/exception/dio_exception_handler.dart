import 'package:dio/dio.dart';

class DioExceptionHandler {
  static String handleException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.badResponse:
        final data = err.response?.data;
        if (data is Map && data.containsKey('message')) {
          return data['message'].toString();
        }
        return 'Server error: ${err.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      default:
        return 'Something went wrong. Please check your internet connection.';
    }
  }
}
