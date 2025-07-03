import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/custom_widgets/header.dart';
import 'package:eco_buy/models/product_model.dart';
import 'package:eco_buy/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  String? category;
  ProductScreen({super.key, this.category});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Products> allProducts = [];
  TextEditingController searchC = TextEditingController();

  getdata() async {
    await FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot snapshot) {
      if (widget.category == null) {
        snapshot.docs
            //  .where((element) => element["category"] == widget.category)
            .forEach((e) {
          if (e.exists) {
            // for (var element in e["imageUrls"]) {
            //  if (element.isNotEmpty) {
            setState(() {
              allProducts.add(
                Products(
                  // brand: e["brand"],
                  // category: e["category"],
                  id: e["id"],
                  productName: e["productName"],
                  // detail: e["detail"],
                  // price: e["price"],
                  // discontPrice: e["discontPrice"],
                  // serialCode: e["serialCode"],
                  imageUrls: e["imageUrls"],
                  // isOnsale: e["isOnsale"],
                  // isPopular: e["isPopular"],
                  // isFavourite: e["isFavourite"],
                ),
              );
            });
            //   }
            //  }
          }
        });
      } else {
        snapshot.docs
            .where((element) => element["category"] == widget.category)
            .forEach((e) {
          if (e.exists) {
            // for (var element in e["imageUrls"]) {
            //   if (element.isNotEmpty) {
            setState(() {
              allProducts.add(
                Products(
                  // brand: e["brand"],
                  // category: e["category"],
                  id: e["id"],
                  productName: e["productName"],
                  // detail: e["detail"],
                  // price: e["price"],
                  // discontPrice: e["discontPrice"],
                  // serialCode: e["serialCode"],
                  imageUrls: e["imageUrls"],
                  // isOnsale: e["isOnsale"],
                  // isPopular: e["isPopular"],
                  // isFavourite: e["isFavourite"],
                ),
              );
            });
          }
          //   }
          // }
        });
      }
    });
    //  print(allProducts);
  }

  List<Products> totalItems = [];

  @override
  void initState() {
    getdata();
    Future.delayed(const Duration(seconds: 1), () {
      totalItems.addAll(allProducts);
    });

    super.initState();
  }

  filterdata(String query) {
    List<Products> dummySearch = [];
    dummySearch.addAll(allProducts);
    if (query.isNotEmpty) {
      List<Products> dummyData = [];
      dummySearch.forEach((element) {
        if (element.productName!.toLowerCase().contains(query.toLowerCase())) {
          dummyData.add(element);
        }
      });
      setState(() {
        allProducts.clear();
        allProducts.addAll(dummyData);
      });
    } else {
      setState(() {
        allProducts.clear();
        allProducts.addAll(totalItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(5.h),
          child: Header(
            // ignore: unnecessary_string_interpolations
            title: "${widget.category ?? "All Products"}",
          )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: searchC,
              onChanged: (v) {
                filterdata(searchC.text);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                hintText: "Search",
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: allProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return ProductDetailScreen(
                            id: allProducts[index].id,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.network(
                                allProducts[index].imageUrls!.last,
                                height: 150,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Text(
                            allProducts[index].productName!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
