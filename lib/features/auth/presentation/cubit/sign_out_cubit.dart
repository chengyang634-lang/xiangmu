import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit(this._authRepository) : super(const SignOutState());

  final AuthRepository _authRepository;

  Future<void> signOut() async {
    emit(const SignOutState(status: SignOutStatus.submitting));

    try {
      await _authRepository.signOut();

      emit(const SignOutState(status: SignOutStatus.success));
    } catch (_) {
      emit(
        const SignOutState(
          status: SignOutStatus.failure,
          errorMessage: 'Sign-out failed',
        ),
      );
    }
  }
}
