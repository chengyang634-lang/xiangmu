enum AuthSessionStatus { checking, authenticated, unauthenticated }

class AuthSessionState {
  const AuthSessionState({this.status = AuthSessionStatus.checking});

  final AuthSessionStatus status;
}
