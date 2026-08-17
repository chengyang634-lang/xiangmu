import 'package:dio/dio.dart';

import '../../domain/entities/current_user.dart';
import '../../domain/errors/current_user_exception.dart';
import '../../domain/repositories/current_user_repository.dart';

class DioCurrentUserRepository implements CurrentUserRepository {
  DioCurrentUserRepository(this._dio);

  final Dio _dio;

  @override
  Future<CurrentUser> getCurrentUser() async {
    try {
      final response = await _dio.get<dynamic>('/api/users/me');

      final data = response.data;

      if (data is! Map) {
        throw const CurrentUserException('Invalid current user response');
      }

      final id = data['id'];
      final email = data['email'];
      final displayName = data['displayName'];

      if (id is! String ||
          id.isEmpty ||
          email is! String ||
          email.isEmpty ||
          displayName is! String ||
          displayName.isEmpty) {
        throw const CurrentUserException('Invalid current user response');
      }

      return CurrentUser(id: id, email: email, displayName: displayName);
    } on CurrentUserException {
      rethrow;
    } on DioException catch (error) {
      final data = error.response?.data;

      if (data is Map) {
        final message = data['message'];

        if (message is String && message.isNotEmpty) {
          throw CurrentUserException(message);
        }
      }

      throw const CurrentUserException('Failed to load current user');
    }
  }
}
