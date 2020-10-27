import 'package:flutter/material.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:firebase_database/firebase_database.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  var product_list = [
    {
      "name": "Bicycle",
      "photoURL": "images/bicycle1.jpg",
      "price": 100,
    },
    {
      "name": "Earphone",
      "photoURL": "images/earphone1.jpg",
      "price": 200,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: product_list.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return single_prod(
            product_name: product_list[index]['name'],
            product_photoURL: product_list[index]['photoURL'],
            product_price: product_list[index]['price'],
          );
        });
  }
}

class single_prod extends StatelessWidget {
  final product_name;
  final product_photoURL;
  final product_price;

  single_prod({
    this.product_name,
    this.product_photoURL,
    this.product_price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: product_name,
        child: Material(
          child: InkWell(
            onTap: () {},
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
              child: Image.asset(product_photoURL, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
