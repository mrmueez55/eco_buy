import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/custom_widgets/ecobutton.dart';
import 'package:eco_buy/custom_widgets/header.dart';
import 'package:eco_buy/models/cart_model.dart';
import 'package:eco_buy/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? id;
  const ProductDetailScreen({super.key, this.id});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<Products> allProducts = [];
  int count = 1;
  var newPrice = 0;
  bool isLoadingCart = false;

  getdata() async {
    await FirebaseFirestore.instance.collection("products").get().then(
      (QuerySnapshot snapshot) {
        snapshot.docs.where((element) => element["id"] == widget.id).forEach(
          (e) {
            if (e.exists) {
              for (var element in e["imageUrls"]) {
                if (element.isNotEmpty) {
                  setState(
                    () {
                      allProducts.add(
                        Products(
                          // brand: e["brand"],
                          // category: e["category"],
                          id: e["id"],
                          productName: e["productName"],
                          detail: e["detail"],
                          price: e["price"],
                          discontPrice: e["discontPrice"],
                          // serialCode: e["serialCode"],
                          imageUrls: e["imageUrls"],
                          // isOnsale: e["isOnsale"],
                          // isPopular: e["isPopular"],
                          // isFavourite: e["isFavourite"],
                        ),
                      );
                    },
                  );
                }
              }
            }
            newPrice = allProducts.first.price!;
          },
        );
      },
    );
  }

  addtoFavourite() async {
    // we can also use this method for adding to fav
    // FirebaseFirestore.instance
    //     .collection("favourite")
    //     .doc(FirebaseAuth.instance.currentUser!.uid).collection("items").add({});
    ///////          WE CAN ALSO USE FOLLOWING MEtHOD
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("favourite");
    await collectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .add({
      "pid": allProducts.first.id,
    });
  }

  removetoFavourite(String id) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("favourite");
    await collectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .doc(id)
        .delete();
  }

  @override
  void initState() {
    getdata();
    //  getdataFav();

    super.initState();
  }

  bool isfvrt = false;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return allProducts.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(5.h),
              child: Header(
                // ignore: unnecessary_string_interpolations
                title: allProducts.first.productName,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 6,
                  ),
                  Image.network(
                    allProducts[0].imageUrls![selectedIndex],
                    height: 48.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(
                          allProducts[0].imageUrls!.length,
                          (index) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 5.h,
                                width: 8.w,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    allProducts[0].imageUrls![index],
                                    // height: 10.h,
                                    // width: 10.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 5.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "${allProducts.first.price}PKR",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        minWidth: double.infinity, minHeight: 30.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Text(
                      allProducts.first.detail!,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "This discounted price for one item will be${allProducts.first.discontPrice}PKR when you will order more than 3 items"),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (count > 1) {
                                    count--;
                                    if (count > 3) {
                                      newPrice = count *
                                          allProducts.first.discontPrice!;
                                    } else {
                                      newPrice =
                                          count * allProducts.first.price!;
                                    }
                                  }
                                });
                              },
                              icon: const Icon(Icons.exposure_minus_1),
                            ),
                            Text("$count"),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  count++;
                                  if (count > 3) {
                                    newPrice =
                                        count * allProducts.first.discontPrice!;
                                  } else {
                                    newPrice = count * allProducts.first.price!;
                                  }
                                });
                              },
                              icon: const Icon(Icons.exposure_plus_1),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 5.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "${newPrice}PKR",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("favourite")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("items")
                                .where("pid", isEqualTo: allProducts.first.id)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.data == null) {
                                return Text("nhbjbjbcjas");
                              }
                              return IconButton(
                                onPressed: () {
                                  snapshot.data!.docs.length == 0
                                      ? addtoFavourite()
                                      : removetoFavourite(
                                          snapshot.data!.docs.first.id);
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: snapshot.data!.docs.length == 0
                                      ? Colors.black
                                      : Colors.red,
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  EcoButton(
                    onpress: () {
                      setState(() {
                        isLoadingCart = true;
                      });
                      Cart.addtoCart(Cart(
                        id: allProducts.first.id,
                        image: allProducts.first.imageUrls!.first,
                        name: allProducts.first.productName,
                        quantity: count,
                        price: newPrice,
                      )).whenComplete(() {
                        setState(() {
                          isLoadingCart = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Added to Cart Successfully")));
                        });
                      });
                    },
                    text: "Add to Cart",
                  ),
                  SizedBox(
                    height: 70,
                  ),
                ],
              ),
            ),
          );
  }
}
