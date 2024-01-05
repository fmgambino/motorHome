import 'package:dio/dio.dart';

class HttpError {
  HttpError({
    this.error,
    this.stackTrace,
    this.e,
  });

  final DioException? error;
  final StackTrace? stackTrace;
  final Object? e;
}
