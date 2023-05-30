import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rise_up/repositories/user_respositery.dart';
import '../bloc/user_bloc.dart';
import 'package:rise_up/models/user_model.dart';
import '../widgets/loader_indicator.dart';

class UserEditScreen extends StatefulWidget {
  final User user;

  const UserEditScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _statusController.text = widget.user.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserEditingState) {
              Fluttertoast.showToast(
                msg: 'User updated successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Future.delayed(const Duration(seconds: 3), () {
                // Navigator.of(context).pop();
              });
             }
    // else if (state is UserErrorState) {
            //   // Handle error state
            //   showDialog(
            //     context: context,
            //     builder: (context) => AlertDialog(
            //       title: Text('Error'),
            //       content: Text(state.errorMessage),
            //       actions: [
            //         ElevatedButton(
            //           onPressed: () {
            //             Navigator.of(context).pop();
            //           },
            //           child: Text('OK'),
            //         ),
            //       ],
            //     ),
            //   );
            // }
          },
          builder: (context, state) {
            if (state is UserLoadingState) {
              // Show loading indicator
              return LoadingIndicator();
            } else if (state is UserLoadedState) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
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
                      decoration: const InputDecoration(
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
                      decoration: const InputDecoration(
                        labelText: 'Status',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a status.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final updatedUser = User(
                            id: widget.user.id,
                            name: _nameController.text,
                            email: _emailController.text,
                            status: _statusController.text,
                          );
                          BlocProvider.of<UserBloc>(context).add(
                            UpdateUserEvent(updatedUser as User),
                          );
                        }
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
