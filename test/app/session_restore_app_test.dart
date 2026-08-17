import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/app/app.dart';
import 'package:pulsedesk/app/router/app_router.dart';
import 'package:pulsedesk/features/auth/data/repositories/dio_auth_repository.dart';

import '../features/auth/fakes/fake_auth_repository.dart';
import '../features/auth/fakes/fake_auth_token_storage.dart';

void main() {
  testWidgets('opens home on launch when a stored session exists', (
    tester,
  ) async {
    final authRepository = FakeAuthRepository(storedSession: true);

    final router = createAppRouter(authRepository: authRepository);

    addTearDown(router.dispose);

    await tester.pumpWidget(PulseDeskApp(router: router));

    await tester.pumpAndSettle();

    expect(find.text('PulseDesk Home'), findsOneWidget);
  });
  testWidgets('opens sign-in on launch when no stored session exists', (
    tester,
  ) async {
    final authRepository = FakeAuthRepository(storedSession: false);

    final router = createAppRouter(authRepository: authRepository);

    addTearDown(router.dispose);

    await tester.pumpWidget(PulseDeskApp(router: router));

    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);
  });
  testWidgets('opens sign-in on next launch after signing out', (tester) async {
    final tokenStorage = FakeAuthTokenStorage();

    await tokenStorage.saveAccessToken('example-access-token');

    final authRepository = DioAuthRepository(
      Dio(BaseOptions(baseUrl: 'https://example.test')),
      tokenStorage,
    );

    final firstRouter = createAppRouter(authRepository: authRepository);

    addTearDown(firstRouter.dispose);

    await tester.pumpWidget(PulseDeskApp(router: firstRouter));

    await tester.pumpAndSettle();

    expect(find.text('PulseDesk Home'), findsOneWidget);

    await tester.tap(find.text('Sign out'));

    await tester.pumpAndSettle();

    expect(await tokenStorage.readAccessToken(), isNull);

    final secondRouter = createAppRouter(authRepository: authRepository);

    addTearDown(secondRouter.dispose);

    await tester.pumpWidget(PulseDeskApp(router: secondRouter));

    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);

    expect(find.text('PulseDesk Home'), findsNothing);
  });
}
