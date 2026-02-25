import 'dart:io';
import 'package:dio/dio.dart';
import 'error_message_parser.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/api/status_code.dart';
import 'package:flutter_technical_task_rightware_llc/core/languages/app_localizations.dart';

abstract class Failure implements Exception {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);

  factory ServerFailure.localized(String key) => ServerFailure(key);

  factory ServerFailure.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure.localized('connection_timeout'.tr());
      case DioExceptionType.badResponse:
        return _fromBadResponse(error.response);
      case DioExceptionType.cancel:
        return ServerFailure.localized('request_cancelled'.tr());
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return ServerFailure.localized('no_internet_connection'.tr());
        }
        return ServerFailure.localized('general_error'.tr());
      case DioExceptionType.badCertificate:
        return ServerFailure.localized('bad_certificate_error'.tr());
      case DioExceptionType.connectionError:
        return ServerFailure.localized('no_internet_connection'.tr());
    }
  }

  static ServerFailure _fromBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    final extracted = extractErrorMessageFromBody(data);
    if (extracted != null && extracted.toString().trim().isNotEmpty) {
      return ServerFailure(extracted.toString());
    }
    switch (statusCode) {
      case StatusCode.badRequest:
        return ServerFailure.localized('bad_request'.tr());
      case StatusCode.unauthorized:
        return ServerFailure.localized('unauthorized'.tr());
      case StatusCode.forbidden:
        return ServerFailure.localized('forbidden'.tr());
      case StatusCode.notFound:
        return ServerFailure.localized('not_found'.tr());
      case StatusCode.conflict:
        return ServerFailure.localized('conflict'.tr());
      case StatusCode.internalServerError:
        return ServerFailure.localized('internal_server_error'.tr());
      default:
        return ServerFailure.localized('general_error'.tr());
    }
  }
}

class OfflineFailure extends Failure {
  OfflineFailure(super.message);
}

class EmptyCacheFailure extends Failure {
  EmptyCacheFailure(super.message);
}
