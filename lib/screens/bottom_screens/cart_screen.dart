import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/custom_widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CollectionReference db = FirebaseFirestore.instance.collection("cart");
  delete(String itemId, BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    db
        .doc(userId)
        .collection("items")
        .doc(itemId)
        .delete()
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully Deleted")),
            ))
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to delete item: $error")),
            ));
  }
  ////      Sire code
  // delete(String id, BuildContext context) {
  //   db.doc(id).delete().then((value) => ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text("Successfully Deleted"))));
  // }

  List cids = [];
  getId() async {
    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          cids.add(element["cid"]);
          print(cids);
        });
      });
    });
  }

  Stream<List<String>> getCartIdsStream() {
    return FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc["cid"].toString()).toList());
  }

  @override
  void initState() {
    // getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(7.h),
        child: Header(
          title: "CART ITEMS",
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("cart")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("items")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final result = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(3, 3))
                        ]),
                    child: Row(
                      children: [
                        Image.network(
                          result["image"],
                          height: 90,
                          width: 90,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${result["productName"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Text("Qty : "),
                                    Text(
                                      "${result["quantity"]}",
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Price : "),
                                    Text(
                                      "${result["price"]}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              delete(result.id, context);
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                              size: 25,
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
