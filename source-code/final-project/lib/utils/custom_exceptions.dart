import 'package:dio/dio.dart';

class CustomException implements Exception {
late String message;

CustomException.fromDio(DioException dioException) {
  switch (dioException.type) {
    case DioExceptionType.cancel:
      message = "Request to API server was cancelled";
      break;
    case DioExceptionType.connectionTimeout:
      message = "Connection timeout with API server";
      break;
    case DioExceptionType.receiveTimeout:
      message = "Receive timeout in connection with API server";
      break;
    case DioExceptionType.sendTimeout:
      message = "Send timeout in connection with API server";
      break;
    case DioExceptionType.connectionError:
        message = 'No Internet Connection Found';
        break;  
    default:
       message = _handleStatusCode(
        dioException.response?.statusCode,
      );
      break;
  }
}

String _handleStatusCode(int? statusCode) {
  switch (statusCode) {
    case 400:
      return 'Bad request';
    case 401:
      return 'Unauthorized';
    case 403:
      return 'Forbidden';
    case 404:
      return 'Resource not found';
    case 500:
      return 'Internal server error';
    case 502:
      return 'Bad gateway';
    default:
      return 'Oops something went wrong';
  }
}

@override
String toString() => message;
}
