import 'package:eco_buy/screens/layout_sceen.dart';
import 'package:eco_buy/screens/web_site/add_product_screen.dart';
import 'package:eco_buy/screens/web_site/dashboard_screen.dart';
import 'package:eco_buy/screens/web_site/del_product_screen.dart';
//import 'package:eco_buy/screens/web_site/update_complete_screen.dart';
import 'package:eco_buy/screens/web_site/update_product_scren.dart';
import 'package:eco_buy/screens/web_site/web_login.dart';
import 'package:eco_buy/screens/web_site/web_main_page.dart';
//import 'package:eco_buy/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "",
        authDomain: "eco-buyy-25829.firebaseapp.com",
        projectId: "eco-buyy-25829",
        storageBucket: "eco-buyy-25829.appspot.com",
        messagingSenderId: "393396089926",
        appId: "1:393396089926:web:85f9e1dc549d83b877c647",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  // await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ECO BUY',
        theme: ThemeData(
          //  backgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.white,
          //   useMaterial3: true,
        ),
        home: const LayoutScreen(),
        routes: {
          WebLoginScreen.id: (context) => const WebLoginScreen(),
          WebMainScreen.id: (context) => const WebMainScreen(),
          DashboardScreen.id: (context) => const DashboardScreen(),
          AddProductScreen.id: (context) => const AddProductScreen(),
          DeleteProductScreen.id: (context) => const DeleteProductScreen(),
          UpdateProductScreen.id: (context) => UpdateProductScreen(),
          // UpdateCompleteProductScreen.id: (context) =>
          //      UpdateCompleteProductScreen(),
        },
      ),
    );
  }
}
