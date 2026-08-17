abstract class AuthTokenStorage {
  Future<void> saveAccessToken(String accessToken);

  Future<String?> readAccessToken();

  Future<void> deleteAccessToken();
}
