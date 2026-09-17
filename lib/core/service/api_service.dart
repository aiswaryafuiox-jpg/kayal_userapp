import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as g;
import '../const/api_routes.dart';
import '../utils/navigation/app_routes.dart';
import 'local_storage_service.dart';

class ApiService {
  final Dio _dio;
  final _storage = LocalStorageService();
  bool _isHandlingUnauthorized = false;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiRoutes.baseURL,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            "Accept": "application/json",
            "x-api-key": ApiRoutes.apiKey,
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.getString("auth_token");
          if (token != null &&
              token.trim().isNotEmpty &&
              !token.startsWith("pms_token_")) {
            options.headers["Authorization"] = "Bearer $token";
          }

          _logRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logError(e);
          final statusCode = e.response?.statusCode;

          if (statusCode == 401) {
            _handleUnauthorized();
          }
          return handler.next(e);
        },
      ),
    );
  }

  void _logRequest(RequestOptions options) {
    debugPrint('\n🌐 ==================== [API REQUEST] ====================');
    debugPrint(
      '➡️ URL: [${options.method.toUpperCase()}] ${options.baseUrl}${options.path}',
    );
    if (options.queryParameters.isNotEmpty) {
      debugPrint('🔍 Query Params: ${jsonEncode(options.queryParameters)}');
    }
    if (options.headers.isNotEmpty) {
      final safeHeaders = Map<String, dynamic>.from(options.headers);
      debugPrint('📋 Headers: ${jsonEncode(safeHeaders)}');
    }
    if (options.data != null) {
      if (options.data is FormData) {
        final formData = options.data as FormData;
        final fieldsMap = {
          for (var entry in formData.fields) entry.key: entry.value,
        };
        final filesMap = {
          for (var entry in formData.files) entry.key: entry.value.filename,
        };
        debugPrint(
          '📦 Body (FormData): {fields: $fieldsMap, files: $filesMap}',
        );
      } else if (options.data is Map || options.data is List) {
        try {
          debugPrint('📦 Body (JSON): ${jsonEncode(options.data)}');
        } catch (_) {
          debugPrint('📦 Body: ${options.data}');
        }
      } else {
        debugPrint('📦 Body: ${options.data}');
      }
    }
    debugPrint('========================================================\n');
  }

  void _logResponse(Response response) {
    debugPrint('\n✅ ==================== [API RESPONSE] ====================');
    debugPrint(
      '⬅️ URL: [${response.statusCode}] ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.baseUrl}${response.requestOptions.path}',
    );
    try {
      if (response.data is Map || response.data is List) {
        debugPrint('📄 Data: ${jsonEncode(response.data)}');
      } else {
        debugPrint('📄 Data: ${response.data}');
      }
    } catch (_) {
      debugPrint('📄 Data: ${response.data}');
    }
    debugPrint('=========================================================\n');
  }

  void _logError(DioException e) {
    debugPrint('\n❌ ==================== [API ERROR] ====================');
    debugPrint(
      '⬅️ URL: [${e.response?.statusCode ?? 'NO_STATUS'}] ${e.requestOptions.method.toUpperCase()} ${e.requestOptions.baseUrl}${e.requestOptions.path}',
    );
    debugPrint('⚠️ Error Message: ${e.message}');
    if (e.response?.data != null) {
      try {
        if (e.response!.data is Map || e.response!.data is List) {
          debugPrint('📄 Error Data: ${jsonEncode(e.response!.data)}');
        } else {
          debugPrint('📄 Error Data: ${e.response!.data}');
        }
      } catch (_) {
        debugPrint('📄 Error Data: ${e.response!.data}');
      }
    }
    debugPrint('=======================================================\n');
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic data,
    bool useFormData = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleResponse(
      () => _dio.post(
        endpoint,
        data: useFormData && data is Map
            ? FormData.fromMap(Map<String, dynamic>.from(data))
            : data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    return _handleResponse(
      () => _dio.get(endpoint, queryParameters: params, options: options),
    );
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    dynamic data,
    bool useFormData = false,
    Options? options,
  }) async {
    return _handleResponse(
      () => _dio.put(
        endpoint,
        data: useFormData && data is Map
            ? FormData.fromMap(Map<String, dynamic>.from(data))
            : data,
        options: options,
      ),
    );
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    return _handleResponse(
      () => _dio.delete(endpoint, data: data, options: options),
    );
  }

  Future<Map<String, dynamic>> _handleResponse(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();

      if (response.data is Map) {
        return Map<String, dynamic>.from(
          response.data as Map<dynamic, dynamic>,
        );
      }

      return {"data": response.data};
    } on DioException catch (e) {
      debugPrint("DioException handled: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("Unknown exception: $e");
      throw Exception("Unexpected error occurred");
    }
  }

  void _handleUnauthorized() {
    if (_isHandlingUnauthorized) return;

    final token = _storage.getString("auth_token");
    final hadToken =
        token != null &&
        token.trim().isNotEmpty &&
        !token.startsWith("pms_token_");

    _storage.remove("auth_token");
    _storage.saveBool("is_logged_in", false);

    // If user is a guest / unauthenticated, do not force redirect
    if (!hadToken) return;

    final currentRoute = g.Get.currentRoute;
    // Do not disrupt splash, onboarding, location, login/OTP screens, address, checkout, cart or order confirmation
    if (currentRoute == AppRoutes.login ||
        currentRoute == AppRoutes.splash ||
        currentRoute == AppRoutes.otpVerification ||
        currentRoute == AppRoutes.signin ||
        currentRoute == AppRoutes.onboarding ||
        currentRoute == AppRoutes.location ||
        currentRoute == AppRoutes.confirmlocation ||
        currentRoute == AppRoutes.notificationUpdate ||
        currentRoute == AppRoutes.home ||
        currentRoute == AppRoutes.popularNearYou ||
        currentRoute == AppRoutes.category ||
        currentRoute == AppRoutes.product ||
        currentRoute == AppRoutes.productDetail ||
        currentRoute == AppRoutes.addAddress ||
        currentRoute == AppRoutes.checkout ||
        currentRoute == AppRoutes.cart ||
        currentRoute == AppRoutes.success ||
        currentRoute == AppRoutes.orders) {
      return;
    }

    _isHandlingUnauthorized = true;

    try {
      g.Get.offAllNamed(AppRoutes.login);
      if (g.Get.context != null) {
        g.Get.snackbar(
          "Session Expired",
          "Please login to continue.",
          snackPosition: g.SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 2500),
        );
      }
    } catch (_) {
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        _isHandlingUnauthorized = false;
      });
    }
  }
}
