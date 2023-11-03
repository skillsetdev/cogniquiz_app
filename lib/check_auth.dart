import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards/login_screen.dart';
import 'package:flashcards/pages/nav_page.dart';
import 'package:flutter/material.dart';

class CheckAuth extends StatelessWidget {
  const CheckAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //research StreamBuilder
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return NavPage();
        } else {
          return LoginScreen();
        }
      }),
    ));
  }
}
