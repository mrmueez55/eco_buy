import 'package:eco_buy/screens/auth_screens/confirm_pass.dart';
import 'package:flutter/material.dart';

class verfication_code extends StatefulWidget {
  verfication_code({Key? key}) : super(key: key);

  @override
  State<verfication_code> createState() => _loginState();
}

class _loginState extends State<verfication_code> {
  bool ispassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.cover)),
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
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You have sent email to your email account\n              with a verfication code",
                  style: TextStyle(
                      color: Colors.black, decorationColor: Colors.blue),
                )
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Form(
                child: Column(
              children: [
                Container(
                  height: 60,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
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

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Verfication code',
                      contentPadding: const EdgeInsets.all(18),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a Country';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => confirm_password()));
                  },
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
          ],
        ),
      )),
    );
  }
}
