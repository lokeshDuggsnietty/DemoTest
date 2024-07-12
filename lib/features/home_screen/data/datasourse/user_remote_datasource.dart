import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> fetchUsers(int page);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserModel>> fetchUsers(int page) async {
    final response = await client.get('https://reqres.in/api/users', queryParameters: {'page': page});
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data['data'];
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
