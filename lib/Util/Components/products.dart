import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secondbuy/View/proddetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Products extends StatefulWidget {
  Products({Key key, @required this.category, @required this.subCategory}) : super(key: key);
  final String category;
  final String subCategory;

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var productList = [];
  var imageList = [];
  var product_list = [
    {
      "id": "1",
      "name": "Bicycle",
      "photoURL": "images/bicycle1.jpg",
      "price": 200,
    },
    {
      "id": "2",
      "name": "Earphone",
      "photoURL": "images/earphone1.jpg",
      "price": 300,
    },
    {
      "id": "3",
      "name": "Fan",
      "photoURL": "images/fan1.jpg",
      "price": 100,
    },
    {
      "id": "4",
      "name": "Earphone",
      "photoURL": "images/earphone1.jpg",
      "price": 100,
    },
    {
      "id": "5",
      "name": "Bicycle",
      "photoURL": "images/bicycle1.jpg",
      "price": 100,
    },
    {
      "id": "6",
      "name": "Fan",
      "photoURL": "images/fan1.jpg",
      "price": 100,
    },
    {
      "id": "7",
      "name": "Fan",
      "photoURL": "images/fan1.jpg",
      "price": 100,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.reference().child("products").onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {

        print("GG >> " + imageList.toString());

        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

          String secondKey = "";

          map.forEach((key, value) {
            FirebaseDatabase.instance.reference().child("products").child(key).child("prodImg").once().then((DataSnapshot imgSnapshot) {
              Map<dynamic, dynamic> images = imgSnapshot.value;
              images.forEach((imgKey, imgValue) {
                String firstKey = key;

                if(firstKey != secondKey){
                  imageList.add(imgValue['image']);
                  secondKey = firstKey;
                  print(imgValue);
                }

              });
            });
          });

          return GridView.builder(
              itemCount: map.values.toList().length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                print("aa");
                return single_prod(
                  product_id: map.values.toList()[index]['id'],
                  product_name: map.values.toList()[index]['name'],
                  product_photoURL: imageList.toList()[index],
                  product_price: map.values.toList()[index]['price'],
                );
              });
        }
        else {
          return CircularProgressIndicator();
        }
      }
    );

  }

}


class single_prod extends StatelessWidget {
  final product_id;
  final product_name;
  final product_photoURL;
  final product_price;

  single_prod({
    this.product_id,
    this.product_name,
    this.product_photoURL,
    this.product_price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: product_id,
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProdDetails()),
              );
            },
            child: GridTile(
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(
                    product_name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    "RM $product_price",
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              child: Image.network(product_photoURL, fit: BoxFit.cover),
              //child: Text("HELLO"),
            ),
          ),
        ),
      ),
    );
  }


}



