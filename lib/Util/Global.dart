import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'DB.dart';
class Global {
  static Future<dynamic> getUserDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    return DB
        .get(DB.db().reference().child("users").child(user.uid))
        .then((var value) {
      return value;
    });
  }

  static Future<dynamic> getProductDetails(id) async {
    return DB
        .get(DB.db().reference().child("products").child(id))
        .then((var value) {
      return value;
    });
  }

  static Future<dynamic> getAllProduct() async {
    return DB
        .get(DB.db().reference().child("products"))
        .then((var value) {
      return value;
    });
  }
}