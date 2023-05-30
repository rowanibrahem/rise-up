import 'package:flutter/material.dart';

import '../bloc/user_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rise_up/models/user_model.dart';

import '../repositories/user_respositery.dart';
class UserDelete {
  Future<void> deleteUser(User user) async {
    try {
      final response = await http.delete(
        Uri.parse('https://gorest.co.in/public/v2/users/${user.id}'),
      );

      if (response.statusCode == 204) {
        Fluttertoast.showToast(
          msg: 'User deleted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
      else {
        final errorMessage = 'Failed to delete user. Please try again.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'An error occurred. Please try again later.';
      throw Exception(errorMessage);
    }
  }
}




// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../repositories/user_respositery.dart';
//
//
//
// class UserDelete {
//   final UserRepository userRepository;
//
//   UserDelete({required this.userRepository});
//
//   Future<void> deleteUser(User user) async {
//     try {
//       await userRepository.deleteUser(user);
//     } catch (e) {
//       throw Exception('Failed to delete user.');
//     }
//   }
// }
