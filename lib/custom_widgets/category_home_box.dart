import 'package:eco_buy/models/category_model.dart';
import 'package:eco_buy/screens/bottom_screens/product_screen.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CategoryHomeBoxes extends StatelessWidget {
  const CategoryHomeBoxes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            categories.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ProductScreen(
                          category: categories[index].title!,
                        );
                      }));
                    },
                    child: Container(
                      height: 13.h,
                      width: 20.w,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("${categories[index].image}"),
                          ),
                          color: Colors.white,
                          //   .primaries[Random().nextInt(categories.length)],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.4),
                          //     blurRadius: 2,
                          //     spreadRadius: 2,
                          //   )
                          // ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    categories[index].title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
