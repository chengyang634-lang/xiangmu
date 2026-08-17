import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/sign_in_state.dart';

void main() {
  group('SignInCubit', () {
    test('starts with initial status', () {
      final cubit = SignInCubit();
      addTearDown(cubit.close);

      expect(cubit.state.status, SignInStatus.initial);
    });

    blocTest<SignInCubit, SignInState>(
      'emits submitting status',
      build: SignInCubit.new,
      act: (cubit) => cubit.startSubmitting(),
      expect: () => [
        isA<SignInState>().having(
          (state) => state.status,
          'status',
          SignInStatus.submitting,
        ),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits success status',
      build: SignInCubit.new,
      act: (cubit) => cubit.markSuccess(),
      expect: () => [
        isA<SignInState>().having(
          (state) => state.status,
          'status',
          SignInStatus.success,
        ),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits failure status with message',
      build: SignInCubit.new,
      act: (cubit) => cubit.markFailure('Invalid credentials'),
      expect: () => [
        isA<SignInState>()
            .having((state) => state.status, 'status', SignInStatus.failure)
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              'Invalid credentials',
            ),
      ],
    );
  });
}
