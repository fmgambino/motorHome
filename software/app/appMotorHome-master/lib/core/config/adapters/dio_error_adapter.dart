import 'package:dio/dio.dart';
import 'package:motor_home/core/config/interfaces/http_error_interface.dart';

/// Adapter class for handling Dio exceptions as HTTP errors.
class DioErrorAdapter implements IHttpError<DioException> {
  DioErrorAdapter({
    this.error,
    this.stackTrace,
    this.e,
  });

  @override
  final DioException? error;

  @override
  final StackTrace? stackTrace;

  @override
  final Object? e;
}
