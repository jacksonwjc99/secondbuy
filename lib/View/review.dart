import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:secondbuy/View/reviewDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyReviews extends StatefulWidget {
  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
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

    //Purchase list not empty
    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("products").onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

            //remove any product that is not belong to seller
            map.removeWhere(
                (key, value) => value['sellerID'].toString() != uid);

            //remove any product that is not in review status
            map.removeWhere((key, value) =>
                !value['status'].toString().contains("reviewed"));
            print(map.values);

            if (map.values.isNotEmpty) {
              return GridView.builder(
                  itemCount: map.values.toList().length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1,
                    childAspectRatio: 3 / 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return single_prod(
                      product_id: map.values.toList()[index]['id'],
                      product_name: map.values.toList()[index]['name'],
                      product_photoURL: map.values
                          .toList()[index]['prodImg']
                          .values
                          .toList()[0]['image'],
                      product_price: map.values.toList()[index]['price'],
                      product_review: map.values.toList()[index]['review'],
                      product_reply: map.values.toList()[index]['reply'],
                      product_rating: map.values.toList()[index]['rating'],
                      product_status: map.values.toList()[index]['status'],
                    );
                  });
            } else {
              return Global.Message("You haven't review anything", 20,
                  Icons.info, 30, Colors.blue);
            }
          } else {
            return Global.Loading("Loading your purchase list");
          }
        });
  }

  Widget ReviewListButton() {
    return Container(
      child: OutlineButton(
        child: Text("Sell Now"),
        onPressed: () {},
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
    );
  }
}

// Product widget
class single_prod extends StatelessWidget {
  final product_id;
  final product_name;
  final product_photoURL;
  final product_price;
  final product_review;
  final product_rating;
  final product_status;
  final product_reply;

  single_prod({
    this.product_id,
    this.product_name,
    this.product_photoURL,
    this.product_price,
    this.product_review,
    this.product_reply,
    this.product_rating,
    this.product_status,
  });

  String reviewInput;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
      child: Card(
        child: Hero(
          tag: product_id,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.minimize),
                                    iconSize: 25,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Image.network(
                                    product_photoURL,
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        product_name,
                                        style: TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RatingBar(
                                    initialRating: double.parse(product_rating),
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    product_review,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Leave a reply",
                                            labelText: "Reply Review",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 20.0),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                          ),
                                          initialValue: product_reply,
                                          maxLines: 3,
                                          obscureText: false,
                                          validator: (value) => value.isEmpty
                                              ? "Leave reply before u submit"
                                              : null,
                                          onSaved: (value) =>
                                              reviewInput = value,
                                        ),
                                        OutlineButton(
                                          child: Text("Reply Review"),
                                          onPressed: () async {
                                            if (product_status == "reviewed") {
                                              if (_formKey.currentState.validate()) {
                                                _formKey.currentState.save();

                                                await PostReply();
                                                Fluttertoast.showToast(
                                                  msg: 'Your review is posted',
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black45,
                                                );
                                                Navigator.pop(context,true);
                                              }
                                              else{
                                                print(_formKey.currentState.validate());
                                              }
                                            }
                                            else{
                                              Fluttertoast.showToast(
                                                msg: 'You have replied this review',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black45,
                                              );
                                            }
                                          },
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0)),
                                          borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            width: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  isScrollControlled: true);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      product_photoURL,
                      fit: BoxFit.cover,
                      height: 100, width: 100,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            product_name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            product_review == null
                                ? "You have not review the product yet"
                                : product_review,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            product_reply == null
                                ? "You have not reply the review yet"
                                : "Reply: $product_reply",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Future PostReply() async {
    var productDb = FirebaseDatabase.instance
        .reference()
        .child("products")
        .child(product_id);
    await productDb.update({
      'reply': reviewInput.trim(),
      'status': 'reviewed&replied',
    });
  }
}
