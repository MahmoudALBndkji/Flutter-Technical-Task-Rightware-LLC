import 'dart:async';
import 'dart:io';
import 'package:flutter_technical_task_rightware_llc/core/env/init_env.dart';
import 'package:flutter_technical_task_rightware_llc/core/errors/failures.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../injection_container.dart' as di;
import 'api_consumer.dart';
import 'app_interceptors.dart';

class DioConsumer extends ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    (client.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    client.options
      ..baseUrl = env.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false;
    client.interceptors.add(di.sl<AppIntercepters>());
    if (kDebugMode) {
      client.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
          enabled: kDebugMode,
        ),
      );
    }
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool formDataIsEnabled = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final options = Options(headers: headers);
      final requestedContentType =
          headers?['Content-Type'] ?? headers?['content-type'];
      if (requestedContentType == Headers.formUrlEncodedContentType ||
          requestedContentType == 'application/x-www-form-urlencoded') {
        options.contentType = Headers.formUrlEncodedContentType;
      }

      final response = await client.post(
        path,
        data: formDataIsEnabled ? FormData.fromMap(body!) : body,
        options: options,
        queryParameters: queryParameters,
      );

      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool responseIsParsing = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.patch(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.delete(
        path,
        data: body,
        options: Options(headers: headers),
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleDioError(DioException error) {
    throw ServerFailure.fromDioException(error);
  }
}
