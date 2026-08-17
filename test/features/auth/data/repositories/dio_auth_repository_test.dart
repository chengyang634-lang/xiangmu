import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/features/auth/data/repositories/dio_auth_repository.dart';
import 'package:pulsedesk/features/auth/domain/errors/auth_exception.dart';

import '../../fakes/fake_auth_token_storage.dart';

void main() {
  group('DioAuthRepository', () {
    test('sends sign-in request and saves access token', () async {
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
                data: {'accessToken': 'example-access-token'},
              ),
            );
          },
        ),
      );

      final tokenStorage = FakeAuthTokenStorage();

      final repository = DioAuthRepository(dio, tokenStorage);

      await repository.signIn(email: 'user@example.com', password: '12345678');

      expect(capturedRequest?.method, 'POST');

      expect(capturedRequest?.path, '/api/auth/sign-in');

      expect(capturedRequest?.data, {
        'email': 'user@example.com',
        'password': '12345678',
      });

      expect(tokenStorage.savedAccessToken, 'example-access-token');
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

      final tokenStorage = FakeAuthTokenStorage();

      final repository = DioAuthRepository(dio, tokenStorage);

      await expectLater(
        repository.signIn(
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

      expect(tokenStorage.savedAccessToken, isNull);
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

      final tokenStorage = FakeAuthTokenStorage();

      final repository = DioAuthRepository(dio, tokenStorage);

      await expectLater(
        repository.signIn(email: 'user@example.com', password: '12345678'),
        throwsA(
          isA<AuthException>().having(
            (error) => error.message,
            'message',
            'Sign-in failed',
          ),
        ),
      );

      expect(tokenStorage.savedAccessToken, isNull);
    });

    test(
      'throws AuthException when success response has no access token',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));

        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'user': {'id': 'user_123'},
                  },
                ),
              );
            },
          ),
        );

        final tokenStorage = FakeAuthTokenStorage();

        final repository = DioAuthRepository(dio, tokenStorage);

        await expectLater(
          repository.signIn(email: 'user@example.com', password: '12345678'),
          throwsA(
            isA<AuthException>().having(
              (error) => error.message,
              'message',
              'Invalid sign-in response',
            ),
          ),
        );

        expect(tokenStorage.savedAccessToken, isNull);
      },
    );

    test('returns true when access token is stored', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));

      final tokenStorage = FakeAuthTokenStorage();

      await tokenStorage.saveAccessToken('example-access-token');

      final repository = DioAuthRepository(dio, tokenStorage);

      final hasStoredSession = await repository.hasStoredSession();

      expect(hasStoredSession, isTrue);
    });

    test('returns false when no access token is stored', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));

      final tokenStorage = FakeAuthTokenStorage();

      final repository = DioAuthRepository(dio, tokenStorage);

      final hasStoredSession = await repository.hasStoredSession();

      expect(hasStoredSession, isFalse);
    });

    test('returns false when stored access token is empty', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));

      final tokenStorage = FakeAuthTokenStorage();

      await tokenStorage.saveAccessToken('');

      final repository = DioAuthRepository(dio, tokenStorage);

      final hasStoredSession = await repository.hasStoredSession();

      expect(hasStoredSession, isFalse);
    });
    test('deletes stored access token when signing out', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));

      final tokenStorage = FakeAuthTokenStorage();

      await tokenStorage.saveAccessToken('example-access-token');

      final repository = DioAuthRepository(dio, tokenStorage);

      await repository.signOut();

      final accessToken = await tokenStorage.readAccessToken();

      expect(accessToken, isNull);
    });
  });
}
