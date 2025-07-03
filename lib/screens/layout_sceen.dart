import 'package:eco_buy/screens/landing_screen.dart';
import 'package:eco_buy/screens/web_site/web_login.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.minWidth > 600) {
        return WebLoginScreen();
      } else {
        return LandingScreen();
      }
    });
  }
}
