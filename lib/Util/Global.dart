import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'DB.dart';
class Global {
  static Random _rnd = Random();
  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  static String useruid = "";
  static String username = "";

  static Future<dynamic> getDBUser() async {
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

  static Widget Loading(String text) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height:10,
              ),
              Text(text),
            ],
          ),
        ],
      ),
    );
  }

  static Widget Message(String text, double textSize, IconData icon, double iconSize, Color iconColor) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
              SizedBox(
                height:10,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: textSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget PopUp(BuildContext context, title , message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}