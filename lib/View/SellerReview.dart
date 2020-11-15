import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:secondbuy/Util/Global.dart';

class SellerReview extends StatefulWidget {
  SellerReview({Key key, @required this.id}) : super(key: key);
  final String id;

  @override
  _SellerReviewState createState() => _SellerReviewState();
}

class _SellerReviewState extends State<SellerReview> {

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    //Purchase list not empty
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child("products")
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

            //remove any product that is not belong to seller
            map.removeWhere(
                    (key, value) => value['sellerID'].toString() != widget.id);

            //remove any product that is not in review status
            map.removeWhere((key, value) =>
            !value['status'].toString().contains("reviewed"));
            print(map.values);

            if (map.values.isNotEmpty) {
              return GridView.builder(
                  itemCount: map.values
                      .toList()
                      .length,
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
                        height: 100,
                        width: 100,
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
                                  ? ""
                                  : product_review,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              product_reply == null
                                  ? ""
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
