import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_out_cubit.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_out_state.dart';

import '../../fakes/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository authRepository;

  setUp(() {
    authRepository = FakeAuthRepository();
  });

  blocTest<SignOutCubit, SignOutState>(
    'emits submitting then success when sign-out succeeds',
    build: () {
      return SignOutCubit(authRepository);
    },
    act: (cubit) => cubit.signOut(),
    expect: () => [
      isA<SignOutState>().having(
        (state) => state.status,
        'status',
        SignOutStatus.submitting,
      ),
      isA<SignOutState>().having(
        (state) => state.status,
        'status',
        SignOutStatus.success,
      ),
    ],
    verify: (_) {
      expect(authRepository.signOutCalled, isTrue);
    },
  );

  blocTest<SignOutCubit, SignOutState>(
    'emits submitting then failure when sign-out fails',
    build: () {
      authRepository = FakeAuthRepository(
        signOutError: Exception('storage failed'),
      );

      return SignOutCubit(authRepository);
    },
    act: (cubit) => cubit.signOut(),
    expect: () => [
      isA<SignOutState>().having(
        (state) => state.status,
        'status',
        SignOutStatus.submitting,
      ),
      isA<SignOutState>()
          .having((state) => state.status, 'status', SignOutStatus.failure)
          .having(
            (state) => state.errorMessage,
            'errorMessage',
            'Sign-out failed',
          ),
    ],
    verify: (_) {
      expect(authRepository.signOutCalled, isTrue);
    },
  );
}
