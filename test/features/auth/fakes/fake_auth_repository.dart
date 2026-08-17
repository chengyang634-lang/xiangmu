import 'package:pulsedesk/features/auth/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.error, this.result, this.storedSession = false});

  final Object? error;
  final Future<void>? result;
  final bool storedSession;

  String? receivedEmail;
  String? receivedPassword;

  @override
  Future<void> signIn({required String email, required String password}) async {
    receivedEmail = email;
    receivedPassword = password;

    final pendingResult = result;

    if (pendingResult != null) {
      await pendingResult;
    }

    final failure = error;

    if (failure != null) {
      throw failure;
    }
  }

  @override
  Future<bool> hasStoredSession() async {
    return storedSession;
  }
}
