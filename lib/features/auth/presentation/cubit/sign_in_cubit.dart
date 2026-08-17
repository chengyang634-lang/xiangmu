import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(const SignInState());

  void startSubmitting() {
    emit(const SignInState(status: SignInStatus.submitting));
  }

  void markSuccess() {
    emit(const SignInState(status: SignInStatus.success));
  }

  void markFailure(String message) {
    emit(SignInState(status: SignInStatus.failure, errorMessage: message));
  }
}
