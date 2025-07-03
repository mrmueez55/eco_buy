import 'package:eco_buy/screens/auth_screens/login_screen.dart';
import 'package:eco_buy/screens/bottom_screen.dart';

import 'package:eco_buy/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});
  Future<FirebaseApp> initialize = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialize,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.hasError}");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Text("${streamSnapshot.hasError}");
              }
              if (streamSnapshot.connectionState == ConnectionState.active) {
                User? user = streamSnapshot.data;
                if (user == null) {
                  return const LoginScreen();
                } else {
                  return const BottomPage();
                }
              }
              return const Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Checking Authentication....",
                        style: EcoStyle.boldstyle,
                      ),
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            },
          );
        }
        return const Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "INItILIAZAtION....",
                  style: EcoStyle.boldstyle,
                ),
              ),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
