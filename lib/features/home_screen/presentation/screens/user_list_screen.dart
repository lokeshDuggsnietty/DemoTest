import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userlistdemo/features/home_screen/presentation/screens/user_details.dart';
import '../bloc/user_bloc.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context)
        .add(FetchUsers(page: _currentPage, isRefresh: true));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _currentPage++;
      BlocProvider.of<UserBloc>(context).add(FetchUsers(page: _currentPage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading && state.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded ||
              (state is UserLoading && state.users.isNotEmpty)) {
            final users = (state is UserLoaded)
                ? state.users
                : (state as UserLoading).users;
            return ListView.builder(
              controller: _scrollController,
              itemCount: users.length + (state is UserLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= users.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final user = users[index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      title: Text('${user.firstName} ${user.lastName}'),
                      subtitle: Text(user.email),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailPage(user: user),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.2,)
                  ],
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
