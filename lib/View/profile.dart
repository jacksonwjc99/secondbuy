import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secondbuy/Model/User.dart';
import 'package:secondbuy/Util/Components/about.dart';
import 'package:secondbuy/Util/Components/products.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:secondbuy/View/FavList.dart';
import 'package:secondbuy/View/MyPurchase.dart';
import 'package:secondbuy/View/editProfile.dart';
import 'package:secondbuy/View/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondbuy/View/nav.dart';
import 'package:secondbuy/View/review.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> Logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Global.useruid = "";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Nav(page: "Homepage")),
      );
      Fluttertoast.showToast(
        msg: "Logout Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
      );
    } catch (ex) {
      print("Error : $ex");
    }
  }

  Future<dynamic> getData() async {
    try {
      final FirebaseUser user = await auth.currentUser();
      return FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(user.uid)
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
    } catch (e) {
      print(e);
    }
  }

  var i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getData(),
          // Must return type Future, eg. Future<User> getUser()
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // If data still loading
            if (i == 0) {
              if (snapshot.connectionState != ConnectionState.done) {
                // Return loading symbol
                i++;
                return Global.Loading("Loading...");
              }
            }

            // If no data
            if (!snapshot.hasData) {
              print("guest detected");
              return new Stack(
                children: <Widget>[
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 90,
                          color: Colors.black26,
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
                                  child: Text(
                                    "Guest",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                child: OutlineButton(
                                  child: Text("Login Now"),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                  },
                                  color: Colors.white,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 1,
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
                                  text: "Purchases",
                                ),
                                Tab(
                                  text: "Reviews",
                                ),
                              ]),
                        ),

                        //content
                        Expanded(
                          child: Container(
                            child: TabBarView(children: [
                              //show listing
                              Container(
                                child: notLogin(),
                              ),
                              //show purchases
                              Container(
                                child: notLogin(),
                              ),

                              //show review
                              Container(
                                child: notLogin(),
                              ),

                              //show about
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 40.0,
                    // (background container size) - (circle height / 2)
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
              );
            }

            // If got data
            User user = snapshot.data;
            print("user is logged in");
            // Display here
            return new Stack(
              children: <Widget>[
                DefaultTabController(
                  length: 4,
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FavList()),
                                      );
                                    })),
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
                                child: Text(
                                  user.username,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              child: OutlineButton(
                                child: Text("Edit Profile"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfile(
                                              id: user.id,
                                            )),
                                  );
                                },
                                color: Colors.white,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 45,
                              right: 10,
                              child: OutlineButton(
                                child: Text("Logout"),
                                onPressed: Logout,
                                color: Colors.white,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1,
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
                                text: "Purchases",
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
                            //show listing
                            Container(
                              child: Products(
                                  category: "",
                                  subCategory: "",
                                  sellerProd: true),
                            ),
                            //show purchases
                            Container(
                              child: MyPurchase(),
                            ),

                            //show review
                            Container(
                              child: MyReviews(),
                            ),

                            //show about
                            Container(
                              child: About(
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
                  left: 20,
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
    );
  }

  Widget notLogin() {
    return Container(
      margin: const EdgeInsets.only(top: 200.0),
      child: InkWell(
        child: Text(
          "Login now to view more",
          textAlign: TextAlign.center,
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
  }
}
