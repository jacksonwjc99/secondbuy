import 'package:flutter/material.dart';

class User {
  String address;
  String contact;
  String email;
  String id;
  String password;
  String photoURL;
  String username;

  User({this.id = "", this.address = "", this.contact = "", this.email = "",
    this.password = "", this.photoURL = "", this.username = ""});
}