import 'package:equatable/equatable.dart';

class ApiException extends Equatable implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  List<Object?> get props => [message, statusCode, data];

  @override
  String toString() {
    return 'ApiException: $message (Status Code: $statusCode)';
  }

  // Common HTTP status codes
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode >= 500;
  bool get isBadRequest => statusCode == 400;
  bool get isConflict => statusCode == 409;
  bool get isUnprocessableEntity => statusCode == 422;
}

class NetworkException extends ApiException {
  const NetworkException()
      : super(
          message: 'Network error. Please check your internet connection.',
          statusCode: 0,
        );
}

class TimeoutException extends ApiException {
  const TimeoutException()
      : super(
          message: 'Request timeout. Please try again.',
          statusCode: 408,
        );
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException()
      : super(
          message: 'Unauthorized. Please login again.',
          statusCode: 401,
        );
}

class ForbiddenException extends ApiException {
  const ForbiddenException()
      : super(
          message: 'Access forbidden.',
          statusCode: 403,
        );
}

class NotFoundException extends ApiException {
  const NotFoundException()
      : super(
          message: 'Requested resource not found.',
          statusCode: 404,
        );
}

class ServerException extends ApiException {
  const ServerException()
      : super(
          message: 'Internal server error. Please try again later.',
          statusCode: 500,
        );
}