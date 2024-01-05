import 'package:dartz/dartz.dart';

abstract class IHttpRequest<T> {
  Future<Either<L, R>> get<L, R>({
    required String url,
    Map<String, dynamic>? queryParameters,
  });

  Future<Either<L, R>> post<L, R>({required String url, dynamic data});

  Future<Either<L, R>> put<L, R>({required String url});

  Future<Either<L, R>> delete<L, R>({required String url});

  Future<Either<L, R>> download<L, R>({
    required String url,
    required String directory,
  });
}
