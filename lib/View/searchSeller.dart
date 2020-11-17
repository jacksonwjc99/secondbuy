import 'package:flutter/material.dart';
import 'package:secondbuy/Model/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:secondbuy/View/nav.dart';
import 'package:secondbuy/View/sellerProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchSeller extends StatefulWidget {
  @override
  _SearchSellerState createState() => new _SearchSellerState();
}

class _SearchSellerState extends State<SearchSeller> {
  TextEditingController editingController = TextEditingController();

  var items = List<String>();

  @override
  void initState() {
    showUsername();
    super.initState();
  }

  void showUsername() async {
    List<String> x = await getUsername();
    items.addAll(x);
  }

  Future<List<String>> getUsername() {
    List<String> username = new List();
    return FirebaseDatabase.instance
        .reference()
        .child("users")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> userDB = snapshot.value;

      userDB.forEach((key, value) {
        if(value['username'] != name){
          username.add(value['username']);
        }
      });

      return username;
    });
  }

  void filterSearchResults(String query, List<String> username) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(username);
    if (query.isNotEmpty) {
      List<String> name = List<String>();
      dummySearchList.forEach((item) {
        if ((item.toLowerCase()).contains(query.toLowerCase())) {
          print(query);
          name.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(name);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(username);
      });
    }
  }

  var name;
  var i = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void setCurrentUsername() async {
    String username = await getCurrentUsername();
    if (i == 0) {
      setState(() {
        name = username;
      });
      print(name);
      i++;
    }
  }

  Future<String> getCurrentUsername() async {
    final FirebaseUser user = await auth.currentUser();
    return FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> userDB = snapshot.value;

      return userDB['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    setCurrentUsername();

    return Scaffold(
      appBar: AppBar(
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
                MaterialPageRoute(builder: (context) => Nav(page: "Hamepage")),
              );
            }),
      ),
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
            User user;
            List<String> username = new List();
            List<User> userlist = snapshot.data;
            userlist.forEach((element) {
              user = element;
              if(user.username != name){
                username.add(user.username);
              }

            });
            // Display here
            return new Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value, username);
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search for users",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${items[index]}'),
                        onTap: () {
                          userlist.forEach((element) {
                            if (element.username == items[index]) {
                              print(element.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SellerProfile(id: element.id)),
                              );
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }

  Future<dynamic> getData() {
    List<User> userlist = new List();
    return FirebaseDatabase.instance
        .reference()
        .child("users")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> userDB = snapshot.value;

      userDB.forEach((key, value) {
        var user = new User();
        user.address = value['address'];
        user.contact = value['contact'];
        user.email = value['email'];
        user.id = value['id'];
        user.password = value['password'];
        user.photoURL = value['photoURL'];
        user.username = value['username'];

        userlist.add(user);
      });

      return userlist;
    });
  }
}
