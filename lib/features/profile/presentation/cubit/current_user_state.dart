import '../../domain/entities/current_user.dart';

enum CurrentUserStatus { initial, loading, success, failure }

class CurrentUserState {
  const CurrentUserState({
    this.status = CurrentUserStatus.initial,
    this.user,
    this.errorMessage,
  });

  final CurrentUserStatus status;
  final CurrentUser? user;
  final String? errorMessage;
}
