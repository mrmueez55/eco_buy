import 'package:eco_buy/utils/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeCard extends StatelessWidget {
  String? title;
  HomeCard({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.redAccent.withOpacity(0.8),
              Colors.blueAccent.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            title ?? "null",
            textAlign: TextAlign.center,
            style: EcoStyle.boldstyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
