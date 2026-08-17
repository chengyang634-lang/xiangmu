import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_session_state.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit(this._authRepository) : super(const AuthSessionState());

  final AuthRepository _authRepository;

  Future<void> checkSession() async {
    final hasStoredSession = await _authRepository.hasStoredSession();

    emit(
      AuthSessionState(
        status: hasStoredSession
            ? AuthSessionStatus.authenticated
            : AuthSessionStatus.unauthenticated,
      ),
    );
  }
}
