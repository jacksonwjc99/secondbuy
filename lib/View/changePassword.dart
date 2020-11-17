import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secondbuy/View/editProfile.dart';
import 'package:secondbuy/View/nav.dart';
import 'package:secondbuy/View/profile.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key, @required this.id}) : super(key: key);
  final String id;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String _newPassword;
  String _oldPassword;
  int _value = 1;

  final FirebaseAuth auth = FirebaseAuth.instance;

  final formkey = new GlobalKey<FormState>();

  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  var username, address, contact, email, password, id, photoURL;
  var i = 0;

  getUserDetails() {
    try {
      FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(widget.id)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> userDB = snapshot.value;
        if (i == 0) {
          setState(() {
            username = userDB['username'];
            address = userDB['address'];
            contact = userDB['contact'];
            email = userDB['email'];
            password = userDB['password'];
            photoURL = userDB['photoURL'];
            id = userDB['id'];
          });
          i++;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  changePassword() {
    if (checkFields()) {
      try {
        print(password);
        print(_oldPassword);
        print(_newPassword);
        if (password == _oldPassword) {
          FirebaseAuth.instance.currentUser().then((user) async {
            var credential = EmailAuthProvider.getCredential(
                email: user.email, password: password);
            var result = await user.reauthenticateWithCredential(credential);
            await result.user.updatePassword(_newPassword);
          }).catchError((e) {
            print(e);
          });

          final userRef =
              FirebaseDatabase().reference().child("users").child(widget.id);
          userRef.update({
            'password': _newPassword,
          });

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Nav(page: "Profile")),
          );
          Fluttertoast.showToast(
            msg: "Password has been changed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black45,
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserDetails();

    return new Scaffold(
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
              MaterialPageRoute(
                  builder: (context) => EditProfile(
                        id: widget.id,
                      )),
            );
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                  child: new Form(
                key: formkey,
                child: Center(
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Change Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      _newPassinput(
                          "required new password",
                          true,
                          "New Password",
                          'Enter your new password',
                          (value) => _newPassword = value,
                          TextInputType.text),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      _oldPassinput(
                          "required current password",
                          true,
                          "Current Password",
                          'Enter your current password',
                          (value) => _oldPassword = value,
                          TextInputType.text,
                          password),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 138.0, top: 8.0),
                          child: Row(
                            children: <Widget>[
                              OutlineButton(
                                child: Text("Change"),
                                onPressed: changePassword,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                              SizedBox(
                                height: 18.0,
                                width: 18.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _newPassinput(
      String validation, bool, String label, String hint, save, keyboard) {
    return new TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      obscureText: bool,
      validator: (value) {
        String errMsg;
        if (value.isNotEmpty) {
          Pattern pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value))
            errMsg = 'Contain 8 or more characters & numbers only';
          else {
            return null;
          }
          return errMsg;
        } else {
          return validation;
        }
      },
      onSaved: save,
      keyboardType: keyboard,
    );
  }

  Widget _oldPassinput(String validation, bool, String label, String hint, save,
      keyboard, password) {
    return new TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      obscureText: bool,
      validator: (value) {
        String errMsg;
        if (value.isEmpty) {
          return validation;
        } else {
          if (value != password) {
            errMsg = 'Current password is incorrect';
          }
          return errMsg;
        }
      },
      onSaved: save,
      keyboardType: keyboard,
    );
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class CustomContainer extends StatelessWidget {
  final String labelText;
  final BoxDecoration decoration;

  const CustomContainer({this.labelText, this.decoration});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 80,
        ),
        Positioned(
          bottom: 0,
          child: Container(width: 250, height: 50, decoration: decoration),
        ),
        Positioned(
          left: 10,
          bottom: 40,
          child: Container(color: Colors.white, child: Text(labelText)),
        )
      ],
    );
  }
}
