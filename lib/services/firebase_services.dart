import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static Future<bool> adminLoginn(String username, String password) async {
    final docRef = FirebaseFirestore.instance.collection('admin').doc(username);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final storedUsername = data!['username'];
      final storedPassword = data['password'];

      return username == storedUsername && password == storedPassword;
    } else {
      return false;
    }
  }

  static Future<DocumentSnapshot> adminLogin(id) async {
    var result = FirebaseFirestore.instance.collection("admin").doc(id).get();
    print(result);
    return result;
  }

  static Future<String?> createAccount(String email, String pass) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        return "Email is used already";
      }
      if (e.code == "ERROR_WRONG_PASSWORD") {
        return "Email or password is wrong";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<String?> loginAccount(String email, String pass) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}

class Updaete {
  static Future<void> signout(String id, Products products) async {
    await FirebaseFirestore.instance.doc(id).update({
      "category": products.category,
      "id": products.id,
      "productName": products.productName,
      "price": products.price,
      "discontPrice": products.discontPrice,
      "serialCode": products.serialCode,
      "imageUrls": products.imageUrls,
      "isOnsale": products.isOnsale,
      "isPopular": products.isPopular,
      "isFavourite": products.isFavourite,
    });
  }
}
