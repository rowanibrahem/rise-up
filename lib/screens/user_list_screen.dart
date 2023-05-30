import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rise_up/repositories/user_respositery.dart';
import 'package:rise_up/screens/update_user_screen.dart';
import 'package:rise_up/screens/user_detail_screen.dart';
import '../bloc/user_bloc.dart';
import '../widgets/loader_indicator.dart';


class UserListView extends StatelessWidget {

  UserListView({Key? key}) : super(key: key);

  // Future<void> _deleteUser(BuildContext context, User user) async {
  //   BlocProvider.of<UserBloc>(context).add(DeleteUserEvent(user));


    final _formKey = GlobalKey<FormState>();

    final _nameController = TextEditingController();

    final _emailController = TextEditingController();

    final _statusController = TextEditingController();

    Future<void> _deleteUser(BuildContext context, User user) async {
      BlocProvider.of<UserBloc>(context).add(DeleteUserEvent(user as User));
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('User List'),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoadingState || state is UserCreatingState) {
              return LoadingIndicator();
            } else if (state is UserLoadedState) {
              final users = state.users;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user.email}'),
                        Text('Gender: ${user.gender}'),
                        Text('Status: ${user.status}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserEditScreen(user: user),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteUser(context, user),
                        )
                        // IconButton(
                        //   icon: const Icon(Icons.delete),
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => UserDelete(),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is UserErrorState) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return Scaffold();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Create User'),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a name.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an email.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _statusController,
                          decoration: InputDecoration(
                            labelText: 'Status',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a status.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newUser = User(
                            name: _nameController.text,
                            email: _emailController.text,
                            status: _statusController.text,
                          );
                          BlocProvider.of<UserBloc>(context)
                              .add(CreateUserEvent(newUser));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserDetailsScreen(user: newUser),
                            ),
                          );
                        }
                      },
                      child: Text('Create'),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
      );
    }
}
