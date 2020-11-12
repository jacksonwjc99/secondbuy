import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secondbuy/Util/Components/about.dart';
import 'package:secondbuy/Util/Components/products.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:secondbuy/View/editProfile.dart';
import 'package:secondbuy/View/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondbuy/View/nav.dart';

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

  var isUserLogin = false;
  var i = 0;
  var username, address, contact, email, password, id, photoURL;

  getUserDetails() async {
    try {
      final FirebaseUser user = await auth.currentUser();

      FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(user.uid)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> userDB = snapshot.value;
        username = userDB['username'];
        address = userDB['address'];
        contact = userDB['contact'];
        email = userDB['email'];
        password = userDB['password'];
        photoURL = userDB['photoURL'];
        id = userDB['id'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserDetails();

    auth.currentUser().then((user) {
      if (user != null) {
        if (i == 0) {
          Global.getDBUser().then((dbUser) {
            if (dbUser != null) {
              print("user is logged in");
              print(username);
              setState(() {
                isUserLogin = true;
              });
            }
          });
          i++;
        }
      } else {
        print("guest detected");
        isUserLogin = false;
      }
    });

    int length = 0;

    if (isUserLogin == true)
      length = 4;
    else
      length = 3;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          DefaultTabController(
            length: length,
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

                if (isUserLogin == true)
                  isLoginButton(),
                if (isUserLogin == false)
                  notLoginButton(),

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
                        if (isUserLogin == true)
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
                      if (isUserLogin == true)
                        Container(
                          child: Products(
                              category: "", subCategory: "", sellerProd: true),
                        ),
                      if (isUserLogin == false)
                        notLogin(),

                      //show purchases
                      if (isUserLogin == true)
                        Container(
                          child: Text("My Purchases"),
                        ),
                      if (isUserLogin == false)
                        notLogin(),

                      //show review
                      if (isUserLogin == true)
                        Container(
                          child: Text("Reviews"),
                        ),
                      if (isUserLogin == false)
                        notLogin(),

                      //show about
                      if (isUserLogin == true)
                        Container(
                          child: About(
                              email: email, contact: contact, address: address),
                        ),
                    ]),
                  ),
                )
              ],
            ),
          ),
          if (isUserLogin == true) userProfilePic(),
          if (isUserLogin == false) guestProfilePic(),
        ],
      ),
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

  Widget userProfilePic() {
    return Positioned(
      top: 40.0, // (background container size) - (circle height / 2)
      left: 20,
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(photoURL),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.black45, width: 2)),
      ),
    );
  }

  Widget guestProfilePic() {
    return Positioned(
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
            border: Border.all(color: Colors.black45, width: 2)),
      ),
    );
  }

  Widget isLoginButton() {
    return Container(
      height: 100,
      color: Colors.black12,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 40.0,
            left: 25,
            child: Container(
              child: Text(
                username,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            id: id,
                          )),
                );
              },
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
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
                  borderRadius: new BorderRadius.circular(30.0)),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget notLoginButton() {
    return Container(
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 1,
              ),
            ),
          ),
        ],
      ),
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
