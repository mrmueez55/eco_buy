import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? id;
  String? userId;
  List<Map<String, dynamic>>? items;
  Timestamp? timestamp;

  OrderModel({this.id, this.userId, this.items, this.timestamp});

  // Convert a DocumentSnapshot to an OrderModel object
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data["userId"],
      items: List<Map<String, dynamic>>.from(data["items"]),
      timestamp: data["timestamp"],
    );
  }

  // Convert an OrderModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "items": items,
      "timestamp": timestamp,
    };
  }

  // Save order to Firestore
  Future<void> save() async {
    CollectionReference orders =
        FirebaseFirestore.instance.collection("orders");
    await orders.add(toMap());
  }

  // Delete order from Firestore
  Future<void> delete() async {
    CollectionReference orders =
        FirebaseFirestore.instance.collection("orders");
    await orders.doc(id).delete();
  }
}
