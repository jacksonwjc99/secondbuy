import 'package:flutter/material.dart';
import 'package:secondbuy/proddetails.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
    return GridView.builder(
        itemCount: product_list.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return single_prod(
            product_id: product_list[index]['id'],
            product_name: product_list[index]['name'],
            product_photoURL: product_list[index]['photoURL'],
            product_price: product_list[index]['price'],
          );
        });
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
              child: Image.asset(product_photoURL, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
