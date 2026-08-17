import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/storage/auth_token_storage.dart';

class SecureAuthTokenStorage implements AuthTokenStorage {
  SecureAuthTokenStorage(this._storage);

  static const _accessTokenKey = 'access_token';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveAccessToken(String accessToken) {
    return _storage.write(key: _accessTokenKey, value: accessToken);
  }

  @override
  Future<String?> readAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  @override
  Future<void> deleteAccessToken() {
    return _storage.delete(key: _accessTokenKey);
  }
}
