import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/custom_widgets/header.dart';

import 'package:eco_buy/screens/product_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  // late List<Products> favoriteProducts;
  List ids = [];
  getId() async {
    FirebaseFirestore.instance
        .collection("favourite")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          ids.add(element["pid"]);
          // print(ids);
        });
      });
    });
  }

  Stream<List<String>> getFavoriteIdsStream() {
    return FirebaseFirestore.instance
        .collection("favourite")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc["pid"].toString()).toList());
  }

  @override
  void initState() {
    //getId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5.h),
        child: Header(
          // ignore: unnecessary_string_interpolations
          title: "Favourite Products",
        ),
      ),
      body: StreamBuilder<List<String>>(
        stream: getFavoriteIdsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<String> favoriteIds = snapshot.data!;

          return StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("products").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> productSnapshot) {
              if (!productSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<QueryDocumentSnapshot<Object?>> fvrtProduct = productSnapshot
                  .data!.docs
                  .where((element) => favoriteIds.contains(element["id"]))
                  .toList();

              return ListView.builder(
                itemCount: fvrtProduct.length,
                itemBuilder: (BuildContext context, int index) {
                  // ... rest of your ListView.builder code
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.6.h),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ProductDetailScreen(
                            id: fvrtProduct[index]["id"],
                          );
                        }));
                      },
                      child: Card(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              fvrtProduct[index]["productName"],
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.navigate_next,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),

      //               SIR code below
      //  Center(
      //   child: StreamBuilder(
      //     stream: FirebaseFirestore.instance.collection("products").snapshots(),
      //     builder:
      //         (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //       if (!snapshot.hasData) {
      //         return const Center(child: CircularProgressIndicator());
      //       }
      //       if (snapshot.data == null) {
      //         return const Text("No favourite item found");
      //       }
      //       List<QueryDocumentSnapshot<Object?>> fvrtProduct = snapshot
      //           .data!.docs
      //           .where((element) => ids.contains(element["id"]))
      //           .toList();

      //       return ListView.builder(
      //         itemCount: fvrtProduct.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           return Padding(
      //             padding:
      //                 EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.6.h),
      //             child: InkWell(
      //               onTap: () {
      //                 Navigator.push(context, MaterialPageRoute(builder: (_) {
      //                   return ProductDetailScreen(
      //                     id: fvrtProduct[index]["id"],
      //                   );
      //                 }));
      //               },
      //               child: Card(
      //                 color: Colors.black,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(20),
      //                 ),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: ListTile(
      //                     title: Text(
      //                       fvrtProduct[index]["productName"],
      //                       style: const TextStyle(color: Colors.white),
      //                     ),
      //                     trailing: IconButton(
      //                       onPressed: () {},
      //                       icon: const Icon(
      //                         Icons.navigate_next,
      //                         color: Colors.white,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
