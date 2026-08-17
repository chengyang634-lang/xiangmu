import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/errors/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepository) : super(const SignInState());

  final AuthRepository _authRepository;

  Future<void> signIn({required String email, required String password}) async {
    emit(const SignInState(status: SignInStatus.submitting));

    try {
      await _authRepository.signIn(email: email, password: password);

      emit(const SignInState(status: SignInStatus.success));
    } on AuthException catch (error) {
      emit(
        SignInState(status: SignInStatus.failure, errorMessage: error.message),
      );
    } catch (_) {
      emit(
        const SignInState(
          status: SignInStatus.failure,
          errorMessage: 'Sign-in failed',
        ),
      );
    }
  }

  void markFailure(String message) {
    emit(SignInState(status: SignInStatus.failure, errorMessage: message));
  }
}
