import '../../domain/entity/user.dart';
import '../../domain/repository/user_repository.dart';
import '../datasourse/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<User>> getUsers(int page) async {
    final userModels = await remoteDataSource.fetchUsers(page);
    return userModels.map((userModel) => User(
      id: userModel.id,
      email: userModel.email,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      avatar: userModel.avatar,
    )).toList();
  }
}
