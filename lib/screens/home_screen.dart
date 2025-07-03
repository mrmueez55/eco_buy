import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/custom_widgets/category_home_box.dart';
import 'package:eco_buy/models/product_model.dart';
import 'package:eco_buy/screens/product_detail_screen.dart';
import 'package:eco_buy/utils/styles.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final images = [
    "https://cdn.pixabay.com/photo/2016/11/22/19/08/hangers-1850082_1280.jpg",
    "https://cdn.pixabay.com/photo/2016/01/27/04/32/books-1163695_1280.jpg",
    "https://cdn.pixabay.com/photo/2014/08/26/21/49/jeans-428614_1280.jpg",
    "https://cdn.pixabay.com/photo/2018/02/04/09/09/brushes-3129361_1280.jpg",
    "https://cdn.pixabay.com/photo/2012/04/26/22/31/fabric-43354_1280.jpg",
    "https://cdn.pixabay.com/photo/2016/11/20/08/58/books-1842261_1280.jpg",
    "https://cdn.pixabay.com/photo/2016/11/19/17/02/chinese-1840332_1280.jpg",
  ];
  bool? isprogressIndica;
  List<Products> allProducts = [];

  getdata() async {
    await FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((e) {
        if (e.exists) {
          // for (var element in e["imageUrls"]) {
          // if (element.isNotEmpty) {
          setState(() {
            allProducts.add(
              Products(
                brand: e["brand"],
                category: e["category"],
                id: e["id"],
                productName: e["productName"],
                detail: e["detail"],
                price: e["price"],
                discontPrice: e["discontPrice"],
                serialCode: e["serialCode"],
                imageUrls: e["imageUrls"],
                isOnsale: e["isOnsale"],
                isPopular: e["isPopular"],
                isFavourite: e["isFavourite"],
              ),
            );
          });
          // }
          //   }
        }
      });
    });
    //  print(allProducts);
  }

  @override
  void initState() {
    getdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 19.h,
                child: Column(
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Eco",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                            text: "Buy",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CategoryHomeBoxes(),
                  ],
                ),
              ),
              Container(
                height: 69.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Carousel(images: images),
                      const Text(
                        "Popular Items",
                        style: EcoStyle.boldstyle,
                      ),
                      allProducts.length == 0
                          ? const CircularProgressIndicator()
                          : Popularitems(allProducts: allProducts),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 7.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.orange,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Hot Sales",
                                    textAlign: TextAlign.center,
                                    style: EcoStyle.boldstyle,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Expanded(
                              child: Container(
                                height: 7.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepOrange,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "New Arrivals",
                                    textAlign: TextAlign.center,
                                    style: EcoStyle.boldstyle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "Top Brands",
                        style: EcoStyle.boldstyle,
                      ),
                      Brands(allProducts: allProducts),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Popularitems extends StatelessWidget {
  const Popularitems({
    super.key,
    required this.allProducts,
  });

  final List<Products> allProducts;

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 15.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: allProducts
            .where((element) => element.isPopular == true)
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ProductDetailScreen(
                            id: e.id,
                          );
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          e.imageUrls![0],
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                    Expanded(child: Text(e.productName!)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class Brands extends StatelessWidget {
  const Brands({
    super.key,
    required this.allProducts,
  });

  final List<Products> allProducts;

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 10.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: allProducts
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 90,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.primaries[Random().nextInt(15)],
                    // border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: [
                        Text(
                          e.brand![0],
                          style: EcoStyle.boldstyle.copyWith(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          e.brand!,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class Carousel extends StatelessWidget {
  const Carousel({
    super.key,
    required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images
          .map(
            (e) => Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: e,
                      placeholder: (c, i) => StepProgressIndicator(
                        totalSteps: 10,
                        currentStep: 7,
                        selectedColor: Colors.pink,
                        unselectedColor: Colors.amber,
                        customSize: (index, isprogressIndica) =>
                            (index + 1) * 10.0,
                      ),
                      fit: BoxFit.cover,
                      height: 140,
                      width: double.infinity,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: FancyShimmerImage(
                //     imageUrl: e,
                //     shimmerBaseColor: Colors.grey[300],
                //     // shimmerBackColor: Colors.grey,
                //     shimmerHighlightColor: Colors.grey,
                //     shimmerDuration: const Duration(milliseconds: 1000),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     height: 200,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //       gradient: LinearGradient(
                //         colors: [
                //           Colors.redAccent.withOpacity(0.3),
                //           Colors.blueAccent.withOpacity(0.3),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom: 25,
                //   left: 19,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white.withOpacity(0.5),
                //     ),
                //     child: const Padding(
                //       padding: EdgeInsets.all(8.0),
                //       child: Text(
                //         "Title",
                //         style: TextStyle(
                //           fontSize: 20,
                //           color: Colors.black,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          )
          .toList(),
      options: CarouselOptions(
        height: 140,
        autoPlay: true,
      ),
    );
  }
}
