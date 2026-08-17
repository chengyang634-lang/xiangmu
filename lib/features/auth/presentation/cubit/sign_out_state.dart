enum SignOutStatus { initial, submitting, success, failure }

class SignOutState {
  const SignOutState({this.status = SignOutStatus.initial, this.errorMessage});

  final SignOutStatus status;
  final String? errorMessage;
}
