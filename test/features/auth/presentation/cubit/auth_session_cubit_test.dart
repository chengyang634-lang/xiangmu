import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/auth_session_cubit.dart';
import 'package:pulsedesk/features/auth/presentation/cubit/auth_session_state.dart';

import '../../fakes/fake_auth_repository.dart';

void main() {
  blocTest<AuthSessionCubit, AuthSessionState>(
    'emits authenticated when a stored session exists',
    build: () {
      return AuthSessionCubit(FakeAuthRepository(storedSession: true));
    },
    act: (cubit) => cubit.checkSession(),
    expect: () => [
      isA<AuthSessionState>().having(
        (state) => state.status,
        'status',
        AuthSessionStatus.authenticated,
      ),
    ],
  );
  blocTest<AuthSessionCubit, AuthSessionState>(
    'emits unauthenticated when no stored session exists',
    build: () {
      return AuthSessionCubit(FakeAuthRepository(storedSession: false));
    },
    act: (cubit) => cubit.checkSession(),
    expect: () => [
      isA<AuthSessionState>().having(
        (state) => state.status,
        'status',
        AuthSessionStatus.unauthenticated,
      ),
    ],
  );
}
