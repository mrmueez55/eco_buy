// import 'package:eco_buy/screens/auth_screens/verification.dart';
// import 'package:flutter/material.dart';

// class forgot extends StatefulWidget {
//   forgot({Key? key}) : super(key: key);

//   @override
//   State<forgot> createState() => _loginState();
// }

// class _loginState extends State<forgot> {
//   bool ispassword = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Row(
//                 children: [
//                   IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(
//                         Icons.arrow_back_ios,
//                         size: 17,
//                       )),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 50,
//                     width: 150,
//                     decoration: BoxDecoration(
//                         // image: DecorationImage(
//                         //     image: AssetImage("assets/images/logo.png"),
//                         //     fit: BoxFit.cover)
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Forgot Password",
//                     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                   )
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Recover your Password",
//                   style: TextStyle(
//                       color: Colors.black, decorationColor: Colors.blue),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 60,
//             ),
//             Form(
//                 child: Column(
//               children: [
//                 Container(
//                   height: 60,
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(20)),
//                   child: TextFormField(
//                     //  controller: name,
//                     cursorColor: Colors.black,

//                     // keyboardType: TextInputType.number,
//                     // maxLines: widget.maxLines == 1 ? 1 : widget.maxLines,

//                     keyboardType: TextInputType.name,

//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'abc@gmail.com',
//                       prefixIcon: Icon(Icons.email),
//                       contentPadding: const EdgeInsets.all(18),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter a Country';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 InkWell(
//                   onTap: () async {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (_) => verfication_code()));
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 15, right: 15),
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30)),
//                       child: Container(
//                         height: 60,
//                         // margin: const EdgeInsets.symmetric(
//                         //     horizontal: 17, vertical: 7),
//                         decoration: BoxDecoration(
//                             color: Color(0xffc1e397),
//                             borderRadius: BorderRadius.circular(30)),
//                         child: Center(
//                           child: Text(
//                             "Submit",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold
//                                 //   fontStyle: FontStyle.italic
//                                 ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )),
//           ],
//         ),
//       )),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    // emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 17,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          // image: DecorationImage(
                          //     image: AssetImage("assets/images/logo.png"),
                          //     fit: BoxFit.cover)
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot Password",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Recover your Password",
                    style: TextStyle(
                        color: Colors.black, decorationColor: Colors.blue),
                  )
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 17, vertical: 7),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          //  controller: name,
                          cursorColor: Colors.black,

                          // keyboardType: TextInputType.number,
                          // maxLines: widget.maxLines == 1 ? 1 : widget.maxLines,

                          keyboardType: TextInputType.name,
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'abc@gmail.com',
                            prefixIcon: Icon(Icons.email),
                            contentPadding: const EdgeInsets.all(18),
                          ),
                          validator: (value) {
                            if (value!.isEmpty &&
                                value.contains("@gamil.com")) {
                              return 'Enter a Email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: verifyEmail,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              height: 60,
                              // margin: const EdgeInsets.symmetric(
                              //     horizontal: 17, vertical: 7),
                              decoration: BoxDecoration(
                                  color: Color(0xffc1e397),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold
                                      //   fontStyle: FontStyle.italic
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 30),
              //   child: Row(
              //     children: [
              //       Text(
              //         "Deactive account",
              //         style: TextStyle(
              //             color: Colors.blue,
              //             decoration: TextDecoration.underline,
              //             decorationColor: Colors.blue),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        )),
      );

  Future verifyEmail() async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => const Center(child: CircularProgressIndicator()),
    // );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      const snackBar =
          SnackBar(content: Text('Reset Password Email has been Sent.'));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}




// SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   const SizedBox(height: 60),
//                   const FlutterLogo(size: 120),
//                   const SizedBox(height: 40),
//                   const Text(
//                     'You will receive an email to\nreset your password.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 24),
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: emailController,
//                     cursorColor: Colors.white,
//                     textInputAction: TextInputAction.done,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                     ),
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (email) =>
//                         email != null && !EmailValidator.validate(email)
//                             ? 'Enter a valid email'
//                             : null,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size.fromHeight(50),
//                     ),
//                     icon: const Icon(Icons.email_outlined),
//                     label: const Text(
//                       'Reset Password',
//                       style: TextStyle(fontSize: 24),
//                     ),
//                     onPressed: verifyEmail,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),