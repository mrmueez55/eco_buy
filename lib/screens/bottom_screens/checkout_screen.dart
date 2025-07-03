import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/custom_widgets/ecobutton.dart';
import 'package:eco_buy/custom_widgets/header.dart';
import 'package:eco_buy/models/cart_model.dart';
import 'package:eco_buy/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
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

    fetchTotalPrice();
  }

  //   Sire code below
  // CollectionReference db = FirebaseFirestore.instance.collection("cart");
  // delete(String id, BuildContext context) {
  //   db.doc(id).delete().then((value) => ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text("Successfully Deleted"))));
  //   fetchTotalPrice();
  // }

  double totalPrice = 0;
  List<Cart> realData = [];
  void getData() async {
    List<Cart> tempData = [];
    await FirebaseFirestore.instance
        .collection("cart")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((e) {
        if (e.exists) {
          tempData.add(Cart.fromFirestore(e));
        }
      });
      setState(() {
        realData = tempData;
      });
      print(realData.first.price);
    });
  }

  Future<void> fetchTotalPrice() async {
    double price = await Cart.calculateTotalPrice();
    setState(() {
      totalPrice = price;
    });
    // print(totalPrice);
  }

  @override
  void initState() {
    super.initState();
    fetchTotalPrice();

    final totalPriceStreamSubscription = FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .snapshots()
        .listen((snapshot) async {
      double price = await Cart.calculateTotalPrice();
      setState(() {
        totalPrice = price;
      });
    });
    @override
    void dispose() {
      totalPriceStreamSubscription.cancel();
      super.dispose();
    }
  }

  Future<void> placeOrder() async {
    try {
      QuerySnapshot cartSnapshot = await db
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("items")
          .get();
      List<Map<String, dynamic>> cartItems = cartSnapshot.docs.map((doc) {
        return {
          "id": doc["id"],
          "productName": doc["productName"],
          "image": doc["image"],
          "price": doc["price"],
          "quantity": doc["quantity"],
        };
      }).toList();

      String userId = FirebaseAuth.instance.currentUser!
          .uid; // Replace with actual user ID or use FirebaseAuth to get current user ID

      OrderModel order = OrderModel(
        userId: userId,
        items: cartItems,
        timestamp: Timestamp.now(),
      );

      await order.save();

      // Clear the cart after placing the order
      for (var doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order Placed Successfully")));
    } catch (e) {
      print("Error placing order: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to Place Order")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(5.h),
          child: Header(
            // ignore: unnecessary_string_interpolations
            title: "check Out",
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: h * 0.7,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("cart")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("items")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              style: const TextStyle(
                                                  color: Colors.red),
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
            ),
            SizedBox(
              height: h * 0.2,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Price: $totalPrice",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: placeOrder,
                    child: Container(
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          "Place Order",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
