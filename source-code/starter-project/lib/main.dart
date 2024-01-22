import 'package:flutter/material.dart';
import './screens/social/social_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Droidio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       useMaterial3: true,
       brightness: Brightness.dark,
      ),
      home: const SocialApp()
    );
  }
}
