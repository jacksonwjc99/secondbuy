import 'package:flutter/material.dart';

class About extends StatefulWidget {
  About({
    Key key,
    this.id,
    @required this.email,
    @required this.contact,
    @required this.address,
  }) : super(key: key);
  final String id;
  final String email;
  final String contact;
  final String address;

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  /*
  final FirebaseAuth auth = FirebaseAuth.instance;

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

   */

  @override
  Widget build(BuildContext context) {
    //getUserDetails();

    double c_width = MediaQuery.of(context).size.width * 0.94;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Product
                  new Container(
                    padding: const EdgeInsets.only(
                        left: 20.0, bottom: 10.0, top: 20.0),
                    child: new Text(
                      'About Me',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),

                  new Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: new Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.only(left: 30.0),
                    width: c_width,
                    child: new Text(widget.email.toString()),
                  ),
                  SizedBox(height: 30.0),

                  new Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: new Text(
                      'Contact',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.only(left: 30.0),
                    width: c_width,
                    child: new Text(widget.contact.toString()),
                  ),
                  SizedBox(height: 30.0),

                  new Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: new Text(
                      'Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.only(left: 30.0),
                    width: c_width,
                    child: new Text(widget.address.toString()),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
