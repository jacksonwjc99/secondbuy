import 'package:flutter/material.dart';
import 'package:secondbuy/Model/Product.dart';
import 'package:secondbuy/View/proddetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Global.dart';

class Products extends StatefulWidget {
  Products({Key key, @required this.category, @required this.subCategory, @required this.sellerProd}) : super(key: key);
  final String category;
  final String subCategory;
  final bool sellerProd;


  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var productList = [];
  var imageList = [];
  var uid;
  var i = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void getUserID() async {
    final FirebaseUser user = await auth.currentUser();
    if (i == 0) {
      setState(() {
        uid = user.uid;
      });
      i++;
    }
  }


  @override
  Widget build(BuildContext context) {
    getUserID();
    //print("==> " + widget.sellerProd.toString());
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("products").onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

            if (widget.sellerProd == null && widget.subCategory == null && widget.category == null) { //Show all Product
              map.removeWhere((key, value) => value['status'] != "selling");
              if (map.values.isNotEmpty) {
                return GridView.builder(
                    itemCount: map.values.toList().length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return single_prod(
                        product_id: map.values.toList()[index]['id'],
                        product_name: map.values.toList()[index]['name'],
                        product_photoURL: map.values.toList()[index]['prodImg'].values.toList()[0]['image'],
                        product_price: map.values.toList()[index]['price'],
                      );
                    });
              }
              else {
                return Card (
                  child: Global.Message("Product not found", 20, Icons.error, 30, Colors.red),
                );
              }

            }
            else if (widget.category != '') { //category
              print("Category = " + widget.category);
              map.removeWhere((key, value) => value['category'] != widget.category.toString());
              if (map.values.isNotEmpty) {
                return GridView.builder(
                    itemCount: map.values.toList().length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return single_prod(
                        product_id: map.values.toList()[index]['id'],
                        product_name: map.values.toList()[index]['name'],
                        product_photoURL: map.values.toList()[index]['prodImg'].values.toList()[0]['image'],
                        product_price: map.values.toList()[index]['price'],
                      );
                    });
              }
              else {
                return Card (
                  child: Global.Message("Product not found", 20, Icons.info, 30, Colors.red),
                );
              }

            }
            else if (widget.subCategory != '') {  //subcategory
              print("Subcategory = " + widget.subCategory);
              map.removeWhere((key, value) => value['subcategory'] != widget.subCategory);
              if (map.values.isNotEmpty) {
                return GridView.builder(
                    itemCount: map.values.toList().length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return single_prod(
                        product_id: map.values.toList()[index]['id'],
                        product_name: map.values.toList()[index]['name'],
                        product_photoURL: map.values.toList()[index]['prodImg'].values.toList()[0]['image'],
                        product_price: map.values.toList()[index]['price'],
                      );
                    });
              }
              else {
                return Card (
                  child: Global.Message("Product not found", 20, Icons.info, 30, Colors.red),
                );
              }

            }
            else{ // Listings
              map.removeWhere((key, value) => value['sellerID'] != Global.useruid);
              if (Global.useruid != '') {
                if(map.values.isNotEmpty) {
                  return GridView.builder(
                      itemCount: map.values.toList().length,
                      shrinkWrap: true,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return single_prod(
                          product_id: map.values.toList()[index]['id'],
                          product_name: map.values.toList()[index]['name'],
                          product_photoURL: map.values.toList()[index]['prodImg'].values.toList()[0]['image'],
                          product_price: map.values.toList()[index]['price'],
                        );

                      });
                }
                else {
                  return Global.Message("Your Listing is Empty", 20, Icons.info, 30, Colors.blue);
                }

              }
              else {
                return Global.Message("Your Listings is empty", 20, Icons.info, 30, Colors.blue);
              }

            }

          }
          else {
            return CircularProgressIndicator();
          }
        }
    );
  }

//

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
                MaterialPageRoute(builder: (context) => ProdDetails(prodID : product_id)),
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



