import 'package:dio/dio.dart';

import '../../domain/errors/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';

class DioAuthRepository implements AuthRepository {
  DioAuthRepository(this._dio);

  final Dio _dio;

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _dio.post<dynamic>(
        '/api/auth/sign-in',
        data: {'email': email, 'password': password},
      );
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
