import '../entity/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers(int page);
}
