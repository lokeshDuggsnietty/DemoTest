import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entity/user.dart';
import '../../domain/usecases/user.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;

  UserBloc({required this.getUsers}) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
  }

  void _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    final currentState = state;
    var users = <User>[];

    if (currentState is UserLoaded && !event.isRefresh) {
      users = List.from(currentState.users);
    }

    emit(UserLoading(users: users));

    try {
      final newUsers = await getUsers(event.page);
      users.addAll(newUsers);
      emit(UserLoaded(users: users));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
