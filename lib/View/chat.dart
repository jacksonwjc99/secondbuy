import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:secondbuy/Model/Contact.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondbuy/View/login.dart';

import 'Chatting.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var uid;
  var i = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
        uid = userDB['id'];
        return userDB["id"];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Chat',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {},
          )
        ],
      ),
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
              return new Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 0.0),
                  child: InkWell(
                    child: Text(
                      "Login now to view more",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 25),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ),
              );
            }

            // If got data
            print("user is logged in");
            // Display here
            return new Stack(
              children: <Widget>[
                Container(
                  child: FutureBuilder<List<String>>(
                      future: GetContactCount(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Global.Loading("Loading your contact list");

                        if (!snapshot.hasData || snapshot.data.isEmpty) {
                          return Global.Message("No Contacts were found", 20,
                              Icons.info, 30, Colors.blue);
                        }

                        return Container(
                          child: FutureBuilder<List<Contact>>(
                              future: GetContactList(snapshot.data),
                              builder: (BuildContext context,
                                  AsyncSnapshot contactSnapshot) {
                                if (contactSnapshot.connectionState !=
                                    ConnectionState.done)
                                  return Global.Loading(
                                      "Loading your contact list");

                                if (!contactSnapshot.hasData) {
                                  return new Container(
                                    child: Text(
                                      "No Contacts Found",
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int thisIndex) {
                                    Contact contact =
                                        contactSnapshot.data[thisIndex];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Chatting(
                                                    contactID:
                                                        contact.contactID,
                                                    contactName:
                                                        contact.contactName,
                                                    contactPic:
                                                        contact.contactPic,
                                                    prodID: "",
                                                  )),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 15,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(40)),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  //shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1.5,
                                                      blurRadius: 5,
                                                    ),
                                                  ]),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    contact.contactPic
                                                        .toString()),
                                                backgroundColor: Colors.white,
                                                radius: 30,
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Column(children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(contact.contactName,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    contact.message,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                        );
                      }),
                ),
              ],
            );
          }),
    );
  }

  Widget notLogin() {
    return Center(
      child: Container(
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
      ),
    );
  }

  Future<List<String>> GetContactCount() async {
    var chatRef =
        FirebaseDatabase.instance.reference().child("chats").child(uid);
    List<String> contactFound = new List();
    print(uid);
    if (uid != "" && uid != null) {
      return chatRef.once().then((DataSnapshot snapshot) {
        try {
          snapshot.value.forEach((key, value) {
            String latestMsg = "";
            value.forEach((k, v) {
              latestMsg = v['msg'];
            });
            contactFound.add(latestMsg + "," + key);
          });
        } on NoSuchMethodError catch (e) {
          print(e.stackTrace);
        }
        print(contactFound);
        return new List.from(contactFound);
      });
    } else {
      return new List.from(contactFound);
    }
  }

  Future<List<Contact>> GetContactList(List<String> useruid) async {
    var userRef = FirebaseDatabase.instance.reference().child("users");

    return userRef.once().then((DataSnapshot snapshot) {
      List<Contact> contactList = new List();

      snapshot.value.forEach((key, value) {
        for (int i = 0; i < useruid.length; i++) {
          if (useruid[i].contains(key)) {
            contactList.add(new Contact(
              contactName: value['username'],
              contactPic: value['photoURL'],
              contactID: value['id'],
              message: useruid[i].substring(0, useruid[i].indexOf(',')),
            ));
          }
        }
      });

      return new List.from(contactList);
    });
  }
}
