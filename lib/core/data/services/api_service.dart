import 'dart:developer';

import 'package:dio/dio.dart';

import '../../constants/app_url.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;

  void _ensureInitialized() {
    try {
      _dio;
    } catch (e) {
      initialize();
    }
  }

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppUrl.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  // Authentication APIs

  // Error handling
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message =
              error.response?.data?['message'] ?? 'Server error occurred';
          return 'Error $statusCode: $message';
        case DioExceptionType.cancel:
          return 'Request was cancelled';
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network.';
        case DioExceptionType.badCertificate:
          return 'Certificate error occurred';
        case DioExceptionType.unknown:
          return 'An unexpected error occurred';
      }
    }
    return error.toString();
  }
}
