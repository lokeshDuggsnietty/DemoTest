import '../entity/user.dart';
import '../repository/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers({required this.repository});

  Future<List<User>> call(int page) {
    return repository.getUsers(page);
  }
}
