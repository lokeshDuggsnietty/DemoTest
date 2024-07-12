import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'features/home_screen/data/datasourse/user_remote_datasource.dart';
import 'features/home_screen/data/repository/user_repository.dart';
import 'features/home_screen/domain/usecases/user.dart';
import 'features/home_screen/presentation/bloc/user_bloc.dart';
import 'features/home_screen/presentation/screens/user_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) {
          final remoteDataSource = UserRemoteDataSourceImpl(client: Dio());
          final repository = UserRepositoryImpl(remoteDataSource: remoteDataSource);
          final getUsers = GetUsers(repository: repository);
          return UserBloc(getUsers: getUsers);
        },
        child: const UserListPage(),
      ),
    );
  }
}
