import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:secondbuy/Util/Components/util.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondbuy/View/editProduct.dart';
import 'package:secondbuy/View/nav.dart';

import 'Chatting.dart';

class ProdDetails extends StatefulWidget {
  ProdDetails({Key key, @required this.prodID}) : super(key: key);
  final String prodID;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProdDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("products")
            .child(widget.prodID)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

            double c_width = MediaQuery.of(context).size.width * 0.94;

            Widget image_carousel = new Container(
              height: 280.0,
              child: new Carousel(
                boxFit: BoxFit.cover,
                images: [
                  Image.network(
                      map.values.toList()[0].values.toList()[0]['image']),
                ],
                autoplay: true,
                autoplayDuration: Duration(seconds: 8),
                animationCurve: Curves.fastOutSlowIn,
                animationDuration: Duration(milliseconds: 1000),
                dotSize: 3.0,
                indicatorBgPadding: 4.0,
              ),
            );

            //0 - image id
            //1 - address
            //2 - sellerName
            //3 - condition
            //4 - sellerID
            //5 - dealopt
            //6 - price
            //7 - name
            //8 - details
            //9 - fav
            //10 - location
            //11 - sellDate
            //12 - prodID
            //13 - category
            //14 - subcategory
            //15 - status

            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  map.values.toList()[7],
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  map.values.toList()[4] == uid
                      ? IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditProduct(productID: widget.prodID)),
                            );
                          },
                        )
                      : Container(),
                ],
                centerTitle: true,
                elevation: 0,
                automaticallyImplyLeading: true,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              body: SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    Divider(color: Colors.black),
                    //show slide
                    image_carousel,
                    Row(
                      children: <Widget>[
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Product
                            new Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, bottom: 10.0, top: 20.0),
                              child: new Text(
                                'About the Product',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),

                            new Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: new Text(
                                'Product Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Container(
                              padding: const EdgeInsets.only(left: 30.0),
                              width: c_width,
                              child: new Text(
                                map.values.toList()[7],
                              ),
                            ),
                            SizedBox(height: 30.0),

                            new Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: new Text(
                                'Price',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Container(
                              padding: const EdgeInsets.only(left: 30.0),
                              width: c_width,
                              child: new Text(
                                map.values.toList()[6].toString(),
                              ),
                            ),
                            SizedBox(height: 30.0),

                            new Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: new Text(
                                'Upload Time',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Container(
                              padding: const EdgeInsets.only(left: 30.0),
                              width: c_width,
                              child: new Text(
                                Util.timeSinceSet(
                                    map.values.toList()[11].toString()),
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            SizedBox(height: 30.0),

                            new Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: new Text(
                                'Condition',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Container(
                              padding: const EdgeInsets.only(left: 30.0),
                              width: c_width,
                              child: new Text(
                                map.values.toList()[3].toString(),
                              ),
                            ),
                            SizedBox(height: 30.0),

                            new Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: new Text(
                                'Product Description',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Container(
                              padding: const EdgeInsets.only(left: 30.0),
                              width: c_width,
                              child: new Text(
                                map.values.toList()[8].toString(),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(height: 30.0),

                            //deal option
                            new Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, bottom: 10.0),
                              child: new Text(
                                'Getting This',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),

                            new Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: new Text(
                                'Deal Option',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Container(
                              padding: const EdgeInsets.only(left: 30.0),
                              width: c_width,
                              child: new Text(
                                map.values.toList()[5].toString() == "delivery"
                                    ? map.values.toList()[5].toString()
                                    : map.values.toList()[5].toString() +
                                        " at " +
                                        map.values.toList()[1].toString(),
                              ),
                            ),
                            SizedBox(height: 30.0),

                            //seller details
                            new Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, bottom: 10.0),
                              child: new Text(
                                'About the Seller',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),

                            new Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: new Text(
                                'Seller Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Container(
                              padding: const EdgeInsets.only(left: 30.0),
                              width: c_width,
                              child: new Text(
                                map.values.toList()[2].toString(),
                              ),
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: new IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
                                  bool isFav = await FavProduct(
                                      map.values.toList()[12].toString(),
                                      map.values.toList()[9]);
                                  print("FAVOURITED " + isFav.toString());
                                  if (isFav == true) {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text(
                                            'You have unfavourited this product')));
                                  } else {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text(
                                            'You have favourited this product')));
                                  }
                                })),
                        Expanded(
                          child: OutlineButton(
                            child: Text("Chat"),
                            onPressed: () {
                              if (map.values.toList()[4].toString() == uid)
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('You are the seller')));
                              else if (map.values.toList()[15].toString() !=
                                  'selling')
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('The product is sold')));
                              else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chatting(
                                              contactID: map.values
                                                  .toList()[4]
                                                  .toString(),
                                              contactName: map.values
                                                  .toList()[2]
                                                  .toString(),
                                              contactPic:
                                                  "https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg",
                                              prodID: map.values
                                                  .toList()[12]
                                                  .toString(),
                                            )));
                              }
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          flex: 1,
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: OutlineButton(
                            child: Text("Make Offers"),
                            onPressed: () {
                              if (map.values.toList()[4].toString() == uid)
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('You are the seller')));
                              else if (map.values.toList()[15].toString() !=
                                  'selling')
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('The product is sold')));
                              else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chatting(
                                              contactID: map.values
                                                  .toList()[4]
                                                  .toString(),
                                              contactName: map.values
                                                  .toList()[2]
                                                  .toString(),
                                              contactPic:
                                                  "https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg",
                                              prodID: map.values
                                                  .toList()[12]
                                                  .toString(),
                                            )));
                              }
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          flex: 1,
                        ),
                        SizedBox(width: 20.0),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<bool> FavProduct(String productId, int favCount) async {
    var favRef = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(uid)
        .child("favItem");
    var productRef = FirebaseDatabase.instance
        .reference()
        .child("products")
        .child(productId);
    bool isDuplicate = false;
    bool firstInsert = false;
    String keyToDelete;

    await favRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) {
          if (value['id'] == productId) {
            isDuplicate = true;
            keyToDelete = key;
          }
        });
      } else {
        // if not fav list found, directly add to favourite
        firstInsert = true;

        productRef.update({
          'fav': favCount + 1,
        });

        favRef.push().set({
          'id': productId,
        });
      }


      if (firstInsert == false) {
        // check if fav item is exist when tapped on the fav icon
        if (isDuplicate == true) {
          //duplicated fav item = --fav
          productRef.update({
            'fav': favCount - 1,
          });

          favRef.child(keyToDelete).remove();
        } else {
          // non duplicate = ++ fav
          productRef.update({
            'fav': favCount + 1,
          });

          favRef.push().set({
            'id': productId,
          });
        }
      }
    });

    if (isDuplicate == true)
      return true;
    else
      return false;
  }
}
