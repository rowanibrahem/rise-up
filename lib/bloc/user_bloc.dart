import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


import '../repositories/user_respositery.dart';
import '../screens/delete_screen.dart';
import '../screens/show_users.dart';
import '../utils/navigation.dart';

// User-related events
abstract class UserEvent {}

class FetchUsersEvent extends UserEvent {}

class CreateUserEvent extends UserEvent {
  final User newUser;

  CreateUserEvent(this.newUser);
}
class DeleteUserEvent extends UserEvent {
  final User user;

  // DeleteUserEvent(this.user);
  DeleteUserEvent(this.user);
}

class SelectUserEvent extends UserEvent {
  final User selectedUser;

  SelectUserEvent(this.selectedUser);
}


class UpdateUserEvent extends UserEvent {
  final User updatedUser;

  UpdateUserEvent(this.updatedUser);
}

// User-related states
abstract class UserState {}

class UserCreatingState extends UserState {}

class UserLoadingState extends UserState {}

class UserEditingState extends UserState {}


class UserLoadedState extends UserState {
  final List<User> users;

  UserLoadedState(this.users);
}

class UserErrorState extends UserState {
  final String errorMessage;

  UserErrorState(this.errorMessage);
}

// User-related bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final UserDelete userDelete;
  final BuildContext? context;
  final UserNavigation? userNavigation;

  UserBloc( {required this.userRepository , required this.userDelete, this.context,  this.userNavigation,})  : super(UserLoadingState()) {
    on<FetchUsersEvent>((event, emit) => _fetchUsers());
    on<CreateUserEvent>((event, emit) => _createUser(event.newUser));
    on<UpdateUserEvent>((event, emit) => _updatedUser(event.updatedUser));
    on<DeleteUserEvent>((event, emit) => _deleteUser(event.user));
    on<SelectUserEvent>((event, emit) => _selectUser(event.selectedUser));

  }

  Future<void> _fetchUsers() async {
    try {
      emit(UserLoadingState());

      final users = await userRepository.getUsers();

      final response = await http.get(Uri.parse('https://gorest.co.in/public-api/users'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userList = data['data'] as List;

        final users = userList.map((json) => User.fromJson(json)).toList();
        emit(UserLoadedState(users));
      } else {
        final errorMessage = 'Failed to fetch users. Please try again later.';
        emit(UserErrorState(errorMessage));
      }
    }
    catch (e) {
      final errorMessage = 'An error occurred. Please try again later.';
      emit(UserErrorState(errorMessage));
    }
  }

  Future<void> _createUser(User newUser) async {
    try {
      emit(UserCreatingState());

      final response = await http.post(
        Uri.parse('https://gorest.co.in/public-api/users'),
        body: {
          'name': newUser.name,
          'email': newUser.email,
          'gender': newUser.gender,
          'status': newUser.status,
        },
      );

      if (response.statusCode == 201) {
        emit(FetchUsersEvent() as UserState); //change cast
      } else {
        final errorMessage = 'Failed to create user. Please try again.';
        emit(UserErrorState(errorMessage));
      }
    } catch (e) {
      final errorMessage = 'An error occurred. Please try again later.';
      emit(UserErrorState(errorMessage));
    }
  }

  Future<void> _updatedUser(User updatedUser) async {
    try {
      emit(UserEditingState());

      final response = await http.put(
        Uri.parse('https://gorest.co.in/public/v2/users/${updatedUser.id}'),
        // https://gorest.co.in/public-api/users/
        body: {
          'name': updatedUser.name,
          'email': updatedUser.email,
          'gender': updatedUser.gender,
          'status': updatedUser.status,
        },
      );

      if (response.statusCode == 200) {
        emit(UserEditingState());
      //   emit(FetchUsersEvent() as UserState);
      //   Fluttertoast.showToast(msg: 'User updated successfully');
      // } else {
        final errorMessage = 'Failed to update user. Please try again.';
        emit(UserErrorState(errorMessage));
      }
    }
    catch (e) {
      final errorMessage = 'An error occurred. Please try again later.';
      emit(UserErrorState(errorMessage));
    }
  }


  Future<void> _deleteUser( User user) async {
    try {
      emit(UserLoadingState());


      await UserDelete().deleteUser(user);

      final userList = await userRepository.getUsers();

      emit(UserLoadedState(userList));
      Fluttertoast.showToast(msg: 'User deleted successfully' ,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

    } catch (e) {
      final errorMessage = 'Failed to delete user. Please try again.';
      emit(UserErrorState(errorMessage));
    }
  }

  void _selectUser( User selectedUser) {
    final currentState = state;
    if (currentState is UserLoadedState) {
      Navigator.push( context!, MaterialPageRoute(builder: (context) => UserDetailsScreen(user: selectedUser),
        ),
      );
    }
  }

}



// User model
// class User {
//   int? id;
//   String? gender;
//   final String name;
//   final String email;
//   final String status;
//
//   User({
//     this.id,
//     this.gender,
//     required this.status,
//     required this.name,
//     required this.email,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       gender: json['gender'],
//       status: json['status'],
//     );
//   }
// }
