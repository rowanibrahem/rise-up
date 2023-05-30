import 'package:flutter/material.dart';

import '../repositories/user_respositery.dart';
import '../screens/show_users.dart';

class UserNavigation {
  static void navigateToUserDetails(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDetailsScreen(user: user)),
    );
  }
}
