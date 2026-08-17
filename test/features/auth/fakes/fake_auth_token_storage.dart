import 'package:pulsedesk/features/auth/domain/storage/auth_token_storage.dart';

class FakeAuthTokenStorage implements AuthTokenStorage {
  String? savedAccessToken;

  @override
  Future<void> saveAccessToken(String accessToken) async {
    savedAccessToken = accessToken;
  }

  @override
  Future<String?> readAccessToken() async {
    return savedAccessToken;
  }

  @override
  Future<void> deleteAccessToken() async {
    savedAccessToken = null;
  }
}
