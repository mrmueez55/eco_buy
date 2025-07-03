import 'package:eco_buy/custom_widgets/ecobutton.dart';
import 'package:eco_buy/custom_widgets/ecotextfield.dart';
import 'package:eco_buy/screens/auth_screens/forget.dart';
import 'package:eco_buy/screens/auth_screens/signup_sceen.dart';
import 'package:eco_buy/screens/home_screen.dart';

import 'package:eco_buy/services/firebase_services.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:flutter/material.dart';

//import '../services/firebase_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  bool? isloginpass = true;
  bool? formstateloading = false;
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }
//////     Sir code
  // onsubmit() async {
  //   if (formkey.currentState!.validate()) {
  //     setState(() {
  //       formstateloading = true;
  //     });

  //     String? accountStatus =
  //         await FirebaseServices.loginAccount(emailC.text, passwordC.text);
  //     if (accountStatus != null) {
  //       ecodialog(accountStatus);
  //       setState(() {
  //         formstateloading = false;
  //       });
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) {
  //             return const HomeScreen();
  //           },
  //         ),
  //       );
  //     }
  //   }
  // }
  onsubmit() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        formstateloading = true;
      });

      String? accountStatus =
          await FirebaseServices.loginAccount(emailC.text, passwordC.text);

      if (!mounted) return; // Check if the widget is still mounted

      if (accountStatus != null) {
        ecodialog(accountStatus);
        setState(() {
          formstateloading = false;
        });
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) {
              return const HomeScreen();
            },
          ),
        );
      }
    }
  }

  Future<void> ecodialog(String error) async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(error),
            actions: [
              EcoButton(
                text: "Close",
                onpress: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // ignore: sized_box_for_whitespace
        child: SingleChildScrollView(
          // ignore: sized_box_for_whitespace
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Welcome \n Please Login first",
                  textAlign: TextAlign.center,
                  style: EcoStyle.boldstyle,
                ),
                const SizedBox(
                  height: 150,
                ),
                Form(
                  key: formkey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Ecotextfield(
                        controller: emailC,
                        validate: (v) {
                          if (v!.isEmpty) {
                            return "Please enter the email";
                          }
                          return null;
                        },
                        hinttext: "Enter your Email",
                        labeltext: "E-mail",
                      ),
                      Ecotextfield(
                        controller: passwordC,
                        labeltext: "Password",
                        ispassword: isloginpass,
                        validate: (v) {
                          if (v!.isEmpty) {
                            return "Please enter the password";
                          }
                          return null;
                        },
                        hinttext: "Enter your Password",
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              isloginpass = !isloginpass!;
                            });
                          },
                          icon: isloginpass!
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                      EcoButton(
                        text: "LOGIN",
                        isLoginbutton: false,
                        isloading: formstateloading,
                        onpress: () {
                          onsubmit();
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 180),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return ForgotPasswordPage();
                              }));
                            },
                            child: const Text(
                              "Forget Password",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                      const SizedBox(
                        height: 250,
                      ),
                    ],
                  ),
                ),
                EcoButton(
                  text: "Create New Account",
                  isLoginbutton: true,
                  onpress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const SignupScreen();
                    }));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
