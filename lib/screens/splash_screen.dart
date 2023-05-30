import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rise_up/screens/user_list_screen.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({Key? key}) : super(key: key);

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UserListView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 30,
              color: Colors.blue,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('Welcome')
              ],
            ),
          ),
        ),
        Lottie.asset('assets/images/data.json'),
      ],
    );
  }
}
