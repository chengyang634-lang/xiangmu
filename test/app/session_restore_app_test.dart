import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/app/app.dart';
import 'package:pulsedesk/app/router/app_router.dart';

import '../features/auth/fakes/fake_auth_repository.dart';

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
}
