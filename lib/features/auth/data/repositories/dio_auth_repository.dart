import 'package:dio/dio.dart';

import '../../domain/errors/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/storage/auth_token_storage.dart';

class DioAuthRepository implements AuthRepository {
  DioAuthRepository(this._dio, this._tokenStorage);

  final Dio _dio;
  final AuthTokenStorage _tokenStorage;

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/auth/sign-in',
        data: {'email': email, 'password': password},
      );

      final data = response.data;

      if (data is! Map) {
        throw const AuthException('Invalid sign-in response');
      }

      final accessToken = data['accessToken'];

      if (accessToken is! String || accessToken.isEmpty) {
        throw const AuthException('Invalid sign-in response');
      }

      await _tokenStorage.saveAccessToken(accessToken);
    } on AuthException {
      rethrow;
    } on DioException catch (error) {
      final data = error.response?.data;

      if (data is Map) {
        final message = data['message'];

        if (message is String && message.isNotEmpty) {
          throw AuthException(message);
        }
      }

      throw const AuthException('Sign-in failed');
    }
  }
}
