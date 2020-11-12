import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:secondbuy/View/nav.dart';
import 'package:secondbuy/View/proddetails.dart';

class FavList extends StatefulWidget {
  @override
  _FavListState createState() => _FavListState();
}

class _FavListState extends State<FavList> {
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
      appBar: AppBar(
        title: Text(
          "Favourite List",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
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
      body: FutureBuilder<List<String>>(
        future: getFavouriteList(),
        builder: (BuildContext context, AsyncSnapshot favListSnapshot) {
          if (favListSnapshot.connectionState != ConnectionState.done)
            return Global.Loading("Loading");

          if (favListSnapshot.data.isEmpty) {
            return Global.Message("Your Favourite List is empty", 20,
                Icons.info, 30, Colors.blue);
          } else {
            return StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("products")
                    .onValue,
                builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                    //remove any product that is not purchased by the buyer
                    map.removeWhere((key, value) =>
                        !favListSnapshot.data.toString().contains(value['id']));

                    FirebaseDatabase.instance
                        .reference()
                        .child("products")
                        .onChildChanged
                        .listen((event) {
                      setState(() {});
                    });

                    if (map.values.isNotEmpty) {
                      return GridView.builder(
                          itemCount: map.values.toList().length,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
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
                              product_price: map.values.toList()[index]
                                  ['price'],
                              product_review: map.values.toList()[index]
                                  ['review'],
                              product_rating: map.values.toList()[index]
                                  ['rating'],
                              product_status: map.values.toList()[index]
                                  ['status'],
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
        },
      ),
    );
  }

  Future<List<String>> getFavouriteList() async {
    var purchaseDb = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(uid)
        .child("favItem");

    return purchaseDb.once().then((DataSnapshot snapshot) {
      List<String> favList = new List();

      if (snapshot.value != null) {
        try {
          snapshot.value.forEach((key, value) {
            Map<dynamic, dynamic> purchases = value;
            favList.add(purchases.values.toList()[0]);
          });
        } on NoSuchMethodError catch (e) {
          print(e.stackTrace);
        }
        return new List.from(favList);
      } else {
        return new List.from(favList);
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

  single_prod({
    this.product_id,
    this.product_name,
    this.product_photoURL,
    this.product_price,
    this.product_review,
    this.product_rating,
    this.product_status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
        child: Hero(
          tag: product_id,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProdDetails(prodID: product_id)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "RM " + product_price.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
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
}
