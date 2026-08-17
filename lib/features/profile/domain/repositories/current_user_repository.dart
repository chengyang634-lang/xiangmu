import '../entities/current_user.dart';

abstract class CurrentUserRepository {
  Future<CurrentUser> getCurrentUser();
}
