import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  String? category;
  String? id;
  String? productName;
  String? detail;
  int? price;
  String? brand;
  int? discontPrice;
  String? serialCode;
  List<dynamic>? imageUrls;
  bool? isOnsale;
  bool? isPopular;
  bool? isFavourite;

  Products({
    this.category,
    this.id,
    this.productName,
    this.detail,
    this.price,
    this.brand,
    this.discontPrice,
    this.serialCode,
    this.imageUrls,
    this.isOnsale,
    this.isPopular,
    this.isFavourite,
  });

  // CollectionReference db = FirebaseFirestore.instance.collection("products");

  static Future<void> addProducts(Products products) async {
    CollectionReference db = FirebaseFirestore.instance.collection("products");

    Map<String, dynamic> data = {
      "category": products.category,
      "id": products.id,
      "productName": products.productName,
      "detail": products.detail,
      "price": products.price,
      "brand": products.brand,
      "discontPrice": products.discontPrice,
      "serialCode": products.serialCode,
      "imageUrls": products.imageUrls,
      "isOnsale": products.isOnsale,
      "isPopular": products.isPopular,
      "isFavourite": products.isFavourite,
    };
    await db.add(data);
  }

  static Future<void> updateProduts(String id, Products updateProducts) async {
    CollectionReference db = FirebaseFirestore.instance.collection("products");

    Map<String, dynamic> data = {
      "category": updateProducts.category,
      "id": updateProducts.id,
      "productName": updateProducts.productName,
      "detail": updateProducts.detail,
      "price": updateProducts.price,
      "brand": updateProducts.brand,
      "discontPrice": updateProducts.discontPrice,
      "serialCode": updateProducts.serialCode,
      "imageUrls": updateProducts.imageUrls,
      "isOnsale": updateProducts.isOnsale,
      "isPopular": updateProducts.isPopular,
      "isFavourite": updateProducts.isFavourite,
    };
    await db.doc(id).update(data);
  }

  static Future<void> deleteProduct(String id) async {
    CollectionReference db = FirebaseFirestore.instance.collection("products");

    await db.doc(id).delete();
  }
}
