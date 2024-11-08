import 'dart:convert';

import 'package:dio/dio.dart';

class ErrorMessages {
  static const defaultMessage = 'serverError';
}

bool isJsonObject(dynamic data) {
  try {
    if (data is Map) {
      return true;
    }
    Map<String, dynamic> parsedData = jsonDecode(data);
    // ignore: unnecessary_type_check
    return parsedData is Map;
  } catch (e) {
    return false;
  }
}

String getErrorMessage(Object? obj) {
  if (obj == null) {
    return 'serverError';
  }

  if (obj is! DioException) {
    return 'serverError';
  }

  if (obj.type == DioExceptionType.connectionTimeout ||
      obj.type == DioExceptionType.sendTimeout ||
      obj.type == DioExceptionType.receiveTimeout) {
    return 'connectionError';
  }

  if (obj.type == DioExceptionType.badResponse) {
    final dataResponse = obj.response?.data;
    if (dataResponse == null) {
      return 'cancelApiError';
    }

    try {
      if (isJsonObject(dataResponse)) {
        final errData = dataResponse is String
            ? jsonDecode(dataResponse)
            : dataResponse as Map;
        if (errData.containsKey('content')) {
          return errData['content'];
        }

        if (errData.containsKey('message')) {
          return errData['message'];
        }
      }
    } catch (e) {
      return 'cancelApiError';
    }
  }

  if (obj.type == DioExceptionType.cancel) {
    return 'cancelApiError';
  }

  return 'serverError';
}
