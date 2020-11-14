import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondbuy/View/nav.dart';

class ReviewItem extends StatefulWidget {
  ReviewItem(
      {Key key,
      @required this.prodID,
      @required this.prodName,
      @required this.prodPic,
      @required this.prodStatus,
      @required this.prodReview,
      @required this.prodPrice,
      @required this.prodRating})
      : super(key: key);
  final String prodID;
  final String prodName;
  final String prodPic;
  final String prodStatus;
  final String prodReview;
  final double prodPrice;
  final int prodRating;

  @override
  _ReviewItem createState() => _ReviewItem();
}

class _ReviewItem extends State<ReviewItem> {
  String reviewInput;
  int ratings;
  final _formKey = GlobalKey<FormState>();
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

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Review',
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
                MaterialPageRoute(builder: (context) => Nav(page: "Profile")),
              );
            }),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Image.network(
                      widget.prodPic,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.prodName,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RatingBar(
                            initialRating: widget.prodRating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                ratings = rating.toInt();
                                print(ratings);
                              });
                            },
                          ),
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Leave a review",
                        labelText: "Review",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                      initialValue: widget.prodReview,
                      maxLines: 3,
                      obscureText: false,
                      validator: (value) =>
                          value.isEmpty ? "Leave review before u submit" : null,
                      onSaved: (value) => reviewInput = value,
                    ),
                    OutlineButton(
                      child: Text("Post Review"),
                      onPressed: () async {
                        if (widget.prodStatus == "sold") {
                          if (_formKey.currentState.validate()) {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('Posting your review')));
                            print(_formKey.currentState.validate());
                            _formKey.currentState.save();

                            await PostReview();
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Your review is posted !')));
                            Timer(Duration(seconds: 8), () {
                              // 5s over, navigate to a new page
                              Navigator.pop(context, true);
                            });
                          } else {
                            print(_formKey.currentState.validate());
                          }
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content:
                                  Text('You have reviewed this product.')));
                        }
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future PostReview() async {
    var productDb = FirebaseDatabase.instance
        .reference()
        .child("products")
        .child(widget.prodID);
    await productDb.update({
      'review': reviewInput.trim(),
      'rating': ratings.toString(),
      'status': 'reviewed',
    });
  }
}
