import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/features/auth/domain/errors/auth_exception.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_in_state.dart';

import '../../fakes/fake_auth_repository.dart';

void main() {
  group('SignInCubit', () {
    late FakeAuthRepository authRepository;

    setUp(() {
      authRepository = FakeAuthRepository();
    });

    test('starts with initial status', () {
      final cubit = SignInCubit(authRepository);
      addTearDown(cubit.close);

      expect(cubit.state.status, SignInStatus.initial);
    });

    blocTest<SignInCubit, SignInState>(
      'emits submitting then success when sign-in succeeds',
      build: () => SignInCubit(authRepository),
      act: (cubit) =>
          cubit.signIn(email: 'user@example.com', password: '12345678'),
      expect: () => [
        isA<SignInState>().having(
          (state) => state.status,
          'status',
          SignInStatus.submitting,
        ),
        isA<SignInState>().having(
          (state) => state.status,
          'status',
          SignInStatus.success,
        ),
      ],
      verify: (_) {
        expect(authRepository.receivedEmail, 'user@example.com');
        expect(authRepository.receivedPassword, '12345678');
      },
    );

    blocTest<SignInCubit, SignInState>(
      'emits submitting then failure when repository throws AuthException',
      setUp: () {
        authRepository = FakeAuthRepository(
          error: const AuthException('Invalid email or password'),
        );
      },
      build: () => SignInCubit(authRepository),
      act: (cubit) =>
          cubit.signIn(email: 'user@example.com', password: 'wrong-password'),
      expect: () => [
        isA<SignInState>().having(
          (state) => state.status,
          'status',
          SignInStatus.submitting,
        ),
        isA<SignInState>()
            .having((state) => state.status, 'status', SignInStatus.failure)
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              'Invalid email or password',
            ),
      ],
    );
  });
}
