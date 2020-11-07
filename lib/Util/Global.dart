import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

import 'DB.dart';
class Global {
  static Random _rnd = Random();
  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  static String useruid = "";

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

  static String generateRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))
  ));
}