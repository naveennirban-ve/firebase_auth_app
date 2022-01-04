import 'package:firebase_auth_app/pages/landingPage.dart';
import 'package:firebase_auth_app/pages/test/Manager_Home.dart';
import 'package:firebase_auth_app/pages/timer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/test/stickyListSweetyIssue.dart';


Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Ideal time to initialize
  //await FirebaseAuth.instance.useAuthEmulator('localhost',5001);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StickyListIssue(),
    );
  }
}
/// Control flow is from main.dart to landingPage.dart
/// If login then signin.dart.

