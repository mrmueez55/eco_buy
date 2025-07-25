import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  String? title;
  Header({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(
        title!,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
