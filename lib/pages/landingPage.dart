import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/pages/dashboard.dart';
import 'package:firebase_auth_app/pages/signIn.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            /// Goto SignIn Page
            return const SignIn();
          }
          /// If login goto Dashboard
          return const Dashboard();
        } else {
          /// Otherwise show Progressbar
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}








