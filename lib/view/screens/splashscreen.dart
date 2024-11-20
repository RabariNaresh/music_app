import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 10), () {
      Navigator.of(context).pushReplacementNamed('/home');
    },);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width:double.infinity,
        decoration: BoxDecoration(
         image: DecorationImage(image: NetworkImage("https://i.pinimg.com/enabled_lo_mid/736x/69/b7/70/69b770366d3c4a22e33885b5b3c58668.jpg"))
        ),
      ),
    );
  }
}