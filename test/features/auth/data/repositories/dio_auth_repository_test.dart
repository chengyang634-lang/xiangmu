import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/features/auth/data/repositories/dio_auth_repository.dart';
import 'package:pulsedesk/features/auth/domain/errors/auth_exception.dart';

void main() {
  group('DioAuthRepository', () {
    test('sends email and password to sign-in endpoint', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));

      RequestOptions? capturedRequest;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedRequest = options;

            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'accessToken': 'token'},
              ),
            );
          },
        ),
      );

      final repository = DioAuthRepository(dio);

      await repository.signIn(email: 'user@example.com', password: '12345678');

      expect(capturedRequest?.method, 'POST');

      expect(capturedRequest?.path, '/api/auth/sign-in');

      expect(capturedRequest?.data, {
        'email': 'user@example.com',
        'password': '12345678',
      });
    });

    test('throws AuthException with backend message on failure', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 401,
                  data: {'message': 'Invalid email or password'},
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );

      final repository = DioAuthRepository(dio);

      expect(
        () => repository.signIn(
          email: 'user@example.com',
          password: 'wrong-password',
        ),
        throwsA(
          isA<AuthException>().having(
            (error) => error.message,
            'message',
            'Invalid email or password',
          ),
        ),
      );
    });

    test('throws fallback AuthException when backend has no message', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 500,
                  data: {},
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );

      final repository = DioAuthRepository(dio);

      expect(
        () =>
            repository.signIn(email: 'user@example.com', password: '12345678'),
        throwsA(
          isA<AuthException>().having(
            (error) => error.message,
            'message',
            'Sign-in failed',
          ),
        ),
      );
    });
  });
}
