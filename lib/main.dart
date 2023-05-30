import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rise_up/repositories/user_respositery.dart';
import 'package:rise_up/screens/delete_screen.dart';
import 'package:rise_up/screens/user_list_screen.dart';
import 'package:rise_up/widgets/splash_view.dart';
import 'bloc/user_bloc.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: UserRepository() , userDelete: UserDelete())..add(FetchUsersEvent()),
        ),
    // child: UserListView(userBloc: userBloc),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User CRUD',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        home: const SplashScreen(),
        // UserListView(),
        // home: BlocProvider(
        //   create: (context) => userBloc..add(FetchUsersEvent()),
  // create: (context) {
  // final userBloc = UserBloc();
  // userBloc.add(FetchUsersEvent());
  // return userBloc;
  //       ),
       // home: BlocProvider.value(
       //    value: UserBloc,
       //    child: UserListView(userBloc: userBloc),
       //  ),
        // home: BlocProvider(
        //   create: (context) {
        //     final userBloc = UserBloc();
        //     userBloc.add(FetchUsersEvent());
        //     return userBloc;
        //   },
        //   // create: (context) => UserBloc(),..add(FetchUsersEvent()),
        //   child: UserListView(),
        // ),
      ),
    );
  }
}
