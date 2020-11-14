import 'package:flutter/material.dart';
import 'package:secondbuy/Util/Components/products.dart';
import 'package:secondbuy/View/nav.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key key,
    @required this.product});
  final Products product;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Products',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Nav(page: "Hamepage")),
              );
            }),
      ),
      body: Container(
        child: widget.product,
      ),
    );
  }

}