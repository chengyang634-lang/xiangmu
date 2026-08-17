import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/features/auth/data/storage/secure_auth_token_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecureAuthTokenStorage', () {
    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    test('saves access token', () async {
      const secureStorage = FlutterSecureStorage();

      final tokenStorage = SecureAuthTokenStorage(secureStorage);

      await tokenStorage.saveAccessToken('example-access-token');

      final savedToken = await secureStorage.read(key: 'access_token');

      expect(savedToken, 'example-access-token');
    });
  });
  test('reads saved access token', () async {
    const secureStorage = FlutterSecureStorage();

    final tokenStorage = SecureAuthTokenStorage(secureStorage);

    await tokenStorage.saveAccessToken('example-access-token');

    final accessToken = await tokenStorage.readAccessToken();

    expect(accessToken, 'example-access-token');
  });
}
