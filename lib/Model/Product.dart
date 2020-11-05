import 'package:flutter/material.dart';

class Product {
  String id;
  String name;
  String category;
  String subCategory;
  String dealOpt;
  String condition;
  String details;
  double price;
  DateTime sellDate;
  String sellerID;
  String sellerName;
  String status;
  String location;

  Product({this.id = "id", this.name = "unknown", this.category = "none", this.subCategory = "none",
  this. dealOpt = "none", this.condition = "none", this.details = "details", this.price = 0, this. sellDate = null,
  this. sellerID = "id", this.sellerName ="John Doe", this.status = "none", this.location = "somewhere"});


}