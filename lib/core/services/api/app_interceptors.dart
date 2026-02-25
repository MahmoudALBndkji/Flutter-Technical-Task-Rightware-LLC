import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_technical_task_rightware_llc/core/log/logger.dart';

class AppIntercepters extends Interceptor {
  final Dio client;
  AppIntercepters({required this.client});

  // Controls a single refresh flow at a time
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers[HttpHeaders.acceptHeader] = ContentType.json;

    // if (CacheHelper.getData(key: "accessToken") != null) {
    //   options.headers[HttpHeaders.authorizationHeader] =
    //       "Bearer ${CacheHelper.getData(key: "accessToken") ?? ""}";
    // }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    Logger.error(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );

    super.onError(err, handler);
    // Only handle 401 for non-auth endpoints to avoid infinite loop
    // final isUnauthorized = err.response?.statusCode == 401;
    // final isAuthEndpoint = err.requestOptions.path.contains(EndPoints.login) ||
    //     err.requestOptions.path.contains(EndPoints.refreshToken);

    // if (isUnauthorized && !isAuthEndpoint) {
    //   try {
    //     // If a refresh is already in progress, wait for it to complete then retry
    //     if (_isRefreshing) {
    //       await _refreshCompleter?.future;
    //       // Update the failed request with new token and retry
    //       final newToken = CacheHelper.getData(key: "accessToken") ?? "";
    //       err.requestOptions.headers[HttpHeaders.authorizationHeader] =
    //           "Bearer $newToken";
    //       final response = await _retry(err.requestOptions);
    //       return handler.resolve(response);
    //     }

    //     // Start a new refresh flow
    //     _isRefreshing = true;
    //     _refreshCompleter = Completer<void>();

    //     final refreshed = await _refreshToken();
    //     _refreshCompleter?.complete();
    //     _isRefreshing = false;

    //     if (refreshed) {
    //       final newToken = CacheHelper.getData(key: "accessToken") ?? "";
    //       err.requestOptions.headers[HttpHeaders.authorizationHeader] =
    //           "Bearer $newToken";
    //       final response = await _retry(err.requestOptions);
    //       return handler.resolve(response);
    //     } else {
    //       _forceLogoutAndNavigateToLogin();
    //       return handler.next(err);
    //     }
    //   } catch (e) {
    //     _refreshCompleter?.completeError(e);
    //     _isRefreshing = false;
    //     _forceLogoutAndNavigateToLogin();
    //     return handler.next(err);
    //   } finally {
    //   }
    // } else {
    //   super.onError(err, handler);
    // }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return client.request<dynamic>(
      requestOptions.path,
      options: options,
      queryParameters: requestOptions.queryParameters,
      data: requestOptions.data,
    );
  }

  // Future<bool> _refreshToken() async {
  //   final storedRefreshToken = CacheHelper.getData(key: "refreshToken");
  //   if (storedRefreshToken == null || storedRefreshToken.toString().isEmpty) {
  //     return false;
  //   }
  //   try {
  //     final response = await client.post(
  //       EndPoints.refreshToken,
  //       data: {
  //         'client_id': 'takaful_erp_App',
  //         'grant_type': 'refresh_token',
  //         'refresh_token': storedRefreshToken,
  //         'scope': 'offline_access takaful_erp',
  //       },
  //       options: Options(
  //         contentType: Headers.formUrlEncodedContentType,
  //         headers: {"Content-Type": "application/x-www-form-urlencoded"},
  //       ),
  //     );

  //     // ResponseType is plain; parse manually
  //     final dynamic raw = response.data;
  //     final Map<String, dynamic> json =
  //         raw is String ? jsonDecode(raw) : (raw as Map<String, dynamic>);

  //     final String? accessToken = json['access_token']?.toString();
  //     final String? refreshToken = json['refresh_token']?.toString();
  //     if (accessToken == null || accessToken.isEmpty) {
  //       return false;
  //     }

  //     await CacheHelper.saveData(key: "accessToken", value: accessToken);
  //     if (refreshToken != null && refreshToken.isNotEmpty) {
  //       await CacheHelper.saveData(key: "refreshToken", value: refreshToken);
  //     }
  //     return true;
  //   } on DioException catch (e) {
  //     Logger.error('Refresh token failed: ${e.response?.statusCode}');
  //     return false;
  //   } catch (e) {
  //     Logger.error('Refresh token unexpected error: $e');
  //     return false;
  //   }
  // }

  // void _forceLogoutAndNavigateToLogin() async {
  //   try {
  //     await CacheHelper.saveData(key: "isLogin", value: false);
  //     await CacheHelper.removeData(key: "accessToken");
  //     await CacheHelper.removeData(key: "refreshToken");
  //   } catch (_) {}
  //   // Navigate to Login using global navigator key (no BuildContext in interceptor)
  //   final navigator = rootNavigatorKey.currentState;
  //   if (navigator != null) {
  //     navigator.pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (_) => const LoginPage()),
  //       (route) => false,
  //     );
  //   }
  // }
}
