import 'package:flutter/material.dart';
import './screens/auth/login_screen.dart';
import './screens/social/social_app.dart';
import './services/auth_api.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
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
      home: FutureBuilder(
        future: AuthApi().getAccessToken(),
         builder: (context, snapshot){
          if(snapshot.hasData){
          return const SocialApp();
          }
          return const LoginScreen();
         })
    );
  }
}
