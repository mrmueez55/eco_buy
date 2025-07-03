import 'package:eco_buy/custom_widgets/ecobutton.dart';
import 'package:eco_buy/custom_widgets/ecotextfield.dart';
import 'package:eco_buy/screens/eco_dialog.dart';
import 'package:eco_buy/screens/web_site/web_main_page.dart';
import 'package:eco_buy/services/firebase_services.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class WebLoginScreen extends StatefulWidget {
  static const String id = "weblogin";
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  TextEditingController usernameC = TextEditingController();

  TextEditingController passwordC = TextEditingController();

  final formkey = GlobalKey<FormState>();
  String username = "admin1";
  String pass = "123456";

  bool formStateloading = false;
  onsubmit(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      setState(() {
        formStateloading = true;
      });

      // final isLoginSuccessful =
      //     await FirebaseServices.adminLoginn(usernameC.text, passwordC.text);

      if (username == usernameC.text && pass == passwordC.text) {
        // Navigate to admin screen using a suitable navigation method
        Navigator.pushReplacementNamed(context, WebMainScreen.id); // Example
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return Ecodialog(
              title: "Incorrect Password and username",
            );
          },
        );
      }

      setState(() {
        formStateloading = false;
      });
    }
  }

  // onsubmit(BuildContext context) async {
  //   if (formkey.currentState!.validate()) {
  //     setState(() {
  //       formStateloading = true;
  //     });

  //     await FirebaseServices.adminLogin(usernameC.text).then((value) async {
  //       if (value["username"] == usernameC.text &&
  //           value["password"] == passwordC) {
  //         // try {
  //         //   UserCredential userCredential =
  //         //       await FirebaseAuth.instance.signInAnonymously();
  //         // ignore: unnecessary_null_comparison
  //         // if (userCredential != null) {
  //         // ignore: use_build_context_synchronously
  //         Navigator.pushReplacementNamed(context, WebMainScreen.id);
  //         //   }
  //         // } catch (e) {
  //         //   setState(() {
  //         //     formStateloading = false;
  //         //   });
  //         // showDialog(
  //         //     context: context,
  //         //     builder: (_) {
  //         //       return Ecodialog(
  //         //         title: e.toString(),
  //         //       );
  //         //     });
  //         // }
  //       } else {
  //         showDialog(
  //             context: context,
  //             builder: (_) {
  //               return Ecodialog(
  //                 title: "Incorrect Password and username",
  //               );
  //             });
  //         setState(() {
  //           formStateloading = false;
  //         });
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 5.h,
              ),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "ADMIN PANNEL",
                      style: EcoStyle.boldstyle,
                    ),
                    Ecotextfield(
                      labeltext: "Enter Username",
                      controller: usernameC,
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "Please enter the Username";
                        }
                        return null;
                      },
                      hinttext: "Enter Username",
                    ),
                    Ecotextfield(
                      labeltext: "Enter your Password",
                      ispassword: true,
                      controller: passwordC,
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "Please enter the Password";
                        }
                        return null;
                      },
                      hinttext: "Enter your Password",
                    ),
                    EcoButton(
                      text: "Login In",
                      isloading: formStateloading,
                      onpress: () => onsubmit(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
