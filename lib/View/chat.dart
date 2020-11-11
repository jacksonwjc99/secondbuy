import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:secondbuy/Model/Contact.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Chatting.dart';

class Chat extends StatefulWidget {

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
        title: Text('Chat'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: FutureBuilder<List<String>>(
            future: GetContactCount(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return Global.Loading("Loading your contact list");

              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Global.Message("No Contacts were found", 20, Icons.info, 30, Colors.blue);
              }


              return Container (
                child: FutureBuilder<List<Contact>>(
                    future: GetContactList(snapshot.data),
                    builder: (BuildContext context, AsyncSnapshot contactSnapshot) {
                      if (contactSnapshot.connectionState != ConnectionState.done)
                        return Global.Loading("Loading your contact list");

                      if (!contactSnapshot.hasData) {
                        return new Container (
                          child: Text(
                            "No Contacts Found",
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int thisIndex) {
                          Contact contact = contactSnapshot.data[thisIndex];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Chatting(contactID : contact.contactID, contactName: contact.contactName, contactPic: contact.contactPic, prodID: "",)),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(40)),
                                        border: Border.all(
                                          width: 2,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        //shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1.5,
                                            blurRadius: 5,
                                          ),
                                        ]
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(contact.contactPic.toString()),
                                      backgroundColor: Colors.white,
                                      radius: 30,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.65,
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(contact.contactName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          SizedBox(height:10),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              contact.message,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                ),
              );
            }
        ),
      ),
    );

  }



  Future<List<String>> GetContactCount() async{
    var chatRef = FirebaseDatabase.instance.reference().child("chats").child(uid);
    List<String> contactFound = new List();

    if (uid != "") {
      return chatRef.once().then((DataSnapshot snapshot) {
        try{
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
        return new List.from(contactFound);
      });
    }
    else {
      return new List.from(contactFound);
    }

  }

  Future<List<Contact>> GetContactList(List<String> useruid) async {
    var userRef = FirebaseDatabase.instance.reference().child("users");

    return userRef.once().then((DataSnapshot snapshot) {
      List<Contact> contactList = new List();

      snapshot.value.forEach((key, value) {
        for(int i=0 ; i<useruid.length ; i++){
          if(useruid[i].contains(key)) {
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