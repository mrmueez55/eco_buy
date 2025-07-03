// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eco_buy/models/order_model.dart';
// import 'package:flutter/material.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});
//   static const String id = "dashboard";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//       StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("orders")
//             .orderBy("timestamp", descending: true)
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No orders found"));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               final order =
//                   OrderModel.fromFirestore(snapshot.data!.docs[index]);
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Order ID: ${order.id}",
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text("User ID: ${order.userId}"),
//                         Text(
//                             "Order Date: ${order.timestamp?.toDate().toString() ?? "N/A"}"),
//                         SizedBox(height: 10),
//                         Text("Items:"),
//                         ...order.items!.map((item) => Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 2.0),
//                               child: Text(
//                                   "${item["productName"]} - ${item["quantity"]} x \$${item["price"]}"),
//                             )),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eco_buy/models/order_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const String id = "dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final order =
                  OrderModel.fromFirestore(snapshot.data!.docs[index]);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order ID: ${order.id}",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool confirm =
                                    await _showDeleteConfirmationDialog(
                                        context);
                                if (confirm) {
                                  await order.delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Order deleted successfully")));
                                }
                              },
                            ),
                          ],
                        ),
                        Text("User ID: ${order.userId}"),
                        Text(
                            "Order Date: ${order.timestamp?.toDate().toString() ?? "N/A"}"),
                        SizedBox(height: 10),
                        Text("Items:"),
                        ...order.items!.map((item) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                  "${item["productName"]} - ${item["quantity"]} x \$${item["price"]}"),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete Order'),
              content: Text('Are you sure you want to delete this order?'),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
