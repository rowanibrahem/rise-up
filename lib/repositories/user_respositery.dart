import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rise_up/models/user_model.dart' as UserModel;

class UserRepository {
  final String baseUrl = 'https://gorest.co.in/public-api';
  final String apiKey = 'c27fc0805e71fdcbc58e3c41c642e663214dfb26b8d8ab18345741c52e07bc17';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final userList = data['data'] as List;
      return userList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<User> createUser(User newUser) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode(newUser.toJson()),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<User> updateUser(User updatedUser) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/${updatedUser.id}'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedUser.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to update user');
    }
  }
  Future<void> deleteUser(User user) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    if (response.statusCode == 204) {
      // Deletion successful
      return;
    } else {
      throw Exception('Failed to delete user');
    }
  }
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userList = data['data'] as List;

        final users = userList.map((json) => User.fromJson(json)).toList();
        return users;
      } else {
        final errorMessage = 'Failed to fetch users. Please try again later.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'An error occurred. Please try again later.';
      throw Exception(errorMessage);
    }
  }
}




class User {
  int? id;
  String? gender;
  final String name;
  final String email;
  final String status;

  User({
    this.id,
    this.gender,
    required this.name,
    required this.email,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'status': status,
    };
  }
}
