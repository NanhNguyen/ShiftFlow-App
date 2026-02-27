import 'package:dio/dio.dart';
import '../../foundation/storage/token_storage.dart';
import 'api_client.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;

  AuthInterceptor(this._tokenStorage, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Use a clean Dio instance for refresh to avoid interceptor recursion
          final refreshDio = Dio(BaseOptions(baseUrl: ApiClient.baseUrl));
          final res = await refreshDio.post(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          final newToken = res.data['access_token'];
          await _tokenStorage.saveAccessToken(newToken);

          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          await _tokenStorage.clearTokens();
          return handler.next(err);
        }
      }
    }
    return handler.next(err);
  }
}
