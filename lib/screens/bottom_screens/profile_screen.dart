import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/custom_widgets/ecobutton.dart';
import 'package:eco_buy/custom_widgets/ecotextfield.dart';
import 'package:eco_buy/custom_widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profilePic;
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController cityC = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isSaving = false;
  bool selection = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (FirebaseAuth.instance.currentUser!.displayName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please complete Profile Page")));
      } else {
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          nameC.text = snapshot["name"];
          phoneC.text = snapshot["phone"];
          addressC.text = snapshot["address"];
          cityC.text = snapshot["city"];
          profilePic = snapshot["profilePic"];
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5.h),
        child: Header(
          title: "PROFILE",
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  InkWell(
                    onTap: () async {
                      final XFile? pickImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery, imageQuality: 60);
                      if (pickImage != null) {
                        setState(() {
                          profilePic = pickImage.path;
                          selection = true;
                        });
                      }
                    },
                    child: Container(
                      child: profilePic == null
                          ? const CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              radius: 70,
                              child: Icon(
                                (Icons.add_a_photo),
                                size: 70,
                              ),
                            )
                          : profilePic!.contains("http")
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundImage: NetworkImage(profilePic!),
                                )
                              : CircleAvatar(
                                  radius: 70,
                                  backgroundImage: FileImage(File(profilePic!)),
                                ),
                    ),
                  ),
                  Ecotextfield(
                    hinttext: "Enter your Name",
                    labeltext: "Enter your Name",
                    controller: nameC,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "It should not be empty";
                      }
                      return null;
                    },
                  ),
                  Ecotextfield(
                    hinttext: "Enter your Phone Number",
                    labeltext: "Enter your Phone Number",
                    controller: phoneC,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "It should not be empty";
                      }
                      return null;
                    },
                  ),
                  Ecotextfield(
                    hinttext: "Enter your Address",
                    labeltext: "Enter your Address",
                    controller: addressC,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "It should not be empty";
                      }
                      return null;
                    },
                  ),
                  Ecotextfield(
                    hinttext: "Enter your City name",
                    labeltext: "Enter your City name",
                    controller: cityC,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "It should not be empty";
                      }
                      return null;
                    },
                  ),
                  EcoButton(
                    text: nameC.text.isEmpty ? "SAVE" : "Update",
                    isloading: isSaving,
                    onpress: () {
                      if (formkey.currentState!.validate()) {
                        SystemChannels.textInput
                            .invokeMapMethod("TextInput.hide"); //hide keyboard
                        profilePic == null
                            ? ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Select Profile pic")))
                            : nameC.text.isEmpty
                                ? saveInfo()
                                : update();
                      }
                    },
                  ),
                  EcoButton(
                    text: "Sign-Out",
                    onpress: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? downloadUrl;
  Future<String?> uploadImage(File filePath, String? reference) async {
    try {
      final fileName =
          " ${FirebaseAuth.instance.currentUser!.uid} ${DateTime.now().second}";
      final Reference fbStorage =
          FirebaseStorage.instance.ref(reference).child(fileName);
      final UploadTask uploadTask = fbStorage.putFile(filePath);
      await uploadTask.whenComplete(() async {
        downloadUrl = await fbStorage.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  update() {
    setState(() {
      isSaving = true;
    });
    if (selection == true) {
      uploadImage(File(profilePic!), "profile").whenComplete(() {
        Map<String, dynamic> data = {
          "name": nameC.text,
          "phone": phoneC.text,
          "address": addressC.text,
          "city": cityC.text,
          "profilePic": downloadUrl,
        };
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(data)
            .whenComplete(() {
          FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
          setState(() {
            isSaving = false;
          });
        });
      });
    } else {
      Map<String, dynamic> data = {
        "name": nameC.text,
        "phone": phoneC.text,
        "address": addressC.text,
        "city": cityC.text,
        "profilePic": profilePic,
      };
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data)
          .whenComplete(() {
        FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
        setState(() {
          isSaving = false;
        });
      });
    }
  }

  saveInfo() {
    setState(() {
      isSaving = true;
    });
    uploadImage(File(profilePic!), "profile").whenComplete(() {
      Map<String, dynamic> data = {
        "name": nameC.text,
        "phone": phoneC.text,
        "address": addressC.text,
        "city": cityC.text,
        "profilePic": downloadUrl,
      };
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(data)
          .whenComplete(() {
        FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
        setState(() {
          isSaving = false;
        });
      });
    });
    uploadImage(File(profilePic!), "profile").whenComplete(() {
      Map<String, dynamic> data = {
        "name": nameC.text,
        "phone": phoneC.text,
        "address": addressC.text,
        "city": cityC.text,
        "profilePic": profilePic,
      };
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(data)
          .whenComplete(() {
        FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
        setState(() {
          isSaving = false;
        });
      });
    });
  }
}
