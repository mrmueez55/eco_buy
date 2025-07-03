import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/models/product_model.dart';
import 'package:eco_buy/screens/web_site/update_complete_screen.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class UpdateProductScreen extends StatelessWidget {
  UpdateProductScreen({super.key});
  static const String id = "updateproduct";

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Center(
        child: Column(
          children: [
            const Text(
              "Update Product",
              style: EcoStyle.boldstyle,
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data == null) {
                  return const Center(child: Text("No Data Found"));
                }
                final data = snapshot.data!.docs;
                // ignore: avoid_unnecessary_containers
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            color: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: GestureDetector(
                                onTap: () {},
                                child: ListTile(
                                  title: Text(
                                    data[index]["productName"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: Container(
                                    width: 10.w,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) {
                                                  return UpdateCompleteProductScreen(
                                                    id: data[index].id,
                                                    products: Products(
                                                      brand: data[index]
                                                          ["brand"],
                                                      category: data[index]
                                                          ["category"],
                                                      id: id,
                                                      productName: data[index]
                                                          ["productName"],
                                                      detail: data[index]
                                                          ["detail"],
                                                      price: data[index]
                                                          ["price"],
                                                      discontPrice: data[index]
                                                          ["discontPrice"],
                                                      serialCode: data[index]
                                                          ["serialCode"],
                                                      imageUrls: data[index]
                                                          ["imageUrls"],
                                                      isOnsale: data[index]
                                                          ["isOnsale"],
                                                      isPopular: data[index]
                                                          ["isPopular"],
                                                      isFavourite: data[index]
                                                          ["isFavourite"],
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Products.deleteProduct(
                                                data[index].id);
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
