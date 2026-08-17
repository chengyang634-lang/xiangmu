import 'package:dio/dio.dart';

typedef AccessTokenReader = Future<String?> Function();

Dio createAuthenticatedApiClient({
  required String baseUrl,
  required AccessTokenReader readAccessToken,
}) {
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final accessToken = await readAccessToken();

          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          handler.next(options);
        } catch (error, stackTrace) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: error,
              stackTrace: stackTrace,
              message: 'Failed to read access token',
            ),
          );
        }
      },
    ),
  );

  return dio;
}
