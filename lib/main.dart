import 'package:flutter/material.dart';
import 'package:music_app/view/screens/home_page.dart';
import 'package:music_app/view/screens/play_song_screen.dart';
import 'package:music_app/view/screens/splashscreen.dart';
import 'package:provider/provider.dart';

import 'Provider/media_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MediaProvider(), // Replace with your model class
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(), // Uncomment if you want to use this
          '/home': (context) => HomePage(),
          '/play': (context) => PlayScreen(),
        },
      ),
    );
  }
}

