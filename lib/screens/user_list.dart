import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rise_up/screens/show_users.dart';

import '../bloc/user_bloc.dart';
import '../utils/navigation.dart';

class UserListScreen extends StatelessWidget {
  final UserBloc userBloc;
  final UserNavigation userNavigation;
  const UserListScreen({
    Key? key,
    required this.userBloc,
    required this.userNavigation, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoadedState) {
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailsScreen(user: user),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  onTap: () {
                    userBloc.add(SelectUserEvent(user));
                    UserNavigation.navigateToUserDetails(context, user); // Update this line
                  },
                ),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
