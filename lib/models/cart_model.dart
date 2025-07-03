import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cart {
  String? id;
  String? name;
  String? image;
  int? price;
  int? quantity;
  Cart({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    this.quantity,
  });
  static Future<void> addtoCart(Cart cart) async {
    CollectionReference db = FirebaseFirestore.instance.collection("cart");
    Map<String, dynamic> data = {
      "id": cart.id,
      "productName": cart.name,
      "image": cart.image,
      "price": cart.price,
      "quantity": cart.quantity,
      // "cid": cart.id,
    };
    await db
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .add(data);
  }

  ///       Below Sir Code
  // static Future<void> addtoCart(Cart cart) async {
  //   CollectionReference db = FirebaseFirestore.instance.collection("cart");
  //   Map<String, dynamic> data = {
  //     "id": cart.id,
  //     "productName": cart.name,
  //     "image": cart.image,
  //     "price": cart.price,
  //     "quantity": cart.quantity,
  //   };
  //   await db.add(data);
  // }

  factory Cart.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Cart(
        id: data["id"],
        image: data["image"],
        name: data["productName"],
        price: data["price"],
        quantity: data["quantity"]);
  }
  static Future<double> calculateTotalPrice() async {
    double totalPrice = 0.0;
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("cart")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("items")
          .get();
      for (var doc in snapshot.docs) {
        Cart cart = Cart.fromFirestore(doc);
        if (cart.price != null) {
          totalPrice += cart.price!;
        }
      }
    } catch (e) {
      print("Error calculating total price: $e");
    }
    return totalPrice;
  }
}
