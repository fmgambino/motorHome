import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:motor_home/core/config/adapters/dio_error_adapter.dart';
import 'package:motor_home/core/config/interfaces/http_request_interface.dart';
import 'package:motor_home/injection_container.dart';

class DioAdapter extends IHttpRequest<Either<DioErrorAdapter, Response<dynamic>>> {
  DioAdapter() : this._init();

  DioAdapter._init() {
    dio = sl<Dio>();
    dio.interceptors.add(LogInterceptor());
    dio.interceptors.add(ManageInterceptor());
  }
  late Dio dio;

  @override
  Future<Either<DioErrorAdapter, Response>> delete<DioErrorAdapter, Response>({
    required String url,
  }) async {
    return _request(
      request: () => dio.delete(url),
      url: url,
    );
  }

  @override
  Future<Either<DioErrorAdapter, Response>> download<DioErrorAdapter, Response>({
    required String url,
    required String directory,
  }) async {
    return _request(
      request: () => dio.download(url, directory),
      url: url,
    );
  }

  @override
  Future<Either<DioErrorAdapter, Response>> get<DioErrorAdapter, Response>({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _request(
      request: () => dio.get(
        url,
        queryParameters: queryParameters,
      ),
      url: url,
    );
  }

  @override
  Future<Either<L, R>> post<L, R>({
    required String url,
    dynamic data,
  }) async {
    return _request(
      request: () => dio.post(url, data: data),
      url: url,
    );
  }

  @override
  Future<Either<DioErrorAdapter, Response>> put<DioErrorAdapter, Response>({
    required String url,
  }) async {
    return _request(
      request: () => dio.put(url),
      url: url,
    );
  }

  Future<Either<L, R>> _request<L, R>({
    required Future<Response<dynamic>> Function() request,
    required String url,
  }) async {
    final uri = Uri.parse(url);
    if (!uri.hasScheme) {
      dio.options.baseUrl = dotenv.env['BASE_URL']!;
    }
    try {
      final response = await request();
      return Right(response as R);
    } on DioException catch (error) {
      return Left(DioErrorAdapter(error: error, stackTrace: StackTrace.current) as L);
    } catch (error, stackTrace) {
      return Left(DioErrorAdapter(e: error, stackTrace: stackTrace) as L);
    }
  }
}

class ManageInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }
}
