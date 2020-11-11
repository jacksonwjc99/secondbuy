//https://github.com/dvmjoshi/stuff

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secondbuy/View/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:secondbuy/View/main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignupPageSate createState() => _SignupPageSate();
}

class _SignupPageSate extends State<SignUpPage> {
  String _email;
  String _password;
  String _username;
  String _contact;
  int _value = 1;

  List<String> _dropdownItems = [
    "Johor",
    "Kedah",
    "Kelantan",
    "Melacca",
    "Negeri Sembilan",
    "Pahang",
    "Penang",
    "Perak",
    "Sabah",
    "Sarawak",
    "Selangor",
    "Terengganu",
    "Kuala Lumpur",
    "Labuan",
    "Putrajaya",
  ];

  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedItem;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem<String>(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

  final formkey = new GlobalKey<FormState>();

  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  createUser() async {
    if (checkFields()) {
      try {
        AuthResult result = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        final FirebaseUser user = result.user;

        final userRef = FirebaseDatabase().reference()
            .child("users")
            .child(user.uid);
        print(user.uid + " " + _email + " " + _username + " " + _password + " " + _contact + " " + _selectedItem.toString());
        userRef.set({
          'address' : _selectedItem.toString(),
          'contact' : _contact,
          'email' : _email,
          'password' : _password,
          'id' : user.uid,
          'username' : _username,
          'photoURL' : "https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg",
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => App()),
        );
        Fluttertoast.showToast(
          msg: "Register Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
        );
      }
      catch(e) {
        print(e);
        Fluttertoast.showToast(
          msg: "Email has been registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            child: Image.asset(
              'icons/logo2.png',
              scale: 0.5,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                  child: new Form(
                    key: formkey,
                    child: Center(
                      child: new ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          _emailInput(
                              "required email",
                              false,
                              "Email",
                              'Enter your Email',
                                  (value) => _email = value,
                              TextInputType.text),
                          SizedBox(
                            width: 20.0,
                            height: 20.0,
                          ),
                          _charInput(
                              "required username",
                              false,
                              "Username",
                              'Enter your Username',
                                  (value) => _username = value,
                              TextInputType.text),
                          SizedBox(
                            width: 20.0,
                            height: 20.0,
                          ),
                          _passwordInput(
                              "required password",
                              true,
                              "Password",
                              'Enter your Password',
                                  (value) => _password = value,
                              TextInputType.text),
                          SizedBox(
                            width: 20.0,
                            height: 20.0,
                          ),
                          _contactInput(
                              "required contact number",
                              false,
                              "Contact No.",
                              'Enter your Contact',
                                  (value) => _contact = value,
                              TextInputType.phone),
                          SizedBox(
                            width: 20.0,
                            height: 20.0,
                          ),

                          Container(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(width: 0.5)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: _selectedItem,
                                  items: _dropdownMenuItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedItem = value;
                                    });
                                  }
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 138.0, top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  OutlineButton(
                                    child: Text("Sign Up"),
                                    onPressed:
                                    createUser,

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

  Widget _emailInput(
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
          Pattern pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value))
            errMsg = 'Incorrect Email Format (abc@mail.com)';
          else
            return null;
          return errMsg;
        }else{
          return validation;
        }
      },
      onSaved: save,
      keyboardType: keyboard,
    );
  }

  Widget _charInput(String validation, bool, String label, String hint, save,
      keyboard) {
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
          Pattern pattern = r'^[a-zA-Z ]*$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value))
            errMsg = 'Username must be letter & space only';
          else
            return null;
          return errMsg;
        }else{
          return validation;
        }
      },
      onSaved: save,
      keyboardType: keyboard,
    );
  }

  Widget _contactInput(
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
          Pattern pattern = r'^[0-9]{10,11}$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value))
            errMsg = 'Contact must be within 10 or 11 digits';
          else
            return null;
          return errMsg;
        }else{
          return validation;
        }
      },
      onSaved: save,
      keyboardType: keyboard,
    );
  }

  Widget _passwordInput(
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
          else
            return null;
          return errMsg;
        } else {
          return validation;
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
