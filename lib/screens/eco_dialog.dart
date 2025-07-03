import 'package:eco_buy/custom_widgets/ecobutton.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Ecodialog extends StatelessWidget {
  String? title;
  Ecodialog({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title!),
      actions: [
        EcoButton(
          text: "Close",
          onpress: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
