import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/errors/current_user_exception.dart';
import '../../domain/repositories/current_user_repository.dart';
import 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit(this._currentUserRepository)
    : super(const CurrentUserState());

  final CurrentUserRepository _currentUserRepository;

  Future<void> loadCurrentUser() async {
    emit(const CurrentUserState(status: CurrentUserStatus.loading));

    try {
      final user = await _currentUserRepository.getCurrentUser();

      emit(CurrentUserState(status: CurrentUserStatus.success, user: user));
    } on CurrentUserException catch (error) {
      emit(
        CurrentUserState(
          status: CurrentUserStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        const CurrentUserState(
          status: CurrentUserStatus.failure,
          errorMessage: 'Failed to load current user',
        ),
      );
    }
  }
}
