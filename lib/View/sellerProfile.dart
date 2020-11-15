import 'package:flutter/material.dart';
import 'package:secondbuy/Model/User.dart';
import 'package:secondbuy/Util/Components/about.dart';
import 'package:secondbuy/Util/Components/products.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:secondbuy/View/review.dart';
import 'package:secondbuy/View/searchSeller.dart';

import 'SellerReview.dart';

class SellerProfile extends StatefulWidget {
  SellerProfile({Key key, @required this.id}) : super(key: key);
  final String id;

  @override
  _SellerProfileState createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  Future<dynamic> getData() {
    return FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(widget.id)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> userDB = snapshot.value;

      var user = new User();
      user.address = userDB['address'];
      user.contact = userDB['contact'];
      user.email = userDB['email'];
      user.id = userDB['id'];
      user.password = userDB['password'];
      user.photoURL = userDB['photoURL'];
      user.username = userDB['username'];

      return user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getData(),
          // Must return type Future, eg. Future<User> getUser()
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // If data still loading
            if (snapshot.connectionState != ConnectionState.done) {
              // Return loading symbol
              //return new CircularProgressIndicator();
            }

            // If no data
            if (!snapshot.hasData) {
              print("no data");
              return new Container();
            }

            // If got data
            User user = snapshot.data;

            // Display here
            return new Stack(
              children: <Widget>[
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 90,
                        color: Colors.black26,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 30,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchSeller()),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),

                      Container(
                        height: 100,
                        color: Colors.black12,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 40.0,
                              right: 25,
                              child: Container(
                                child: new Text(
                                  user.username,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //tab bar
                      Container(
                        constraints: BoxConstraints.expand(height: 50),
                        child: TabBar(
                            labelColor: Colors.black87,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(
                                text: "Listings",
                              ),
                              Tab(
                                text: "Reviews",
                              ),
                              Tab(
                                text: "About",
                              ),
                            ]),
                      ),

                      //content
                      Expanded(
                        child: Container(
                          child: TabBarView(children: [
                            Container(
                              child: Products(
                                category: "",
                                subCategory: "",
                                sellerProd: true,
                                id: widget.id,),
                            ),
                            Container(
                              child: SellerReview(id: widget.id),
                            ),
                            Container(
                              child: About(
                                  id: user.id,
                                  email: user.email,
                                  contact: user.contact,
                                  address: user.address),
                            ),
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 40.0,
                  // (background container size) - (circle height / 2)
                  right: 20,
                  child: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(user.photoURL),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black45, width: 2)),
                  ),
                ),
              ],
            );
          }),

      /*
      Stack(
        children: <Widget>[
          DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
                Container(
                  height: 90,
                  color: Colors.black26,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: 15,
                          right: 0,
                          child: IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.black,
                              ),
                              onPressed: () {})),
                    ],
                  ),
                ),

                Container(
                  height: 100,
                  color: Colors.black12,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 40.0,
                        left: 25,
                        child: Container(
                          child: new Text(
                            username.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                //tab bar
                Container(
                  constraints: BoxConstraints.expand(height: 50),
                  child: TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: "Listings",
                        ),
                        Tab(
                          text: "Reviews",
                        ),
                        Tab(
                          text: "About",
                        ),
                      ]),
                ),

                //content
                Expanded(
                  child: Container(
                    child: TabBarView(children: [
                      Container(
                        child: Products(
                            category: "", subCategory: "", sellerProd: true),
                      ),
                      Container(
                        child: Text("Reviews"),
                      ),
                      Container(
                        child: About(
                            id: id,
                            email: email,
                            contact: contact,
                            address: address),
                      ),
                    ]),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 40.0, // (background container size) - (circle height / 2)
            left: 20,
            child: Container(
              height: 80.0,
              width: 80.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg"),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black45, width: 2)),
            ),
          ),
        ],
      ),*/
    );
  }
}

/*
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          body: Stack(
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(color: Colors.black),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: TabBarView(children: [
                          Container(
                            child: Products(),
                          ),
                          Container(
                            child: Text("My Purchases"),
                          ),
                          Container(
                            child: Text("Reviews"),
                          ),
                        ]),
                      ),
                      flex: 1,
                    ),
                  ],
                ),

              ),

              Positioned(
                top: 0.0, // (background container size) - (circle height / 2)
                left: 30,
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                  ),
                ),
              )
            ],
          ),

          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              Container(
                child: SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: "Listings",
                        ),
                        Tab(
                          text: "My Purchases",
                        ),
                        Tab(
                          text: "Reviews",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}
*/

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
