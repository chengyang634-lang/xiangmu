enum SignInStatus { initial, submitting, success, failure }

class SignInState {
  const SignInState({this.status = SignInStatus.initial, this.errorMessage});

  final SignInStatus status;
  final String? errorMessage;
}
