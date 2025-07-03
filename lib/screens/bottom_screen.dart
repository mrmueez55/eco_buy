import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/screens/bottom_screens/cart_screen.dart';
import 'package:eco_buy/screens/bottom_screens/checkout_screen.dart';
import 'package:eco_buy/screens/bottom_screens/fav_screen.dart';
import 'package:eco_buy/screens/home_screen.dart';

import 'package:eco_buy/screens/bottom_screens/product_screen.dart';
import 'package:eco_buy/screens/bottom_screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int length = 0;
  int _cartItemsLength = 0;
  void cartItemsLength() {
    FirebaseFirestore.instance.collection("cart").get().then((snap) {
      if (snap.docs.isNotEmpty) {
        setState(() {
          length = snap.docs.length;
        });
      } else {
        setState(() {
          length = 0;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Get initial cart item length on widget initialization
    _getCartItemsLength();

    // Listen for changes in cart items using a StreamSubscription
    final cartStreamSubscription = FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _cartItemsLength = snapshot.docs.length;
      });
    });
    @override
    void dispose() {
      cartStreamSubscription.cancel();
      super.dispose();
    }
  }

  void _getCartItemsLength() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .get();
    setState(() {
      _cartItemsLength = snapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    //cartItemsLength();
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          const BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          const BottomNavigationBarItem(
            label: "Products",
            icon: Icon(Icons.shop),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                _cartItemsLength > 0
                    ? Positioned(
                        top: 1,
                        right: 1,
                        child:
                            //  length == 0
                            //     ? Container(
                            //         // height: 1,
                            //         // width: 1,
                            //         )
                            //     :
                            Stack(
                          children: [
                            const Icon(
                              Icons.brightness_1,
                              color: Colors.green,
                              size: 20,
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  _cartItemsLength.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: "Favorite",
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: "Check out",
            icon: Icon(Icons.shopping_cart_checkout),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return const CupertinoPageScaffold(
                  child: HomeScreen(),
                );
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  child: ProductScreen(),
                );
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  child: CartScreen(),
                );
              },
            );
          case 3:
            return CupertinoTabView(
              builder: (context) {
                return const CupertinoPageScaffold(
                  child: FavScreen(),
                );
              },
            );
          case 4:
            if (FirebaseAuth.instance.currentUser!.displayName == null) {
              return CupertinoTabView(
                builder: (context) {
                  return const CupertinoPageScaffold(
                    child: ProfileScreen(),
                  );
                },
              );
            }
            return CupertinoTabView(
              builder: (context) {
                return const CupertinoPageScaffold(
                  child: CheckOutScreen(),
                );
              },
            );
          case 5:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  child: ProfileScreen(),
                );
              },
            );

          // break;
          default:
            return const HomeScreen();
        }
      },
    );
  }
}
