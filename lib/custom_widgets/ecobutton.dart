import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EcoButton extends StatelessWidget {
  bool? isloading;
  String? text;
  bool? isLoginbutton;
  VoidCallback? onpress;
  EcoButton({
    super.key,
    this.text,
    this.isLoginbutton = false,
    this.onpress,
    this.isloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        width: double.infinity,
        height: 62,
        decoration: BoxDecoration(
          border: Border.all(
            color: isLoginbutton == false ? Colors.white : Colors.black,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isLoginbutton == false ? Colors.black : Colors.white,
        ),
        child: Stack(
          children: [
            Visibility(
              visible: isloading! ? false : true,
              child: Center(
                child: Text(
                  text ?? "nul",
                  style: TextStyle(
                    color: isLoginbutton == false ? Colors.white : Colors.black,
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isloading!,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
