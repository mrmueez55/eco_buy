import 'package:eco_buy/custom_widgets/ecobutton.dart';
import 'package:eco_buy/custom_widgets/ecotextfield.dart';
import 'package:eco_buy/screens/auth_screens/login_screen.dart';

import 'package:eco_buy/services/firebase_services.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailC = TextEditingController();

  TextEditingController passwordC = TextEditingController();

  TextEditingController repasswordC = TextEditingController();
  bool? ispass1 = true;
  bool? isconfirmpass = true;
  FocusNode? passwordfocus;
  bool? formstateloading = false;
  FocusNode? confirmpassfocus;
  final formkey = GlobalKey<FormState>();

  onsubmit() async {
    if (formkey.currentState!.validate()) {
      if (passwordC.text == repasswordC.text) {
        setState(() {
          formstateloading = true;
        });

        String? accountStatus =
            await FirebaseServices.createAccount(emailC.text, passwordC.text);
        if (accountStatus != null) {
          ecodialog(accountStatus);
          setState(() {
            formstateloading = false;
          });
        } else {
          ecodialogBacktoLogin("Account Created");
          // Navigator.pop(context);
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) {
        //     return const LoginScreen();
        //   }),
        // );
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

  Future<void> ecodialogBacktoLogin(String error) async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(error),
            actions: [
              EcoButton(
                text: "Back to LoginPage",
                onpress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    repasswordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          // ignore: sized_box_for_whitespace
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                const Text(
                  "Create your Account",
                  textAlign: TextAlign.center,
                  style: EcoStyle.boldstyle,
                ),
                const SizedBox(
                  height: 100,
                ),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Ecotextfield(
                        validate: (v) {
                          if (v!.isEmpty ||
                              !v.contains("@") ||
                              !v.contains(".com")) {
                            return "Incorrect Email";
                          }
                          return null;
                        },
                        controller: emailC,
                        hinttext: "Enter your Email",
                        labeltext: "E-mail",
                        inputAction: TextInputAction.next,
                      ),
                      Ecotextfield(
                        ispassword: ispass1,
                        controller: passwordC,
                        validate: (v) {
                          if (v!.isEmpty) {
                            return "Please enter the password";
                          }
                          return null;
                        },
                        hinttext: "Enter your Password",
                        maxlines: 1,
                        labeltext: "Password",
                        inputAction: TextInputAction.next,
                        focusNode: passwordfocus,
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              ispass1 = !ispass1!;
                            });
                          },
                          icon: ispass1!
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                      Ecotextfield(
                        ispassword: isconfirmpass,
                        controller: repasswordC,
                        validate: (v) {
                          if (v!.isEmpty) {
                            return "Please enter the password";
                          }
                          return null;
                        },
                        hinttext: "Confirm your Password",
                        labeltext: "Confirm password",
                        maxlines: 1,
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              isconfirmpass = !isconfirmpass!;
                            });
                          },
                          icon: isconfirmpass!
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                      EcoButton(
                        isloading: formstateloading!,
                        text: "Sign Up",
                        isLoginbutton: false,
                        onpress: () {
                          onsubmit();
                        },
                      ),
                      const SizedBox(
                        height: 250,
                      ),
                    ],
                  ),
                ),
                EcoButton(
                  text: "Back to Login page",
                  isLoginbutton: true,
                  onpress: () {
                    Navigator.pop(context);
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
