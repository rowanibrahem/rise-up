import 'package:flutter/material.dart';

import '../bloc/user_bloc.dart';
import 'package:rise_up/models/user_model.dart';

import '../repositories/user_respositery.dart';

class UserDetailsScreen extends StatelessWidget {
  final User user;

  const UserDetailsScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}' , style: Theme.of(context).textTheme.headlineLarge,),
            Text('Email: ${user.email}' , style: Theme.of(context).textTheme.headlineLarge,),
            Text('Status: ${user.status}' , style: Theme.of(context).textTheme.headlineLarge,),
          ],
        ),
      ),
    );
  }
}
